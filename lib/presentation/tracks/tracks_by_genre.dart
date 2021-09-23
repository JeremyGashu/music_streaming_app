import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';

import '../../locator.dart';

class TracksByGenre extends StatefulWidget {
  final String genreId;
  static const String tracksByGenreRouteName = 'tracks_by_genre_router_name';

  const TracksByGenre({this.genreId});
  @override
  _TracksByGenreState createState() => _TracksByGenreState();
}

class _TracksByGenreState extends State<TracksByGenre> {
  final List<Track> _tracks = [];

  final ScrollController _scrollController = ScrollController();

  TrackBloc trackBloc;
  @override
  void initState() {
    trackBloc = sl<TrackBloc>();
    trackBloc.add(LoadSongsByGenre(genreId: widget.genreId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          //back button and search page
          _upperSection(context),
          // Divider(),
          BlocConsumer<TrackBloc, TrackState>(
              bloc: trackBloc,
              listener: (context, state) {
                if (state is LoadingTrack) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Loading Album!')));
                } else if (state is LoadedTracks && state.tracks.isEmpty) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('No More Albums!')));
                } else if (state is LoadingTrackError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  trackBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedTracks) {
                  _tracks.addAll(state.tracks);
                  trackBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingTrack && _tracks.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is LoadingTrackError && _tracks.isEmpty) {
                  return CustomErrorWidget(
                      onTap: () {
                        trackBloc.add(LoadSongsByGenre(genreId: widget.genreId));
                      },
                      message: 'Error Loading Tracks!');
                }
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: GridView.count(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !trackBloc.isLoading) {
                              if (trackBloc.state is LoadedTracks) {
                                if ((trackBloc.state as LoadedTracks)
                                        .tracks
                                        .length ==
                                    0) return;
                              }
                              trackBloc
                                ..isLoading = true
                                ..add(LoadTracks());
                            }
                          }),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: _tracks.map((track) {
                          return Center(
                            child: SingleTrack(
                              track: track,
                            ),
                          );
                        }).toList(),
                      )),
                      state is LoadingTrack
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedTracks
                          ? state.tracks.length == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Text('No More Tracks!'),
                                )
                              : Container()
                          : Container(),
                    ],
                  ),
                );
              }),
        ],
      ),
    ));
  }
}

Widget _upperSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      Text(
        'All Songs',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.search,
            size: 20,
          ),
          onPressed: () {},
        ),
      ),
    ],
  );
}
