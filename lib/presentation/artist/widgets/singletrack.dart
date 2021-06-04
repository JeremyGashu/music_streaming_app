import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';

class SingleTrack extends StatefulWidget {
  @override
  _SingleTrackState createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TrackBloc, TrackState>(
        builder: (ctx, state) {
          if (state is LoadedTrack) {
            return GestureDetector(
              onTap: () {
                /// Start playing the audio
                playSingleTrack(context, state.track);

                /// Pass the track data to [SingletrackPlayer] page
                /// using state.track
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SingleTrackPlayerPage()));
              },
              child: Container(
                width: 140,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            child: Image.asset(
                              'assets/images/singletrack_one.jpg',
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
                                  'Amelkalew',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'Dawit Getachew',
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
                              '04:13',
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
            );
          } else if (state is LoadingTrackError) {
            return Center(
              child: Text(
                'Failed Loading playlists!',
              ),
            );
          } else if (state is LoadingTrack) {
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

void playSingleTrack(BuildContext context, Track track,
    [Duration position]) async {
  // String dir = (Theme.of(context).platform == TargetPlatform.android
  //         ? await getExternalStorageDirectory()
  //         : await getApplicationDocumentsDirectory())
  //     .path;
  // String m3u8FilePath = '$dir/${track.data.id}/main.m3u8';

  final id = track.data.id;

  MediaItem _mediaItem = MediaItem(
      id: track.data.id,
      album: track.data.albumId,
      title: track.data.title,
      genre: 'genre goes here',
      artist: track.data.artistId,
      duration: Duration(milliseconds: track.data.duration),
      artUri: Uri.parse(track.data.coverImgUrl),
      // extras: {'source': m3u8FilePath});
      extras: {'source': track.data.trackUrl});

  if (AudioService.running) {
    AudioService.playFromMediaId(id);
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

      await AudioService.updateMediaItem(queue[0]);
      await AudioService.updateQueue(queue);

      AudioService.playFromMediaId(id);

      if (position != null) AudioService.seekTo(position);
    }
  }
}
