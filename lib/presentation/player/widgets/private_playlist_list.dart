import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
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

    return BlocConsumer<PlaylistBloc, PlaylistState>(
        bloc: playlistBloc,
        listener: (context, state) {
          if (state is ErrorState || state is LoadingPlaylistError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading Private playlist Error!')));
          }
          if (state is SuccessState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Added To Playlist!')));
          }
        },
        builder: (context, state) {
          return Container(
            height: kHeight(context) * 0.6,
            width: kWidth(context) * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: _buildOnState(context, state),
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
            ),
          );
        });
  }

  Widget _buildOnState(BuildContext context, PlaylistState state) {
    if (state is LoadingState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: SpinKitRipple(
          size: 40,
          color: Colors.grey,
        )),
      );
    } else if (state is LoadedPrivatePlaylist) {
      return state.playlists.length == 0
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No Playlist Found!'),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            PrivatePlaylistsPage.privatePlaylistRouteName);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text('Create Playlist'),
                        ],
                      ))
                ],
              ),
            )
          : ListView.builder(
              itemCount: state.playlists.length,
              itemBuilder: (context, index) {
                //yield listile and add sending state from here
                return ListTile(
                  onTap: () {
                    playlistBloc.add(AddSongsToPrivatePlaylists(
                        playlistId: state.playlists[index].playlistId,
                        songId: widget.songId));
                  },
                  leading: Icon(Icons.music_note),
                  title: Text(state.playlists[index].title),
                  subtitle: Text('${state.playlists.length} Musics'),
                );
              });
    } else if (state is ErrorState) {
      return CustomErrorWidget(
          onTap: () {
            playlistBloc.add(GetPrivatePlaylists());
          },
          message: 'Error Loading Playlists!');
    }
    return Container();
  }
}
