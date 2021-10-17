import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/data/data_provider/new_release_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/data/repository/new_release_repository.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/playlist/widgets/music_tile.dart';

class AllNewReleaseTracks extends StatefulWidget {
  static const String allNewReleaseTracksRouterName =
      'all_new_release_tracks_router_name';
  @override
  _AllNewReleaseTracksState createState() => _AllNewReleaseTracksState();
}

class _AllNewReleaseTracksState extends State<AllNewReleaseTracks> {
  final List<Track> _tracks = [];

  final ScrollController _scrollController = ScrollController();

  NewReleaseBloc newReleaseBloc;
  @override
  void initState() {
    newReleaseBloc = NewReleaseBloc(
        newReleaseRepository: NewReleaseRepository(
            dataProvider: NewReleaseDataProvider(client: http.Client())));
    newReleaseBloc.add(LoadNewReleases());
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
          BlocConsumer<NewReleaseBloc, NewReleaseState>(
              bloc: newReleaseBloc,
              listener: (context, state) {
                if (state is LoadingNewReleasesError) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  newReleaseBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedNewReleases) {
                  List<Track> m =
                      state.newRelease.songs.map((newR) => newR.song).toList();
                  _tracks.addAll(m);
                  newReleaseBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingNewReleases && _tracks.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is LoadingNewReleasesError &&
                    _tracks.isEmpty) {
                  return CustomErrorWidget(
                      onTap: () {
                        newReleaseBloc.add(LoadNewReleases());
                      },
                      message: 'Error Loading New Songs!');
                }
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !newReleaseBloc.isLoading) {
                              if (newReleaseBloc.state is LoadedNewReleases) {
                                if ((newReleaseBloc.state as LoadedNewReleases)
                                        .newRelease
                                        .songs
                                        .length ==
                                    0) return;
                              }
                              newReleaseBloc
                                ..isLoading = true
                                ..add(LoadNewReleases());
                            }
                          }),
                        shrinkWrap: true,
                        children: _tracks.map((track) {
                          return musicTile(track, context);
                        }).toList(),
                      )),
                      state is LoadingNewReleases
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedNewReleases
                          ? state.newRelease.songs.length == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Text('No More Songs!'),
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
        'All New Songs',
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
