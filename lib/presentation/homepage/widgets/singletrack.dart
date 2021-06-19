import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

class SingleTrack extends StatefulWidget {
  final Track track;
  SingleTrack({@required this.track});

  @override
  _SingleTrackState createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          /// Start playing the audio
          playSingleTrack(context, widget.track);

          /// Pass the track data to [SingletrackPlayer] page
          /// using state.track
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleTrackPlayerPage(
                        track: Track(),
                      )));
        },
        child: Container(
          width: 140,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 140,
              height: 120,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                    imageUrl: widget.track.song.coverImageUrl,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/images/singletrack_one.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                    width: 140.0,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '${widget.track.album.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${widget.track.album.artist.firstName} ${widget.track.album.artist.lastName}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kGray,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    '${prettyDuration(Duration(
                      seconds: widget.track.song.duration,
                    ))}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kYellow,
                        fontSize: 12.0),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

void playSingleTrack(BuildContext context, Track track,
    [Duration position]) async {
  String dir = (Theme.of(context).platform == TargetPlatform.android
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory())
      .path;
  var m3u8FilePath;

  final id = track.song.songId;

  var box = await Hive.openBox("downloadedMedias");
  var trackDownloaded = await box.get("$id");
  print("ID: $id");

  ParseHls parseHLS = ParseHls();
  HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
          await parseHLS.downloadFile(
              'https://138.68.163.236:8787/track/${track.song.songId}',
              '$dir/$id',
              "main.m3u8"))
      .readAsStringSync());
  List<DownloadTask> downloadTasks = [];
  // print(hlsPlayList.segments);
  hlsPlayList.segments.forEach((segment) {
    var segmentIndex = hlsPlayList.segments.indexOf(segment);
    downloadTasks.add(DownloadTask(
        track_id: id,
        segment_number: segmentIndex,
        downloadType: DownloadType.media,
        downloaded: false,
        download_path: '$dir/${track.song.songId}/',
        url: segment.url));
  });
  // print("DownloadTasks: ");
  // print(downloadTasks);

  print("trackDownloaded: $trackDownloaded");
  bool playFromLocal = trackDownloaded != null;
  if (playFromLocal) {
    /// TODO: check if all segments presented before playing from local storage
    print("playing from local");
    m3u8FilePath = '$dir/${track.song.songId}/main.m3u8';
    await parseHLS.updateLocalM3u8(m3u8FilePath);
  } else {
    print("playing from remote");
    m3u8FilePath = 'https://138.68.163.236:8787/track/${track.song..songId}';

    /// TODO: Start download here
    BlocProvider.of<MediaDownloaderBloc>(context)
        .add(AddDownload(downloadTasks: downloadTasks));
  }

  MediaItem _mediaItem = MediaItem(
      id: track.song.songId,
      album: track.album.albumId,
      title: track.song.title,
      genre: 'genre goes here',
      artist: track.album.artist.firstName,
      duration: Duration(milliseconds: track.song.duration),
      artUri: Uri.parse(track.song.coverImageUrl),
      // extras: {'source': m3u8FilePath});
      extras: {'source': m3u8FilePath});

  MediaItem _mediaItem2 = MediaItem(
      id: track.song.songId + '2',
      album: track.album.albumId,
      title: track.song.title,
      genre: 'genre goes here',
      artist: track.album.artist.firstName,
      duration: Duration(milliseconds: track.song.duration),
      artUri: Uri.parse(track.song.coverImageUrl),
      // extras: {'source': m3u8FilePath});
      extras: {'source': m3u8FilePath});

  MediaItem _mediaItem3 = MediaItem(
      id: track.song.songId + '3',
      album: track.album.albumId,
      title: track.song.title,
      genre: 'genre goes here',
      artist: track.album.artist.firstName,
      duration: Duration(milliseconds: track.song.duration),
      artUri: Uri.parse(track.song.coverImageUrl),
      // extras: {'source': m3u8FilePath});
      extras: {'source': m3u8FilePath});

  MediaItem _mediaItem4 = MediaItem(
      id: track.song.songId + '4',
      album: track.album.albumId,
      title: track.song.title,
      genre: 'genre goes here',
      artist: track.album.artist.firstName,
      duration: Duration(milliseconds: track.song.duration),
      artUri: Uri.parse(track.song.coverImageUrl),
      // extras: {'source': m3u8FilePath});
      extras: {'source': m3u8FilePath});

  if (AudioService.running) {
    if (playFromLocal)
      await parseHLS.decryptFile(
          "${await LocalHelper.getFilePath(context)}/$id/enc.key.aes");
    await AudioService.playFromMediaId(id);
    if (playFromLocal)
      await parseHLS
          .encryptFile("${await LocalHelper.getFilePath(context)}/$id/enc.key");
  } else {
    if (await AudioService.start(
      backgroundTaskEntrypoint: backgroundTaskEntryPoint,
      androidNotificationChannelName: 'Playback',
      androidNotificationColor: 0xFF2196f3,
      androidStopForegroundOnPause: true,
      androidEnableQueue: true,
    )) {
      final List<MediaItem> queue = [];
      queue.add(_mediaItem);
      queue.add(_mediaItem2);
      queue.add(_mediaItem3);
      queue.add(_mediaItem4);

      await AudioService.updateMediaItem(queue[0]);
      await AudioService.updateQueue(queue);

      await AudioService.playFromMediaId(id);

      if (position != null) AudioService.seekTo(position);
    }
  }
}
