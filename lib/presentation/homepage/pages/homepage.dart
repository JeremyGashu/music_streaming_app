import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/services/audio_player_task.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/album.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/artist.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/genre.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/playlist.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/singletrack.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/tracklistitem.dart';

/// Move this function to the parent of this widget if
/// starting audio_service fails(NotConnected error)
///
/// And also streamSubscription of [PlaybackStateStream] must be moved and
/// instantiated in initState of the parent widget.
backgroundTaskEntryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription playbackStateStream;

  bool isStopped(PlaybackState state) =>
      state != null && state.processingState == AudioProcessingState.stopped;

  void reloadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }

  @override
  void initState() {
    super.initState();
    playbackStateStream =
        AudioService.playbackStateStream.where(isStopped).listen((_) {
      reloadPrefs();
    });
  }

  final List<String> carouselImages = [
    'assets/images/carousel_image.jpg',
    'assets/images/carousel_image.jpg',
    'assets/images/carousel_image.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlaylistBloc>(context).add(LoadPlaylists());
    BlocProvider.of<TrackBloc>(context).add(LoadTracks());

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 220,
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 220,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false),
                items: carouselImages
                    .map((e) => Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: Stack(children: [
                            Image.asset(
                              e,
                              fit: BoxFit.cover,
                              width: 1000,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100.0,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                      kPurple,
                                      kViolet.withOpacity(0.0)
                                    ])),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amelkalew',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Dawit Getachew',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kYellow),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ))
                    .toList(),
              ),
            ),
            Ad(size),
            _sectionTitle(title: "New Releases", callback: () {}),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [Album(), Album()],
              ),
            ),
            _sectionTitle(title: "Popular Playlists", callback: () {}),
            Container(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlayList(),
                  PlayList(),
                  PlayList(),
                ],
              ),
            ),
            _sectionTitle(title: "Most Played Tracks", callback: () {}),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TrackListItem(),
                TrackListItem(),
                TrackListItem(),
              ],
            ),
            _sectionTitle(title: "Genres", callback: () {}),
            Container(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Genre(title: 'Country'),
                  Genre(title: 'R & B'),
                  Genre(title: 'Pop'),
                ],
              ),
            ),
            _sectionTitle(title: "Artists", callback: () {}),
            Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Artist(),
                  Artist(),
                  Artist(),
                  Artist(),
                ],
              ),
            ),
            Ad(size),
            _sectionTitle(title: "Albums", callback: () {}),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Album(),
                  Album(),
                  Album(),
                ],
              ),
            ),
            _sectionTitle(title: "Single Tracks", callback: () {}),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SingleTrack(),
                  SingleTrack(),
                  SingleTrack(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sectionTitle({title, callback}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$title',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: kBlack, fontSize: 16),
          ),
          GestureDetector(
            onTap: () => callback(),
            child: Text(
              'View All >',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: kPurple, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Ad(size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/ad_one.jpg',
            height: 140,
            width: size.width,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text('Ad'),
            ),
          )
        ],
      ),
    );
  }
}
