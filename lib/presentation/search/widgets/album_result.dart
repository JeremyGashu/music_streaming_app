import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/common_widgets/album.dart';

class AlbumResult extends StatefulWidget {
  final Map<String, dynamic> result;

  AlbumResult({this.result});

  @override
  _AlbumResultState createState() => _AlbumResultState();
}

class _AlbumResultState extends State<AlbumResult> {
  @override
  void initState() {
    BlocProvider.of<SearchBloc>(context)
        .add(SetCurrentPage(currentPage: SearchIn.ALBUMS));
    if (widget.result['albums'] == null) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.ALBUMS));
    } else if (widget.result['currentKey'] != widget.result['albumsParam']) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.ALBUMS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo: set the current page from here

    int length = (widget.result['albums'] as AlbumsResponse).data.data.length;

    return length != 0
        ? GridView.count(
            crossAxisCount: 2,
            children: (widget.result['albums'] as AlbumsResponse)
                .data
                .data
                .map((album) {
              return SingleAlbum(
                album: album,
              );
            }).toList(),
          )
        : Center(child: Text('No song found!'));
  }
}
