import 'package:animated_overflow/animated_overflow.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class PlayerOverlay extends StatefulWidget {
  final bool playing;
  PlayerOverlay({this.playing});

  @override
  _PlayerOverlayState createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay> {
  bool _expandList = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: AudioService.queueStream,
      builder: (context, AsyncSnapshot<List<MediaItem>> snapshot) =>
          StreamBuilder(
        stream: AudioService.currentMediaItemStream,
        builder: (context, AsyncSnapshot<MediaItem> currentMediaSnapshot) =>
        currentMediaSnapshot.hasData ?
        Wrap(
          children: [
            GestureDetector(
              onVerticalDragEnd: (details){
                setState(() {
                  _expandList = false;
                });
              },
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: _expandList ? 300 : 0,
                  width: kWidth(context),
                  color: kPlaylistBg,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${currentMediaSnapshot.data.title}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600),
                        ),
                        _expandList
                            ? GestureDetector(
                                child:
                                    Icon(Icons.keyboard_arrow_down_sharp),
                                onTap: () {
                                  setState(() {
                                    _expandList = false;
                                  });
                                })
                            : SizedBox()
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: AudioService.playbackStateStream,
                        builder: (context,
                                AsyncSnapshot<PlaybackState>
                                    playbackSnapshot) =>
                        playbackSnapshot.hasData ?
                            ListView.builder(
                              padding: EdgeInsets.zero,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return musicTile(
                                    null,
                                    () {
                                      print("play playlist");
                                      // playAudio(index, sharedPreferences);
                                      AudioService.playMediaItem(
                                          snapshot.data[index]);
                                    },
                                    snapshot.hasData &&
                                        (currentMediaSnapshot.data.id ==
                                            snapshot.data[index].id) &&
                                        playbackSnapshot.hasData &&
                                        playbackSnapshot.data.playing,
                                    snapshot.data[index],
                                  );
                                }): SizedBox(),
                      ),
                    ),
                  ])),
            ),
            Container(
                decoration: BoxDecoration(
                    color: kYellow,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0, 3))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            // StreamBuilder(
                            //   stream: AudioService.currentMediaItemStream,
                            //   builder: (context,
                            //       AsyncSnapshot<MediaItem> snapshot) =>
                            //       Padding(
                            //         padding:
                            //         const EdgeInsets.symmetric(vertical: 8.0),
                            //         child: Row(children: [
                            //           currentMediaSnapshot.hasData
                            //               ? Text(
                            //             "${currentMediaSnapshot.data.artist}:",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold),
                            //           )
                            //               : Text(
                            //             "-----",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //           currentMediaSnapshot.hasData
                            //               ? Text(
                            //             "${currentMediaSnapshot.data.title}",
                            //             overflow: TextOverflow.ellipsis,
                            //             maxLines: 1,
                            //           )
                            //               : Text(
                            //             "-----",
                            //             overflow: TextOverflow.ellipsis,
                            //             maxLines: 1,
                            //           ),
                            //           Expanded(child: Align(
                            //             alignment: Alignment.centerRight,
                            //             child: !_expandList ? GestureDetector(
                            //               child: Icon(Icons.keyboard_arrow_up),
                            //               onTap: (){
                            //                 setState(() {
                            //                   _expandList = true;
                            //                 });
                            //               },
                            //             ) : SizedBox(),
                            //           ))
                            //         ]),
                            //       ),
                            // ),
                            // Divider(
                            //   color: Colors.white54,
                            // ),
                            _controlButtonsRow(widget.playing),
                            // Divider(
                            //   color: Colors.white54,
                            // ),
                            //     () {
                            //   if (snapshot.hasData &&
                            //       currentMediaSnapshot.hasData) {
                            //     var _currentIndex = snapshot.data
                            //         .indexOf(currentMediaSnapshot.data);
                            //     print("current index: $_currentIndex");
                            //     if ((_currentIndex <
                            //         snapshot.data.length - 1) &&
                            //         _currentIndex != -1) {
                            //       MediaItem nextMediaItem =
                            //       snapshot.data[_currentIndex + 1];
                            //       return _nextUpRow(nextMediaItem);
                            //     } else {
                            //       return SizedBox();
                            //     }
                            //   } else {
                            //     return SizedBox();
                            //   }
                            // }()
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ):SizedBox(),
      ),
    );
  }

  // Widget _nextUpRow(MediaItem mediaItem) {
  //   return Row(
  //     children: [
  //       Icon(
  //         Icons.queue_music,
  //         color: kRed,
  //         size: 30.0,
  //       ),
  //       Text(
  //         "Next: ",
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       Text(
  //         "${mediaItem.artist}-${mediaItem.title}",
  //         overflow: TextOverflow.ellipsis,
  //         maxLines: 1,
  //       )
  //     ],
  //   );
  // }

  Widget _controlButtonsRow(bool playing) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleTrackPlayerPage(
                      track: Track(),
                    )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            "assets/svg/album.svg",
            height: 40,
          ),
          Expanded(
            child: StreamBuilder(
              stream: AudioService.currentMediaItemStream,
              builder: (context,
                      AsyncSnapshot<MediaItem> currentMediaSnapshot) =>
                  currentMediaSnapshot.hasData
                      ?
                      // Text(
                      //         "${currentMediaSnapshot.data.artist}:${currentMediaSnapshot.data.title}",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w600, color: Colors.white70),
                      //         overflow: TextOverflow.ellipsis, maxLines: 1,
                      //       )
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedOverflow(
                            animatedOverflowDirection:
                                AnimatedOverflowDirection.HORIZONTAL,
                            child: Text(
                              "${currentMediaSnapshot.data.artist}:${currentMediaSnapshot.data.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70),
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                            maxWidth: 200,
                            padding: 40.0,
                            speed: 50.0,
                          ),
                        )
                      : Text(
                          "-----",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await AudioService.skipToPrevious();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.skip_previous,
                    size: 25,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (playing) {
                    AudioService.pause();
                  } else {
                    // play(widget.track, preferences);
                    AudioService.play();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orange.shade300),
                    child: playing
                        ? Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 32,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await AudioService.skipToNext();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.skip_next,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _expandList = true;
              });
            },
            child: Icon(
              Icons.queue_music,
              color: Colors.white54,
              size: 25.0,
            ),
          ),
        ],
      ),
    );
  }
}
