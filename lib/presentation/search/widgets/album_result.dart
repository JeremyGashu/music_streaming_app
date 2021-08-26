import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';
import 'package:streaming_mobile/presentation/search/widgets/result_tile.dart';

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
    int length;
    if ((widget.result['albums'] as AlbumsResponse) != null &&
        (widget.result['albums'] as AlbumsResponse).data != null) {
      length = (widget.result['albums'] as AlbumsResponse).data.data.length;
    }

    return length == null
        ? SpinKitRipple(
            color: Colors.grey,
          )
        : length != 0
            ? ListView(
                children: (widget.result['albums'] as AlbumsResponse)
                    .data
                    .data
                    .map((album) {
                  return ResultListTile(
                    imageUrl: album.coverImageUrl,
                    title: '${album.artist.firstName} ${album.artist.lastName}',
                    subtitle: album.title,
                    onTap: () {
                      Navigator.pushNamed(context, AlbumDetail.albumDetailRouterName, arguments: album);
                    },
                  );
                }).toList(),
              )
            : Center(child: Text('No Album found!'));
  }
}
