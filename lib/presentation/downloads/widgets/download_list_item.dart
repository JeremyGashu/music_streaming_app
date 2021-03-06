import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart'
    as mds;
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_bloc.dart';
import 'package:streaming_mobile/blocs/user_downloads/user_download_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
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
  bool isBeingDeleted = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaDownloaderBloc, MediaDownloaderState>(
        builder: (context, state) {
      return !isBeingDeleted
          ? ListTile(
              onTap: () {
                if (widget.downloadTask.progress == 100.0) {
                  playAudio();
                }
              },
              title: Text("${widget.downloadTask.title}"),
              leading: Card(
                color: Colors.transparent,
                elevation: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: widget.downloadTask.coverImageUrl != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                            imageUrl: widget.downloadTask.coverImageUrl,
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/artist_placeholder.png',
                                fit: BoxFit.fill,
                              );
                            },
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.completed
                        ? '${widget.downloadTask.artistFirstName} ${widget.downloadTask.artistLastName}'
                        : "${widget.downloadTask.progress.toStringAsFixed(1)} %",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  widget.completed
                      ? SizedBox()
                      : state is mds.DownloadFailed &&
                              state.id == widget.downloadTask.songId
                          ? Text(
                              'Failed',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : LinearProgressIndicator(
                              value: widget.downloadTask.progress / 100,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kYellow),
                              backgroundColor: kYellow.withOpacity(0.2),
                            )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.downloadTask.progress == 100
                      ? Text(prettyDuration(
                          Duration(seconds: widget.downloadTask.duration ?? 0)))
                      : Container(),
                  widget.downloadTask.progress == 100
                      ? IconButton(
                          onPressed: () async {
                            String playingMusicId =
                                await AudioService.currentMediaItem != null
                                    ? await AudioService.currentMediaItem.id
                                    : '';
                            if (playingMusicId == widget.downloadTask.songId) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please stop the song first!',
                                  ),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Deleting',
                                ),
                                action: SnackBarAction(
                                  textColor: Colors.orange,
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      isBeingDeleted = !isBeingDeleted;
                                    });
                                  },
                                ),
                              ),
                            );
                            setState(() {
                              isBeingDeleted = !isBeingDeleted;
                              Timer(Duration(seconds: 4), () {
                                if (isBeingDeleted) {
                                  BlocProvider.of<UserDownloadBloc>(context)
                                      .add(DeleteDownload(
                                          trackId: widget.downloadTask.songId));
                                }
                              });
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.orange,
                          ),
                        )
                      : Container(),
                  widget.downloadTask.progress != 100
                      ? IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Cance Download"),
                                content: Text(
                                    "Do you want to cancel this download?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        BlocProvider.of<UserDownloadBloc>(
                                                context)
                                            .add(DeleteFailedDownload(
                                                track: widget.downloadTask
                                                    .toTrack()));
                                      },
                                      child: Text("Yes")),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                        )
                      : Container(),
                  // state is mds.DownloadFailed && state.id == widget.downloadTask.songId ? Icon(Icons.update) : Container(),
                  // : Container(),
                ],
              ),
            )
          : Container();
    });
  }

  void playAudio() async {
    Track track = widget.downloadTask.toTrack();
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
    try {
      Track track = widget.downloadTask.toTrack();
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

      if (await LocalHelper.isFileDownloaded(track.songId) &&
          await LocalHelper.allSegmentsDownloaded(id: track.songId)) {
        print("${track.songId}: downloaded");
        source = '$dir/${track.songId}/main.m3u8';
      }

      ParseHls parseHLS = ParseHls();

      mediaItems.add(MediaItem(
          id: track.songId,
          album: '',
          title: track.title,
          genre: '${track.genre.name}',
          artist: '${track.artist.firstName} ${track.artist.lastName}',
          duration: Duration(seconds: track.duration),
          artUri: Uri.parse(track.coverImageUrl),
          extras: {'source': source}));

      print("mediaItems: ${mediaItems}");
      if (!(await LocalHelper.isFileDownloaded(track.songId)) ||
          !(await LocalHelper.allSegmentsDownloaded(id: track.songId))) {
        BlocProvider.of<UserDownloadBloc>(context)
            .add(StartDownload(track: track));
      } else {
        var m3u8FilePath = '$dir/${track.songId}/main.m3u8';

        File file = File(m3u8FilePath);
        if (file.existsSync()) {
          await parseHLS.updateLocalM3u8(m3u8FilePath);
          print("mediaItems: ${mediaItems}");
          print("the file is downloaded playing from local: ${mediaItems}");
          await parseHLS.writeLocalM3u8File(m3u8FilePath);
        } else {
          BlocProvider.of<UserDownloadBloc>(context)
              .add(StartDownload(track: track));
        }
      }

      await _startPlaying(mediaItems);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing song!')));
      Navigator.pop(context);
      throw Exception(e);
    }
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
