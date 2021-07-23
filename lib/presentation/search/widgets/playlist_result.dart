import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';

class PlaylistResult extends StatefulWidget {
  final Map<String, dynamic> result;

  PlaylistResult({this.result});

  @override
  _PlaylistResultState createState() => _PlaylistResultState();
}

class _PlaylistResultState extends State<PlaylistResult> {
  @override
  void initState() {
    BlocProvider.of<SearchBloc>(context)
        .add(SetCurrentPage(currentPage: SearchIn.SONGS));
    if (widget.result['playlists'] == null) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'],
          searchIn: SearchIn.PLAYLISTS));
    } else if (widget.result['currentKey'] != widget.result['playlistsParam']) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'],
          searchIn: SearchIn.PLAYLISTS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo: set the current page from here

    int length =
        (widget.result['playlists'] as PlaylistsResponse).data.data.length;

    return length != 0
        ? GridView.count(
            crossAxisCount: 2,
            children: (widget.result['plsylists'] as PlaylistsResponse)
                .data
                .data
                .map((playlist) {
              return SinglePlaylist();
            }).toList(),
          )
        : Center(child: Text('No song found!'));
  }
}
