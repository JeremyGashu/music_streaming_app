import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:http/http.dart' as http;

class AddPlaylistPage extends StatefulWidget {
  @override
  _AddPlaylistPageState createState() => _AddPlaylistPageState();
}

class _AddPlaylistPageState extends State<AddPlaylistPage> {
  final PlaylistBloc playlistBloc = PlaylistBloc(
      playlistRepository: PlaylistRepository(
          dataProvider: PlaylistDataProvider(client: http.Client())));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo make another bloc for this and load the items from here

    return BlocConsumer<PlaylistBloc, PlaylistState>(
        bloc: playlistBloc,
        listener: (context, state) {
          if (state is LoadingPlaylistError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading Private playlist Error!')));
          }
        },
        builder: (context, state) {
          return Container(
            height: kHeight(context) * 0.6,
            width: kWidth(context) * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 10),
            ),
          );
        });
  }
}
