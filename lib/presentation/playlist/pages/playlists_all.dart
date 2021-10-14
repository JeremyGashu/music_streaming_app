import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';

import '../../../locator.dart';

class AllPlaylistsPage extends StatefulWidget {
  static const String allPlaylistsRouterName = 'all_playlists_router_name';
  @override
  _AllPlaylistsPageState createState() => _AllPlaylistsPageState();
}

class _AllPlaylistsPageState extends State<AllPlaylistsPage> {
  final List<Playlist> _playlists = [];

  final ScrollController _scrollController = ScrollController();

  PlaylistBloc playlistBloc;
  @override
  void initState() {
    playlistBloc = sl<PlaylistBloc>();
    playlistBloc.add(LoadPlaylists());
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
          BlocConsumer<PlaylistBloc, PlaylistState>(
              bloc: playlistBloc,
              listener: (context, state) {
                if (state is LoadingPlaylist) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Loading Album!')));
                } else if (state is LoadedPlaylist && state.playlists.isEmpty) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('No More Albums!')));
                } else if (state is LoadingPlaylistError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  playlistBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedPlaylist) {
                  _playlists.addAll(state.playlists);
                  playlistBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingPlaylist && _playlists.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is LoadingPlaylistError &&
                    _playlists.isEmpty) {
                  return Expanded(
                    child: CustomErrorWidget(
                        onTap: () {
                          playlistBloc.add(LoadPlaylists());
                        },
                        message: 'Error Loading Playlists!'),
                  );
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
                                !playlistBloc.isLoading) {
                              if (playlistBloc.state is LoadedPlaylist) {
                                if ((playlistBloc.state as LoadedPlaylist)
                                        .playlists
                                        .length ==
                                    0) return;
                              }
                              playlistBloc
                                ..isLoading = true
                                ..add(LoadPlaylists());
                            }
                          }),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: _playlists.map((playlist) {
                          return Center(
                            child: SinglePlaylist(
                              playlist: playlist,
                            ),
                          );
                        }).toList(),
                      )),
                      state is LoadingPlaylist
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedPlaylist
                          ? state.playlists.length == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Text('No More Playlists!'),
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
        'All Playlists',
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
