import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/playlist/pages/create_playlist_page.dart';

class PrivatePlaylistsPage extends StatefulWidget {
  static const privatePlaylistRouteName = 'private_playlist_route_name';
  @override
  _PrivatePlaylistsPageState createState() => _PrivatePlaylistsPageState();
}

class _PrivatePlaylistsPageState extends State<PrivatePlaylistsPage> {
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () async{
           var value = await showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: CreatePrivatePlaylistWidget(),
                  );
                });
                if(value == true) {
                  playlistBloc.add(GetPrivatePlaylists()); 
                }
          },
        ),
        body: BlocBuilder<PlaylistBloc, PlaylistState>(
          bloc: playlistBloc,
          builder: (context, state) {
            if (state is LoadingState) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: SpinKitRipple(
                  size: 40,
                  color: Colors.grey,
                )),
              );
            } else if (state is LoadedPrivatePlaylist) {
              return state.playlists.length == 0
                  ? Center(
                      child: Text('No Playlist Found!'),
                    )
                  : ListView.builder(
                      itemCount: state.playlists.length,
                      itemBuilder: (context, index) {
                        //yield listile and add sending state from here
                        return ListTile(
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
          },
        ));
  }
}
