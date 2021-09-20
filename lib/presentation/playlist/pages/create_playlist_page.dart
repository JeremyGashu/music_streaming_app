import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';
import 'package:http/http.dart' as http;

class CreatePrivatePlaylistWidget extends StatefulWidget {
  @override
  _CreatePrivatePlaylistWidgetState createState() =>
      _CreatePrivatePlaylistWidgetState();
}

class _CreatePrivatePlaylistWidgetState
    extends State<CreatePrivatePlaylistWidget> {
  final PlaylistBloc playlistBloc = PlaylistBloc(
      playlistRepository: PlaylistRepository(
          dataProvider: PlaylistDataProvider(client: http.Client())));
  final TextEditingController _controller = TextEditingController();
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
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading playlist Error!')));
          }
          if (state is SuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added Music Playlist!')));
                Navigator.pop(context, true);
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
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  Spacer(),
                  state is LoadingState
                      ? Center(
                          child: SpinKitRipple(
                            color: Colors.grey,
                            size: 40,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    String title = _controller.value.text;

                                    if (title != '') {
                                      playlistBloc.add(
                                          CreatePrivatePlaylist(title: title));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Playlist title cannot be empty!!')));
                                    }
                                  },
                                  child: Text('Create')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'))
                            ],
                          ),
                        )
                ],
              ),
            ),
          );
        });
  }
}
