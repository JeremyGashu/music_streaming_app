import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart'
    as mds;
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
// import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

class DownloadListItem extends StatefulWidget {
  final LocalDownloadTask downloadTask;
  final bool completed;
  DownloadListItem({@required this.downloadTask, this.completed = false})
      : assert(downloadTask != null);

  @override
  _DownloadListItemState createState() => _DownloadListItemState();
}

class _DownloadListItemState extends State<DownloadListItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaDownloaderBloc, MediaDownloaderState>(
      
      builder: (context, state) {
        return ListTile(
          onTap: () {
            if (widget.downloadTask.progress == 100.0) {
              playAudio();
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => SingleTrackPlayerPage(track: null),
              // ));
            }
          },
          title: Text("${widget.downloadTask.title}"),
          leading: Container(
            width: 40,
            height: 40,
            child: widget.downloadTask.coverImageUrl != null ? Image.network(
              widget.downloadTask.coverImageUrl,
            ) : Container(),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.completed
                    ? "completed"
                    : "${widget.downloadTask.progress.toStringAsFixed(1)} %",
              ),
              SizedBox(
                height: 5,
              ),
              widget.completed
                  ? SizedBox()
                  : state is mds.DownloadFailed ? Text('Failed', style: TextStyle(color: Colors.red, ),) : LinearProgressIndicator(
                      value: widget.downloadTask.progress / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(kYellow),
                      backgroundColor: kYellow.withOpacity(0.2),
                    )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete file"),
                      content: Text("Do you want to delete this file"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("no")),
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<UserDownloadBloc>(context).add(
                                  DeleteDownload(trackId: widget.downloadTask.songId));
                              Navigator.pop(context);
                            },
                            child: Text("yes")),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 20,
                ),
              ),
              state is mds.DownloadFailed
                    ? IconButton(
                        onPressed: () async {
                          // BlocProvider.of<UserDownloadBloc>(context).add(
                          //         DeleteDownload(trackId: downloadTask.songId));
                          // UserDownloadManager manager = getIt<UserDownloadManager>();
                          // print(await manager.getTaskById(widget.downloadTask.songId));
                          // BlocProvider.of<UserDownloadBloc>(context).add(
                          //     StartDownload(
                          //         track: widget.downloadTask.toTrack())); // showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     title: Text("Delete file"),
                          //     content: Text("Do you want to delete this file"),
                          //     actions: [
                          //       TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text("no")),
                          //       TextButton(
                          //           onPressed: () {
                          //             BlocProvider.of<UserDownloadBloc>(context)
                          //                 .add(DeleteDownload(trackId: downloadTask.songId));
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text("yes")),
                          //     ],
                          //   ),
                          // );

                          // BlocProvider.of<UserDownloadBloc>(context)
                          //     .add(StartDownload(track: music));
                        },
                        icon: Icon(
                          Icons.update,
                          size: 20,
                        ),
                      )
                    : Container(),
              // : Container(),
            ],
          ),
        );
      }
    );
  }

  void playAudio() async {
    Track track=widget.downloadTask.toTrack();
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
      playSong(context, position);
    }
  }

  Future<void> playSong(context, Duration position) async {
    Track track=widget.downloadTask.toTrack();
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
      print("${track.songId}: downloaded");
      source = '$dir/${track.songId}/main.m3u8';
    }

    mediaItems.add(MediaItem(
        id: track.songId,
        album: '',
        title: track.title,
        genre: '${track.genre.name}',
        artist:
            '${track.artist.firstName} ${track.artist.lastName}',
        duration: Duration(seconds: track.duration),
        artUri: Uri.parse(track.coverImageUrl),
        extras: {'source': source}));

    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(track.songId)) || !(await LocalHelper.allSegmentsDownloaded(id : track.songId))) {
      File m3u8File = File('$dir/${track.songId}/main.m3u8');
      HlsMediaPlaylist hlsPlayList ;
      if(m3u8File.existsSync()) {
        hlsPlayList = await parseHLS.parseHLS(m3u8File.readAsStringSync());
      }
      else{
        hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile('$M3U8_URL/${track.songId}',
                  '$dir/${track.songId}', "main.m3u8"))
          .readAsStringSync());
      }

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
        
        await parseHLS.updateLocalM3u8(m3u8FilePath);
        print("mediaItems: ${mediaItems}");
        print("the file is downloaded playing from local: ${mediaItems}");
        await parseHLS.writeLocalM3u8File(m3u8FilePath);
      } else {
        HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
                await parseHLS.downloadFile('$M3U8_URL/${track.songId}',
                    '$dir/${track.songId}', "main.m3u8"))
            .readAsStringSync());

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

      // await parseHLS.updateLocalM3u8(m3u8FilePath);
      // print("mediaItems: ${mediaItems}");
      // print("the file is downloaded playing from local: ${mediaItems}");
      // await parseHLS.writeLocalM3u8File(m3u8FilePath);
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
