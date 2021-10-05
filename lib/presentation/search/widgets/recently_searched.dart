import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class RecentlyeSearched extends StatefulWidget {
  @override
  _RecentlyeSearchedState createState() => _RecentlyeSearchedState();
}

class _RecentlyeSearchedState extends State<RecentlyeSearched> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Track>>(
        future: Hive.openBox<Track>('recently_searched'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.values.length == 0
                ? Center(
                    child: Text('No recently searched song found!'),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(4),
                    itemCount:
                        snapshot.data.length > 3 ? 3 : snapshot.data.length,
                    itemBuilder: (context, index) {
                      Track track = snapshot.data.values
                          .toList()
                          .reversed
                          .toList()[index];
                      return musicTile(track, () {
                        playAudio(track);
                      }, context);
                    });
          }

          return Center(
              child: SpinKitRipple(
            color: Colors.grey,
            size: 40,
          ));
        });
  }

  void playAudio(Track track) async {
    if (AudioService.playbackState.playing) {
      if (track.songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.pushNamed(
            context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
            arguments: track);
        return;
      }
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print("audio service not running");
      int pos = sharedPreferences.getInt('position');
      Duration position = Duration(seconds: 0);
      if (pos != null) {
        position = Duration(seconds: pos);
      }
      playSong(context, position, track);
    }
  }

  Future<void> playSong(context, Duration position, Track track) async {
    Navigator.pushNamed(
        context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
        arguments: track);
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    // print("tracks length: ${widget.tracks.length}");
    // print("index: $index");
    // print("tracks: ${widget.tracks}");
    // print("trackId: ${widget.tracks[0].songId}");
    // print("songId: ${widget.tracks[0].songId}");

    String source = '$M3U8_URL/${track.songId}';

    if (await LocalHelper.isFileDownloaded(track.songId) && await LocalHelper.allSegmentsDownloaded(id : track.songId)) {
      source = '$dir/${track.songId}/main.m3u8';
    }

    mediaItems.add(MediaItem(
        id: track.songId,
        album: '',
        title: track.title,
        genre: track.genre != null ? '${track.genre.name}' : 'Unknown',
        artist: track.artist != null
            ? '${track.artist.firstName} ${track.artist.lastName}'
            : 'Unknown Artist',
        duration: Duration(seconds: track.duration),
        artUri: Uri.parse(track.coverImageUrl),
        extras: {'source': source}));

    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(track.songId)) || !(await LocalHelper.allSegmentsDownloaded(id : track.songId))) {
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile('$M3U8_URL/${track.songId}',
                  '$dir/${track.songId}', "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: track.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${track.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${track.songId}/main.m3u8';

      File file = File(m3u8FilePath);
      if (file.existsSync()) {
        /// TODO: uncomment for encryption key download
      await parseHLS.updateLocalM3u8(m3u8FilePath);
      print("mediaItems: ${mediaItems}");
      print("the file is downloaded playing from local: ${mediaItems}");
      await parseHLS.writeLocalM3u8File(m3u8FilePath);
      }
      else{
        HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile('$M3U8_URL/${track.songId}',
                  '$dir/${track.songId}', "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: track.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${track.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
      }

      
    }

    await _startPlaying(mediaItems);
  }

  _startPlaying(mediaItems) async {
    if (AudioService.running) {
      print("running");
      await AudioService.updateQueue(mediaItems);
      await AudioService.playMediaItem(mediaItems[0]);
    } else {
      if (await AudioService.start(
        backgroundTaskEntrypoint: backgroundTaskEntryPoint,
        androidNotificationChannelName: 'Playback',
        androidNotificationColor: 0xFF2196f3,
        androidStopForegroundOnPause: true,
        androidEnableQueue: true,
      )) {
        await AudioService.updateQueue(mediaItems);
        await AudioService.playMediaItem(mediaItems[0]);
      }
    }
  }
}
