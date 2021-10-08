import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/blocs/local_database/local_database_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_state.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/service_locator.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';

class UserDownloadBloc extends Bloc<UserDownloadEvent, UserDownloadState> {
  final Dio dio;
  UserDownloadBloc({this.dio}) : super(UserDownloadInitial());

  @override
  Stream<UserDownloadState> mapEventToState(UserDownloadEvent event) async* {
    print("HERER");
    try {
      if (event is Init) {
        // var box = await Hive.openBox<LocalDownloadTask>('user_downloads');
      }
      if (event is StartDownload) {
        try {
          ParseHls parseHLS = ParseHls();
          var dir = await LocalHelper.getLocalFilePath();
          HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
                  await parseHLS.downloadFile(
                      '$M3U8_URL/${event.track.songId}',
                      '$dir/${event.track.songId}',
                      "main.m3u8"))
              .readAsStringSync());
          // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
          List<DownloadTask> downloadTasks = [];
          List<String> segmentUrls = [];
          
          // print(hlsPlayList.segments);
          hlsPlayList.segments.forEach((segment) {
            var segmentIndex = hlsPlayList.segments.indexOf(segment);
            downloadTasks.add(DownloadTask(
                track_id: event.track.songId,
                segment_number: segmentIndex,
                downloadType: DownloadType.media,
                downloaded: false,
                download_path: '$dir/${event.track.songId}/',
                url: segment.url));
            segmentUrls.add(segment.url);
          });
          print(downloadTasks);
          var segmentBox = await Hive.openBox("download_segments");
          segmentBox.put(event.track.songId, segmentUrls);
          var box = await Hive.openBox<LocalDownloadTask>("user_downloads");
          // MediaDownloaderBloc mediaDownloaderBloc = getIt();
          getIt<MediaDownloaderBloc>().add(AddDownload(downloadTasks: downloadTasks));
          box.put(
              event.track.songId,
              LocalDownloadTask(
                  songId: event.track.songId,
                  title: event.track.title ?? 'Unknown',
                  coverImageUrl: event.track.coverImageUrl,
                  songUrl: event.track.songUrl,
                  duration: event.track.duration,
                  artistFirstName: event.track.artist != null? event.track.artist.firstName :'',
                  artistLastName :event.track.artist != null? event.track.artist.lastName :'Unknown Artist',
                  genre: event.track.genre != null ? event.track.genre.name : '',
                  ));
          LocalDatabaseBloc(mediaDownloaderBloc: getIt<MediaDownloaderBloc>());
        } catch (e) {
          yield DownloadFailed('Can\'t Download this File!');
        }
      }
      if (event is DeleteDownload) {
        var userDownloadBox =
            await Hive.openBox<LocalDownloadTask>('user_downloads');
        var segmentBox = await Hive.openBox('download_segments');
        var downloadedMediaBox = await Hive.box('downloadedMedias');
        segmentBox.delete(event.trackId);
        downloadedMediaBox.delete(event.trackId);
        userDownloadBox.delete(event.trackId);
        String dir = await LocalHelper.getLocalFilePath();
        final directory = Directory("$dir/${event.trackId}");
        directory.delete(recursive: true);
        yield DownloadDeleted();
      }
    } catch (error, stacktrace) {
      print("ERROR DOWNLOADING FILE");
      print(error);
      print(stacktrace);
      yield DownloadFailed('Can\t Download File!');
    }
  }
}
