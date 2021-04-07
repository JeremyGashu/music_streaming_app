import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/track.dart';

class SingleTrackPlayerPage extends StatefulWidget {
  final Track track;
  const SingleTrackPlayerPage({@required this.track});

  @override
  _SingleTrackPlayerPageState createState() => _SingleTrackPlayerPageState();
}

class _SingleTrackPlayerPageState extends State<SingleTrackPlayerPage> {
  SliderThemeData _sliderThemeData;
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  StreamSubscription periodicSubscription, playbackStateSubscription;
  Future<SharedPreferences> sharedPreferences;

  @override
  void initState() {
    super.initState();

    sharedPreferences = SharedPreferences.getInstance();

    periodicSubscription = Stream.periodic(Duration(seconds: 1)).listen((_) {
      _dragPositionSubject.add(
        AudioService.playbackState.currentPosition.inMilliseconds.toDouble(),
      );
    });

    playbackStateSubscription = AudioService.playbackStateStream
        .where((state) => state != null)
        .listen((state) {
      if (state.playing) {
        periodicSubscription.resume();
      } else if (!periodicSubscription.isPaused) {
        periodicSubscription.pause();
      }
    });
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
      body: StreamBuilder<MediaItem>(
          stream: AudioService.currentMediaItemStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _nowPlayingWidget(mediaItem: snapshot.data);
            }
            return FutureBuilder<SharedPreferences>(
              future: sharedPreferences,
              builder: (context, prefSnapshot) {
                if (prefSnapshot.hasData) {
                  final prefs = prefSnapshot.data;
                  if (prefs.containsKey('id')) {
                    final mediaItem = MediaItem(
                      id: prefs.getString('id'),
                      album: prefs.getString('album'),
                      title: prefs.getString('title'),
                      artist: prefs.getString('artist'),
                      duration: Duration(seconds: prefs.getInt('duration')),
                      genre: prefs.getString('genre'),
                      artUri: Uri.parse(prefs.getString('artUri')),
                      extras: {'source': prefs.getString('source')},
                    );
                    return _nowPlayingWidget(
                        mediaItem: mediaItem, loadFromPrefs: prefs);
                  }
                }

                /// Show not playing screen here
                ///
                /// This will be replaced with another widget later
                return Center(
                  child: Text('Not Playing'),
                );
              },
            );
          }),
    );
  }

  Column _nowPlayingWidget(
      {MediaItem mediaItem, SharedPreferences loadFromPrefs}) {
    return Column(
      children: [
        _songImage(),
        Spacer(),
        _songTitleRow(),

        /// SeekBar
        Stack(
          children: [
            bufferedIndicator(mediaItem?.duration?.inMilliseconds?.toDouble()),
            positionIndicator(mediaItem, loadFromPrefs),
          ],
        ),

        _controlButtonsRow(),
      ],
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
                  activeTrackColor: Colors.red.shade300,
                  thumbColor: Colors.red.shade300,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayColor: Colors.red.withAlpha(36),
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
                    /// TODO : Check segment availability
                    /// 
                    /// Pause the player first then calculate segment position
                    /// then check if the segment exists and play. If the
                    /// segment was not downloaded, start download and wait
                    /// until download finished state yielded.
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
                    child: Text(prettyDuration(mediaItem.duration)),
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
            progressColor: Colors.orange.shade300,
            backgroundColor: Colors.orange.shade200,
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

  Padding _controlButtonsRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.shuffle, color: Colors.orange.shade300),
          Icon(
            Icons.skip_previous,
            size: 34,
          ),
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.orange.shade300),
              child: Icon(
                Icons.pause,
                color: Colors.white,
                size: 38,
              )),
          Icon(
            Icons.skip_next,
            size: 34,
          ),
          Icon(
            Icons.repeat,
            color: Colors.orange.shade300,
          )
        ],
      ),
    );
  }

  Padding _songTitleRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.add,
            size: 36,
            color: Color(0xFF2D2D2D),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Amelkalew',
                style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D2D2D)),
              ),
              Text(
                'Dawit Getachew',
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0x882D2D2D)),
              ),
            ],
          ),
          Icon(
            Icons.more_vert_outlined,
            size: 36,
            color: Color(0xFF2D2D2D),
          ),
        ],
      ),
    );
  }

  Container _songImage() {
    return Container(
      width: double.infinity,
      height: 380,
      child: Image(
        image: AssetImage(
          'assets/images/photo_4.jpg',
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
