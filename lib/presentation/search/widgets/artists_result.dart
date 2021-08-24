import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_detail_page.dart';
import 'package:streaming_mobile/presentation/search/widgets/result_tile.dart';

class ArtistsResult extends StatefulWidget {
  final Map<String, dynamic> result;

  ArtistsResult({this.result});

  @override
  _ArtistsResultState createState() => _ArtistsResultState();
}

class _ArtistsResultState extends State<ArtistsResult> {
  @override
  void initState() {
    BlocProvider.of<SearchBloc>(context)
        .add(SetCurrentPage(currentPage: SearchIn.ARTISTS));
    if (widget.result['artists'] == null) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.ARTISTS));
    } else if (widget.result['currentKey'] != widget.result['artistsParam']) {
      BlocProvider.of<SearchBloc>(context).add(Search(
          searchKey: widget.result['currentKey'], searchIn: SearchIn.ARTISTS));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int length;
    if ((widget.result['artists'] as ArtistsResponse) != null &&
        (widget.result['artists'] as ArtistsResponse).data != null) {
      length = (widget.result['artists'] as ArtistsResponse).data.data.length;
    }
    return length == null
        ? SpinKitRipple(
            color: Colors.grey,
          )
        : length != 0
            ? ListView(
                children: (widget.result['artists'] as ArtistsResponse)
                    .data
                    .data
                    .map((artist) {
                  return ResultListTile(
                    imageUrl: artist.image,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArtistDetailPage(
                                    artistId: artist.artistId,
                                    artist: artist,
                                  )));
                    },
                    title: '${artist.firstName} ${artist.lastName}',
                    subtitle: '${artist.firstName} ${artist.lastName}',
                  );
                  // return Artist(
                  //   artist: artist,
                  // );
                }).toList(),
              )
            : Center(child: Text('No Artist found!'));
  }
}
