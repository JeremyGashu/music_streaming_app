import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
// import 'package:streaming_mobile/presentation/playlist/pages/create_playlist_page.dart';
import 'package:streaming_mobile/presentation/playlist/pages/create_playlist_page.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlist_detail.dart';

import '../../../locator.dart';

class PrivatePlaylistsPage extends StatefulWidget {
  static const privatePlaylistRouteName = 'private_playlist_route_name';
  @override
  _PrivatePlaylistsPageState createState() => _PrivatePlaylistsPageState();
}

class _PrivatePlaylistsPageState extends State<PrivatePlaylistsPage> {
  final List<Playlist> _playlists = [];
  final ScrollController _scrollController = ScrollController();

  final PlaylistBloc playlistBloc = sl<PlaylistBloc>();

  @override
  void initState() {
    playlistBloc.add(GetPrivatePlaylists());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.orange,
          onPressed: () async {
            var value = await showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: CreatePrivatePlaylistWidget(),
                  );
                });

            if (value == true) {
              print('here is the value => $value');
              _playlists.clear();
              print('playlist length ${_playlists.length}');
              playlistBloc.add(LoadPrivatePlaylistsInit());
            }
          },
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _upperSection(context),
              Expanded(
                child: BlocConsumer<PlaylistBloc, PlaylistState>(
                  listener: (context, state) {},
                  bloc: playlistBloc,
                  builder: (context, state) {
                    if (state is LoadedPrivatePlaylist) {
                      _playlists.addAll(state.playlists);
                      playlistBloc.loadingPrivatePlaylist = false;
                    } else if (state is InitialState ||
                        state is LoadingState && _playlists.isEmpty) {
                      return Center(
                        child: SpinKitRipple(
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    } else if (state is ErrorState && _playlists.isEmpty) {
                      return Center(
                        child: CustomErrorWidget(
                            onTap: () {
                              playlistBloc.add(GetPrivatePlaylists());
                            },
                            message: 'Error Loading Playlists!'),
                      );
                    }

                    return _playlists.length == 0
                        ? Center(
                            child: Text('No Playlist Found!'),
                          )
                        : ListView.builder(
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.offset ==
                                        _scrollController.position.maxScrollExtent &&
                                    !playlistBloc.loadingPrivatePlaylist) {
                                  if (playlistBloc.state is LoadedPrivatePlaylist) {
                                    if ((playlistBloc.state as LoadedPrivatePlaylist)
                                            .playlists
                                            .length ==
                                        0) return;
                                  }
                                  playlistBloc
                                    ..loadingPrivatePlaylist = true
                                    ..add(GetPrivatePlaylists());
                                }
                              }),
                            itemCount: _playlists.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _playlists.length) {
                                if (state is LoadingState) {
                                  return SpinKitRipple(
                                    color: Colors.grey,
                                    size: 40,
                                  );
                                }
                                return SizedBox();
                              }
                              //yield listile and add sending state from here
                              return Dismissible(
                                key: Key(_playlists[index].playlistId),
                                confirmDismiss: (_) async {
                                  bool dismiss = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(
                                          'Do you want to delete ${_playlists[index].title}?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text('Yes')),
                                      ],
                                    ),
                                  );
                                  return dismiss;
                                },
                                onDismissed: (_) async {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Deleted playlist!')));
                                  print(
                                      'delete playlist ${_playlists[index].playlistId}');
                                },
                                background: Container(
                                  color: Colors.redAccent.withOpacity(0.1),
                                ),
                                direction: DismissDirection.horizontal,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        PlaylistDetail.playlistDetailRouterName,
                                        arguments: _playlists[index]);
                                  },
                                  leading: Icon(Icons.music_note),
                                  title: Text(_playlists[index].title),
                                  subtitle: Text(
                                      '${_playlists[index].songs.length} Musics'),
                                  // trailing: Icon(Icons.arrow_right),
                                  trailing: Icon(
                                    Icons.delete_forever_outlined,
                                    size: 17,
                                  ),
                                ),
                              );
                            });
                  },
                ),
              ),
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
        'My Playlists',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 20,
          ),
          onPressed: () {},
        ),
      ),
    ],
  );
}
