import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/presentation/player/single_track_player_page.dart';
import 'package:streaming_mobile/presentation/search/widgets/result_tile.dart';

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
    int length;
    if ((widget.result['songs'] as TracksResponse) != null &&
        (widget.result['songs'] as TracksResponse).data != null) {
      length =
          (widget.result['songs'] as TracksResponse).data.data.songs.length;
    }

    return length == null
        ? SpinKitRipple(
            color: Colors.grey,
          )
        : length != 0
            ? ListView(
                children: (widget.result['songs'] as TracksResponse)
                    .data
                    .data
                    .songs
                    .map((songElement) {
                  return ResultListTile(
                    onTap: () async {
                      var recentlySearchedBox =
                          await Hive.openBox<Track>('recently_searched');
                      recentlySearchedBox.add(songElement.song);

                      Navigator.pushNamed(context,
                          SingleTrackPlayerPage.singleTrackPlayerPageRouteName,
                          arguments: songElement.song);
                    },
                    subtitle: songElement.song.title,
                    title:
                        '${songElement.song.artist.firstName} ${songElement.song.artist.lastName}',
                    imageUrl: songElement.song.coverImageUrl,
                  );
                  // return SingleTrack(track: songElement.song);
                }).toList(),
              )
            : Center(child: Text('No song found!'));
  }
}
