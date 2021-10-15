import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/presentation/playlist/pages/private_playlists_page.dart';

class PrivatePlaylistList extends StatefulWidget {
  final String songId;

  const PrivatePlaylistList({this.songId});
  @override
  _PrivatePlaylistListState createState() => _PrivatePlaylistListState();
}

class _PrivatePlaylistListState extends State<PrivatePlaylistList> {
  final List<Playlist> _playlists = [];
  final ScrollController _scrollController = ScrollController();
  final PlaylistBloc playlistBloc = PlaylistBloc(
      playlistRepository: PlaylistRepository(
          dataProvider: PlaylistDataProvider(client: http.Client())));
  @override
  void initState() {
    playlistBloc.add(GetPrivatePlaylists());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo make another bloc for this and load the items from here

    return Container(
      height: 400,
      child: BlocConsumer<PlaylistBloc, PlaylistState>(
          bloc: playlistBloc,
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              // Navigator.pop(context);
              playlistBloc.loadingPrivatePlaylist = false;
            }
            if (state is SuccessState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("added to playlist!")));
            }
          },
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
              return CustomErrorWidget(
                  onTap: () {
                    playlistBloc.add(GetPrivatePlaylists());
                  },
                  message: 'Error Loading Playlists!');
            }
            return Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: _playlists.length == 0
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No Playlist Found!'),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context,
                                              PrivatePlaylistsPage
                                                  .privatePlaylistRouteName);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.add),
                                            Text('Create Playlist'),
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.offset ==
                                        _scrollController
                                            .position.maxScrollExtent &&
                                    !playlistBloc.loadingPrivatePlaylist) {
                                  if (playlistBloc.state
                                      is LoadedPrivatePlaylist) {
                                    if ((playlistBloc.state
                                                as LoadedPrivatePlaylist)
                                            .playlists
                                            .length ==
                                        0) return;
                                  }
                                  playlistBloc
                                    ..loadingPrivatePlaylist = true
                                    ..add(GetPrivatePlaylists());
                                }
                              }),
                            itemCount: _playlists.length,
                            itemBuilder: (context, index) {
                              //yield listile and add sending state from here
                              return ListTile(
                                onTap: () async {
                                  var _currentMediaItem =
                                      await AudioService.currentMediaItem;
                                  playlistBloc.add(AddSongsToPrivatePlaylists(
                                      playlistId: _playlists[index].playlistId,
                                      songId: _currentMediaItem.id));
                                },
                                leading: Icon(Icons.music_note),
                                title: Text(_playlists[index].title),
                                subtitle: Text(
                                    '${_playlists[index].songs.length} Musics'),
                              );
                            }),
                  ),
                  // SizedBox(height: 30,),
                  Divider(),
                  Container(
                    width: double.infinity,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
