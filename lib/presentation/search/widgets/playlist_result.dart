import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        .add(SetCurrentPage(currentPage: SearchIn.PLAYLISTS));
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
    int length;
    if ((widget.result['playlists'] as PlaylistsResponse) != null &&
        (widget.result['playlists'] as PlaylistsResponse).data != null) {
      length =
          (widget.result['playlists'] as PlaylistsResponse).data.data.length;
    }

    return length == null
        ? SpinKitRipple(
            color: Colors.grey,
          )
        : length != 0
            ? GridView.count(
                crossAxisCount: 2,
                children: (widget.result['playlists'] as PlaylistsResponse)
                    .data
                    .data
                    .map((plist) {
                  return SinglePlaylist(
                    playlist: plist,
                  );
                }).toList(),
              )
            : Center(child: Text('No playlist found!'));
  }
}
