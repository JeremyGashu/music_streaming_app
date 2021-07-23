import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';

class SongsResult extends StatefulWidget {
  final Map<String, dynamic> result;

  SongsResult({this.result});

  @override
  _SongsResultState createState() => _SongsResultState();
}

class _SongsResultState extends State<SongsResult> {
  @override
  void initState() {
    BlocProvider.of<SearchBloc>(context)
        .add(SetCurrentPage(currentPage: SearchIn.SONGS));
    if (widget.result['songs'] == null) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.SONGS));
    } else if (widget.result['currentKey'] != widget.result['songsParam']) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.SONGS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo: set the current page from here

    int length = (widget.result['songs'] as TracksResponse).data.data.length;

    return length != 0
        ? GridView.count(
            crossAxisCount: 2,
            children: (widget.result['songs'] as TracksResponse)
                .data
                .data
                .map((songs) {
              return SingleTrack(track: songs);
            }).toList(),
          )
        : Center(child: Text('No song found!'));
  }
}
