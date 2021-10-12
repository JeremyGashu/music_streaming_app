import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/like/like_bloc.dart';
import 'package:streaming_mobile/blocs/like/like_event.dart';
import 'package:streaming_mobile/blocs/like/like_state.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/download_task.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';
import 'package:streaming_mobile/presentation/common_widgets/player_overlay.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

import '../../../locator.dart';

class PlaylistDetail extends StatefulWidget {
  static const String playlistDetailRouterName = 'playlist_detail_router_name';
  final Playlist playlistInfo;
  PlaylistDetail({this.playlistInfo});
  @override
  _PlaylistDetailState createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final LikeBloc _likeBloc = sl<LikeBloc>();
  int likesCount;

  @override
  initState() {
    likesCount = widget.playlistInfo.likeCount ?? 0;
    super.initState();
  }

  // bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikeBloc, LikeState>(
        bloc: _likeBloc,
        listener: (context, state) {
          if (state is SuccessState) {
            state.status
                ? likesCount++
                : likesCount > 0
                    ? likesCount--
                    : likesCount;
          }
          if (state is ErrorState) {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: CustomAlertDialog(
                      type: AlertType.ERROR,
                      message: '${state.message}',
                    ),
                  );
                });
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
            key: _scaffoldKey,
            body: Stack(children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    //upper section containing the image, svg, shuffle button and healing track
                    upperSection(context, state, playlist: widget.playlistInfo),
                    SizedBox(
                      height: 20,
                    ),
                    // playListStat(playlist: widget.playlistInfo),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    //ad section
                    // _adContainer('ad.png'),
                    SizedBox(
                      height: 15,
                    ),
                    // searchBar(),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: StreamBuilder(
                          stream: AudioService.currentMediaItemStream,
                          builder:
                              (context, AsyncSnapshot<MediaItem> snapshot) {
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
                                      itemCount:
                                          widget.playlistInfo.songs.length,
                                      itemBuilder: (context, index) {
                                        return musicTile(
                                            widget.playlistInfo.songs[index]
                                                .song, () {
                                          print("play playlist");
                                          playAudio(index, sharedPreferences);
                                        },
                                            context,
                                            snapshot.hasData &&
                                                (snapshot.data.id ==
                                                    widget.playlistInfo
                                                        .songs[index].songId) &&
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
                                AsyncSnapshot<MediaItem>
                                    currentMediaItemSnapshot) {
                              return currentMediaItemSnapshot.hasData &&
                                      currentMediaItemSnapshot.data != null
                                  ? PlayerOverlay(
                                      playing: snapshot.data.playing)
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
        });
  }

  Widget upperSection(context, LikeState state, {Playlist playlist}) {
    int duration = 0;
    playlist.songs.forEach((element) {
      duration += element.song.duration;
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
                                        imageUrl: playlist.songs.length > 1
                                            ? playlist
                                                .songs[0].song.coverImageUrl
                                            : '',
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                        playlist.title ?? 'Unknown Title',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                          playlist.songs.length != null
                              ? '${playlist.songs.length} Songs'
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
                          if (AudioService.playbackState.playing) {
                            Navigator.pushNamed(
                                context,
                                SingleTrackPlayerPage
                                    .singleTrackPlayerPageRouteName);
                            return;
                          }
                          if (playlist.songs.length == 0) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: CustomAlertDialog(
                                      type: AlertType.ERROR,
                                      message:
                                          'There are no tracks in this playlist!',
                                    ),
                                  );
                                });
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
                            playAudio(Random().nextInt(playlist.songs.length),
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
                playlist.songs != null
                    ? '${playlist.songs.length} Songs, ${prettyDuration(Duration(seconds: duration))}'
                    : '',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  state is LoadingState
                      ? SpinKitRipple(
                          color: Colors.grey,
                          size: 20,
                        )
                      : FutureBuilder<bool>(
                          future: LikeBloc.checkLikedStatus(
                              boxName: 'liked_playlists',
                              id: playlist.playlistId),
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: () {
                                _likeBloc
                                    .add(LikePlaylist(id: playlist.playlistId));
                              },
                              child: Icon(
                                Icons.favorite,
                                color: state is SuccessState
                                    ? state.status
                                        ? Colors.redAccent
                                        : Colors.grey
                                    : snapshot.hasData
                                        ? snapshot.data
                                            ? Colors.redAccent
                                            : Colors.grey
                                        : Colors.grey,
                              ),
                            );
                          }),
                  SizedBox(
                    width: 3,
                  ),
                  Text(likesCount.toString()),
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
      if (widget.playlistInfo.songs[index].songId ==
          AudioService.currentMediaItem.id) {
        print(
            "PlayListPage[playlist_detail]: already running with the same media id");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleTrackPlayerPage(
                    track: widget.playlistInfo.songs[index].song)));
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
      playPlayList(context, position, index);
    }
    // else{
    //   AudioService.play();
    //   print("here");
    // }
  }

  Future<void> playPlayList(context, Duration position, index) async {
    try {
      Navigator.pushNamed(
          context, SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
          arguments: widget.playlistInfo.songs[index].song);

      var dir = await LocalHelper.getFilePath(context);
      // create mediaItem list
      List<MediaItem> mediaItems = [];

      for (Track track in widget.playlistInfo.songs.map((e) => e.song)) {
        print("trackId: ${track.songId}");
        String source = '$M3U8_URL/${track.songId}';
        if (await LocalHelper.isFileDownloaded(track.songId) &&
            await LocalHelper.allSegmentsDownloaded(id: track.songId)) {
          print("${track.songId}: downloaded");
          source = '$dir/${track.songId}/main.m3u8';
        }

        print("Source: $source");
        mediaItems.add(MediaItem(
            id: track.songId,
            album: '',
            title: track.title,
            genre: 'genre goes here',
            artist: '${track.artist.firstName} ${track.artist.lastName}',
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
      var _trackToPlay = widget.playlistInfo.songs[index].song;
      ParseHls parseHLS = ParseHls();
      print("mediaItems: ${mediaItems}");
      if (!(await LocalHelper.isFileDownloaded(_trackToPlay.songId) ||
          !(await LocalHelper.allSegmentsDownloaded(
              id: _trackToPlay.songId)))) {
        // var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';
        HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
                await parseHLS.downloadFile('$M3U8_URL/${_trackToPlay.songId}',
                    '$dir/${_trackToPlay.songId}', "main.m3u8"))
            .readAsStringSync());
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
        File file = File(m3u8FilePath);
        if (file.existsSync()) {
          await parseHLS.updateLocalM3u8(m3u8FilePath);
          print("mediaItems: ${mediaItems}");
          print(
              "the file is downloaded playing from local: ${mediaItems[index]}");
          await parseHLS.writeLocalM3u8File(m3u8FilePath);
        } else {
          // var m3u8FilePath = '$dir/${_trackToPlay.data.id}/main.m3u8';
          HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
                  await parseHLS.downloadFile(
                      '$M3U8_URL/${_trackToPlay.songId}',
                      '$dir/${_trackToPlay.songId}',
                      "main.m3u8"))
              .readAsStringSync());
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
        }
      }

      await _startPlaying(mediaItems, index);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: CustomAlertDialog(
                type: AlertType.ERROR,
                message: 'Error playing song!',
              ),
            );
          });
      Navigator.pop(context);
    }
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
