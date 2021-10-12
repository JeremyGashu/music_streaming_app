import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/like/like_bloc.dart';
import 'package:streaming_mobile/blocs/like/like_event.dart';
import 'package:streaming_mobile/blocs/like/like_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';
import 'package:streaming_mobile/presentation/player/widgets/private_playlist_list.dart';

import '../../locator.dart';

class SingleTrackPlayerPage extends StatefulWidget {
  static const String singleTrackPlayerPageRouteName =
      'single_track_player_page_router_name';
  final Track track;
  const SingleTrackPlayerPage({@required this.track});

  @override
  _SingleTrackPlayerPageState createState() => _SingleTrackPlayerPageState();
}

class _SingleTrackPlayerPageState extends State<SingleTrackPlayerPage> {
  bool _isCollapsed = true;
  SliderThemeData _sliderThemeData;
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  StreamSubscription periodicSubscription, playbackStateSubscription;
  Future<SharedPreferences> sharedPreferences;
  final LikeBloc _likeBloc = sl<LikeBloc>();

  @override
  void initState() {
    sharedPreferences = SharedPreferences.getInstance();

    periodicSubscription = Stream.periodic(Duration(seconds: 1)).listen((_) {
      _dragPositionSubject.add(
        AudioService.playbackState.currentPosition.inMilliseconds.toDouble(),
      );
    });

    playbackStateSubscription = AudioService.playbackStateStream
        .where((state) => state != null)
        .listen((state) async {
      if (state.playing) {
        periodicSubscription.resume();
        // await LocalHelper.getFilePath(context);
      } else if (!periodicSubscription.isPaused) {
        periodicSubscription.pause();
      }
    });
    AudioService.playbackStateStream.listen((PlaybackState event) {
      if (event.processingState == AudioProcessingState.stopped) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  void dispose() {
    periodicSubscription?.cancel();
    playbackStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: StreamBuilder(
          stream: AudioService.playbackStateStream,
          builder: (context, AsyncSnapshot<PlaybackState> playBackSnapshot) {
            return SafeArea(
              child: StreamBuilder<MediaItem>(
                  stream: AudioService.currentMediaItemStream,
                  builder: (ctx, snapshot) {
                    if (playBackSnapshot.hasData &&
                        (playBackSnapshot.data.playing ||
                            (playBackSnapshot.data.processingState ==
                                AudioProcessingState.ready))) {
                      if (snapshot.hasData) {
                        return BlocConsumer<LikeBloc, LikeState>(
                            listener: (context, state) {
                              if (state is ErrorState) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: CustomAlertDialog(
                                          type: AlertType.ERROR,
                                          message: 'Failed to add to favorites',
                                        ),
                                      );
                                    });
                              }
                            },
                            bloc: _likeBloc,
                            builder: (context, state) {
                              return Stack(
                                children: [
                                  _nowPlayingWidget(playBackSnapshot.data,
                                      mediaItem: snapshot.data),
                                  _menuSelector(context, state,
                                      songId: snapshot.data.id),
                                ],
                              );
                            });
                      }
                    }
                    return Container(
                      color: Colors.white,
                      width: kWidth(context),
                      height: kHeight(context),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text('Preparing The Player'),
                            SizedBox(
                              height: 45,
                            ),
                            SpinKitRipple(
                              color: Colors.grey,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Column _nowPlayingWidget(playbackState,
      {MediaItem mediaItem, SharedPreferences loadFromPrefs}) {
    return Column(
      children: [
        Expanded(child: _songImage(context, mediaItem)),
        // Spacer(),
        /// SeekBar
        Container(
          padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Column(
            children: [
              Stack(
                children: [
                  bufferedIndicator(
                      mediaItem?.duration?.inMilliseconds?.toDouble()),
                  positionIndicator(mediaItem, loadFromPrefs),
                ],
              ),
              _controlButtonsRow(loadFromPrefs, playbackState),
            ],
          ),
        )
      ],
    );
  }

  Widget _menuSelector(BuildContext context, LikeState state, {String songId}) {
    //todo get the song id from here
    // BlocProvider.of<PlaylistBloc>(context).add(GetPrivatePlaylists());
    return AnimatedPositioned(
      duration: Duration(milliseconds: 240),
      top: !_isCollapsed ? kHeight(context) - 240 : kHeight(context),
      left: 0,
      right: 0,
      child: Container(
        width: kWidth(context),
        height: 240,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: kWidth(context),
                child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    )),
              ),
            ),
            Divider(),

            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: PrivatePlaylistList(
                          songId: widget.track.songId,
                        ),
                        // child: Text('Private Playlists'),
                      );
                    });

                // BlocProvider.of<PlaylistBloc>(context).add(AddSongsToPrivatePlaylists(songId: widget.track.songId,));
              },
              leading: Icon(
                Icons.playlist_add,
              ),
              title: Text('Add to playlist'),
            ),

            // ListTile(
            //   onTap: () async {
            //       BlocProvider.of<UserDownloadBloc>(context)
            //           .add(StartDownload(track: widget.track));
            //           // print('current track => ${widget.track.son}');

            //   },
            //   leading: Icon(
            //           Icons.file_download,
            //           color: Colors.grey,
            //           size: 20,
            //         ),
            //   title: Text('Download'),
            // ),

            FutureBuilder<bool>(
                future: LikeBloc.checkLikedStatus(
                    boxName: 'liked_songs', id: songId),
                builder: (context, snapshot) {
                  return ListTile(
                    onTap: () {
                      _likeBloc.add(LikeSong(id: songId));
                    },
                    leading: state is LoadingState
                        ? SpinKitRipple(
                            color: Colors.redAccent,
                            size: 20,
                          )
                        : Icon(
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
                    title: state is SuccessState
                        ? state.status
                            ? Text('Remove from Favourite')
                            : Text('Add to Favorites')
                        : snapshot.hasData
                            ? snapshot.data
                                ? Text('Remove From Favorites')
                                : Text('Add to Favorites')
                            : Text('Add to Favorites'),
                  );
                }),
            Divider(),

            // ListTile(
            //   onTap: () {},
            //   leading: Icon(
            //     Icons.queue_play_next_rounded,
            //   ),
            //   title: Text('Play Next'),
            // ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
      ),
    );
  }

  Widget positionIndicator(MediaItem mediaItem, SharedPreferences prefs) {
    return StreamBuilder<double>(
      stream: _dragPositionSubject.stream,
      builder: (context, snapshot) {
        double position = AudioService.running
            ? snapshot.data ?? 0.0
            : (prefs != null && prefs.containsKey('position'))
                ? Duration(seconds: prefs.getInt('position'))
                    .inMilliseconds
                    .toDouble()
                : 0.0;
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Column(
          children: [
            if (duration != null)
              SliderTheme(
                data: _sliderThemeData.copyWith(
                  trackHeight: 2.0,
                  activeTrackColor: Colors.orange,
                  thumbColor: Colors.orange,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayColor: Colors.orange,
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                  inactiveTrackColor: Colors.transparent,
                ),
                child: Slider(
                  min: 0.0,
                  max: duration,
                  value: max(0.0, min(position, duration)),
                  onChangeStart: (_) {
                    if (!periodicSubscription.isPaused)
                      periodicSubscription.pause();
                  },
                  onChanged: (value) => _dragPositionSubject.add(value),
                  onChangeEnd: (value) {
                    AudioService.seekTo(Duration(milliseconds: value.toInt()));
                    periodicSubscription.resume();
                  },
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    prettyDuration(Duration(milliseconds: position.toInt())),
                  ),
                ),
                if (duration != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      prettyDuration(widget.track != null
                          ? (widget.track.duration != null
                              ? Duration(seconds: widget.track.duration)
                              : mediaItem.duration)
                          : Duration(seconds: 0)),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget bufferedIndicator(double duration) {
    return StreamBuilder<PlaybackState>(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bufferedPosition =
              snapshot.data.bufferedPosition.inMilliseconds.toDouble();
          return LinearPercentIndicator(
            percent: max(0.0, min(bufferedPosition / duration, 1.0)),
            linearStrokeCap: LinearStrokeCap.butt,
            lineHeight: 2.0,
            progressColor: Colors.orangeAccent.withOpacity(0.5),
            backgroundColor: Colors.black12,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
          );
        }
        return Container();
      },
    );
  }

  Padding _controlButtonsRow(
      SharedPreferences preferences, PlaybackState playbackState) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () async {
                print("SHUFFLE MODE ${playbackState.shuffleMode}");
                if (playbackState.shuffleMode == AudioServiceShuffleMode.none) {
                  await AudioService.setShuffleMode(
                      AudioServiceShuffleMode.all);
                } else {
                  await AudioService.setShuffleMode(
                      AudioServiceShuffleMode.none);
                }
              },
              icon: Icon(
                playbackState.shuffleMode == AudioServiceShuffleMode.all
                    ? Icons.playlist_play
                    : Icons.shuffle,
                color: Colors.orange,
                size: 30,
              )),
          IconButton(
            onPressed: () async {
              await AudioService.skipToPrevious();
            },
            icon: Icon(
              Icons.skip_previous,
              size: 34,
            ),
          ),
          StreamBuilder<PlaybackState>(
              stream: AudioService.playbackStateStream,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () async {
                    if (snapshot.hasData && snapshot.data.playing) {
                      await AudioService.pause();
                    } else {
                      play(preferences);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange),
                    child: snapshot.hasData && snapshot.data.playing
                        ? Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 38,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 38,
                          ),
                  ),
                );
              }),
          IconButton(
            onPressed: () async {
              await AudioService.skipToNext();
            },
            icon: Icon(
              Icons.skip_next,
              size: 34,
            ),
          ),
          IconButton(
            onPressed: () {
              playbackState.repeatMode == AudioServiceRepeatMode.one
                  ? AudioService.setRepeatMode(AudioServiceRepeatMode.none)
                  : AudioService.setRepeatMode(AudioServiceRepeatMode.one);
            },
            icon: Icon(
              playbackState.repeatMode == AudioServiceRepeatMode.one
                  ? Icons.repeat_one_outlined
                  : Icons.repeat,
              color: Colors.orange,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  Widget _songTitleRow(MediaItem mediaItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${mediaItem.title}',
              style: TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              '${mediaItem.artist}',
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isCollapsed = !_isCollapsed;
            });
            // BlocProvider.of<PlaylistBloc>(context).add(GetPrivatePlaylists());
          },
          child: Icon(
            Icons.more_vert_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Container _songImage(BuildContext context, MediaItem mediaItem) {
    return Container(
        color: Colors.black87,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 50, left: 30, right: 30, top: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: mediaItem.artUri.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _songTitleRow(mediaItem),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  play(SharedPreferences prefs) async {
    if (!AudioService.running && prefs != null) {
      // final position = Duration(seconds: prefs.getInt('position'));
      // playSingleTrack(context, track, position);
    } else
      await AudioService.play();
  }
}
