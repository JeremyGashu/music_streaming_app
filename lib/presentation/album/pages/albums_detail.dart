import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/player_overlay.dart';
import 'package:streaming_mobile/presentation/common_widgets/search_bar.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class AlbumDetail extends StatefulWidget {
  static const String albumDetailRouterName = 'album_detail_router_name';
  final Album album;
  AlbumDetail({this.album});
  @override
  _AlbumDetailState createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              //upper section containing the image, svg, shuffle button and healing track
              upperSection(context, album: widget.album),
              SizedBox(
                height: 20,
              ),
              // albumStat(album: widget.album),
              // SizedBox(
              //   height: 8,
              // ),
              // Divider(
              //   height: 1,
              //   color: Colors.grey.withOpacity(0.8),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(30),
              //   child: Container(
              //     width: 160,
              //     height: 40,
              //     child: TextButton(
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all<Color>(
              //           Colors.deepPurple,
              //         ),
              //       ),
              //       onPressed: () async {
              //         // TODO: play album
              //         if (widget.album.tracks.length == 0) {
              //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //               content:
              //                   Text('There are no tracks in this Album.')));
              //         } else {
              //           if (!AudioService.running) {
              //             await AudioService.start(
              //               backgroundTaskEntrypoint: backgroundTaskEntryPoint,
              //               androidNotificationChannelName: 'Playback',
              //               androidNotificationColor: 0xFF2196f3,
              //               androidStopForegroundOnPause: true,
              //               androidEnableQueue: true,
              //             );
              //           }
              //           await AudioService.setShuffleMode(
              //               AudioServiceShuffleMode.all);
              //           playAudio(Random().nextInt(widget.album.tracks.length),
              //               sharedPreferences);
              //         }
              //       },
              //       child: Padding(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 10,
              //         ),
              //         child: Text(
              //           'Shuffle Play',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 15,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              //ad section
              // _adContainer('ad.png'),
              SizedBox(
                height: 15,
              ),
              searchBar(),
              SizedBox(
                height: 15,
              ),
              Container(
                child: StreamBuilder(
                    stream: AudioService.currentMediaItemStream,
                    builder: (context, AsyncSnapshot<MediaItem> snapshot) {
                      print("Snapshot: ${snapshot.data}");
                      print(snapshot.hasData &&
                          (snapshot.data.id == widget.album.tracks[0].songId));
                      // print(snapshot.hasData &&
                      //     (snapshot.data.id == tracks[0].data.id));
                      return StreamBuilder(
                        stream: AudioService.playbackStateStream,
                        builder: (context,
                                AsyncSnapshot<PlaybackState>
                                    playbackSnapshot) =>
                            Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.album.tracks.length,
                                itemBuilder: (context, index) {
                                  return musicTile(widget.album.tracks[index], () {
                                    print("play playlist");
                                    playAudio(index, sharedPreferences);
                                  },
                                      snapshot.hasData &&
                                          (snapshot.data.id ==
                                              widget.album.tracks[index].songId) &&
                                          playbackSnapshot.hasData &&
                                          playbackSnapshot.data.playing);
                                }),
                            SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder(
            stream: AudioService.playbackStateStream,
            builder: (context, AsyncSnapshot<PlaybackState> snapshot) {
              if (snapshot.hasData) {
                print("SnapshotData: ${snapshot.data.processingState}");
              }
              if (snapshot.hasData) {
                var snapShotData = snapshot.data.processingState;
                if (snapShotData != AudioProcessingState.stopped) {
                  return StreamBuilder(
                      stream: AudioService.currentMediaItemStream,
                      builder: (context,
                          AsyncSnapshot<MediaItem> currentMediaItemSnapshot) {
                        return currentMediaItemSnapshot.hasData &&
                                currentMediaItemSnapshot.data != null
                            ? PlayerOverlay(playing: snapshot.data.playing)
                            : SizedBox();
                      });
                }
              }
              return SizedBox();
            },
          ),
        ),
      ]),
    ));

    
  }

  Widget upperSection(context, {Album album}) {
    int duration = 0;
    album.tracks.forEach((element) { 
      duration += element.duration;
    });
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 120,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 90,
                                height: 90,
                                child: Image.asset(
                                  'assets/images/album.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                      imageUrl: album.coverImageUrl,
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          'assets/images/album_one.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      width: 140.0,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.4,
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        width: 140.0,
                                        height: 120,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SvgPicture.asset('assets/svg/playlist.svg'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      album.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                        album.tracks != null
                            ? '${album.tracks.length} Tracks'
                            : '0 Tracks',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        if(AudioService.playbackState.playing) {
                          Navigator.pushNamed(context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName);
                          return;
                        }
                        if (album.tracks.length == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('There are no tracks in this Album.')));
                        } else {
                          if (!AudioService.running) {
                            await AudioService.start(
                              backgroundTaskEntrypoint:
                                  backgroundTaskEntryPoint,
                              androidNotificationChannelName: 'Playback',
                              androidNotificationColor: 0xFF2196f3,
                              androidStopForegroundOnPause: true,
                              androidEnableQueue: true,
                            );
                          }
                          await AudioService.setShuffleMode(
                              AudioServiceShuffleMode.all);
                          playAudio(
                              Random().nextInt(widget.album.tracks.length),
                              sharedPreferences);
                        }
                      },
                      child: Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.purple.shade500, width: 2.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shuffle,
                              color: Colors.purple.shade500,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Shuffle Play',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.purple.shade500,
                                )),
                          ],
                        ),
                      ),
                    ),
                    //Shuffle button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              album.tracks != null
                  ? '${album.tracks.length} Songs, ${prettyDuration(Duration(seconds: duration))}'
                  : '',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                    album.likeCount != null ? album.likeCount.toString() : '0'),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

  void playAudio(int index, SharedPreferences prefs) async {
    if (AudioService.playbackState.playing) {
      if (widget.album.tracks[index].songId == AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
            Navigator.pushNamed(context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName, arguments: widget.album.tracks[index]);
        return;
      }
    }

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print("audio service not running");
      int pos = sharedPreferences.getInt('position');
      Duration position = Duration(seconds: 0);
      if (pos != null) {
        position = Duration(seconds: pos);
      }
      playAlbum(context, position, index);
    }
    // else{
    //   AudioService.play();
    //   print("here");
    // }
  }

  Future<void> playAlbum(context, Duration position, index) async {
    Navigator.pushNamed(context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName, arguments: widget.album.tracks[index]);
    var dir = await LocalHelper.getFilePath(context);
    // create mediaItem list
    List<MediaItem> mediaItems = [];
    print("tracks length: ${widget.album.tracks.length}");
    print("index: $index");
    print("tracks: ${widget.album.tracks}");
    print("trackId: ${widget.album.tracks[0].songId}");
    print("songId: ${widget.album.tracks[0].songId}");

    for (Track track in widget.album.tracks) {
      print("trackId: ${track.songId}");
      String source = 'https://138.68.163.236:8787/track/${track.songId}';
      if (await LocalHelper.isFileDownloaded(track.songId)) {
        print("${track.songId}: downloaded");
        source = '$dir/${track.songId}/main.m3u8';
      }

      print("Source: $source");
      mediaItems.add(MediaItem(
          id: track.songId,
          album: '',
          title: track.title,
          genre: 'genre goes here',
          // artist: track.artist.firstName,
          duration: Duration(seconds: track.duration),
          artUri: Uri.parse(track.coverImageUrl),
          // extras: {'source': m3u8FilePath});
          extras: {'source': source}));
    }

    // await tracks.forEach((element) async {
    //   String source = element.data.trackUrl;
    //   if (await LocalHelper.isFileDownloaded(element.data.id)) {
    //     print("${element.data.id}: downloaded");
    //     source = '$dir/${element.data.id}/main.m3u8';
    //   }
    //   print("Source: $source");
    //   mediaItems.add(MediaItem(
    //       id: element.data.id,
    //       album: element.data.albumId,
    //       title: element.data.title,
    //       genre: 'genre goes here',
    //       artist: element.data.artistId,
    //       duration: Duration(milliseconds: element.data.duration),
    //       artUri: Uri.parse(element.data.coverImgUrl),
    //       // extras: {'source': m3u8FilePath});
    //       extras: {'source': source}));
    // });

    // await AudioService.addQueueItems(mediaItems);
    /// check if currently clicked media file is not downloaded and start download
    var _trackToPlay = widget.album.tracks[index];
    ParseHls parseHLS = ParseHls();
    print("mediaItems: ${mediaItems}");
    if (!(await LocalHelper.isFileDownloaded(_trackToPlay.songId))) {
      // var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';
      HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
              await parseHLS.downloadFile(
                  'https://138.68.163.236:8787/track/${_trackToPlay.songId}',
                  '$dir/${_trackToPlay.songId}',
                  "main.m3u8"))
          .readAsStringSync());
      // TODO: update this after correct m3u8 is generated
      // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(m3u8FilePath).readAsStringSync());
      List<DownloadTask> downloadTasks = [];
      // print(hlsPlayList.segments);
      hlsPlayList.segments.forEach((segment) {
        var segmentIndex = hlsPlayList.segments.indexOf(segment);
        downloadTasks.add(DownloadTask(
            track_id: _trackToPlay.songId,
            segment_number: segmentIndex,
            downloadType: DownloadType.media,
            downloaded: false,
            download_path: '$dir/${_trackToPlay.songId}/',
            url: segment.url));
      });
      print(downloadTasks);
      BlocProvider.of<MediaDownloaderBloc>(context)
          .add(AddDownload(downloadTasks: downloadTasks));
    } else {
      var m3u8FilePath = '$dir/${_trackToPlay.songId}/main.m3u8';

      /// TODO: uncomment for encryption key download
      await parseHLS.updateLocalM3u8(m3u8FilePath);
      print("mediaItems: ${mediaItems}");
      print("the file is downloaded playing from local: ${mediaItems[index]}");
      await parseHLS.writeLocalM3u8File(m3u8FilePath);
    }

    await _startPlaying(mediaItems, index);
  }

  _startPlaying(mediaItems, index) async {
    if (AudioService.running) {
      print("running");
      await AudioService.updateQueue(mediaItems);
      await AudioService.playMediaItem(mediaItems[index]);
    } else {
      if (await AudioService.start(
        backgroundTaskEntrypoint: backgroundTaskEntryPoint,
        androidNotificationChannelName: 'Playback',
        androidNotificationColor: 0xFF2196f3,
        androidStopForegroundOnPause: true,
        androidEnableQueue: true,
      )) {
        await AudioService.updateQueue(mediaItems);
        await AudioService.playMediaItem(mediaItems[index]);
      }
    }
  }
}