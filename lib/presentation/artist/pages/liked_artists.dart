import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:streaming_mobile/blocs/liked_artists/liked_artists_bloc.dart';
import 'package:streaming_mobile/blocs/liked_artists/liked_artists_event.dart';
import 'package:streaming_mobile/blocs/liked_artists/liked_artists_state.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_tile.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';

import '../../../locator.dart';

class LikedArtistsPage extends StatefulWidget {
  static const String likedArtistsRouteName = 'liked_artists_route_name';
  @override
  _LikedArtistsPageState createState() => _LikedArtistsPageState();
}

class _LikedArtistsPageState extends State<LikedArtistsPage> {
  final List<ArtistModel> _artists = [];

  final ScrollController _scrollController = ScrollController();

  LikedArtistsBloc _likedArtistsBloc;
  @override
  void initState() {
    _likedArtistsBloc = sl<LikedArtistsBloc>();
    _likedArtistsBloc.add(LoadLikedArtists());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //back button and search page
              _upperSection(context),
              // Divider(),
              Expanded(
                child: BlocConsumer<LikedArtistsBloc, LikedArtistsState>(
                    bloc: _likedArtistsBloc,
                    listener: (context, state) {
                      if (state is ErrorState) {
                        _likedArtistsBloc.isLoading = false;
                      }
                      return;
                    },
                    builder: (context, state) {
                      if (state is LoadedLikedArtists) {
                        _artists.addAll(state.artists);
                        _likedArtistsBloc.isLoading = false;
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      } else if (state is InitialState ||
                          state is LoadingState && _artists.isEmpty) {
                        return Center(
                          child: SpinKitRipple(
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      } else if (state is ErrorState && _artists.isEmpty) {
                        return Center(
                          child: CustomErrorWidget(
                              onTap: () {
                                _likedArtistsBloc.add(LoadLikedArtists());
                              },
                              message: 'Error Loading Artists!'),
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ListView(
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.offset ==
                                        _scrollController
                                            .position.maxScrollExtent &&
                                    !_likedArtistsBloc.isLoading) {
                                  if (_likedArtistsBloc.state
                                      is LoadedLikedArtists) {
                                    if ((_likedArtistsBloc.state
                                                as LoadedLikedArtists)
                                            .artists
                                            .length ==
                                        0) return;
                                  }
                                  _likedArtistsBloc
                                    ..isLoading = true
                                    ..add(LoadLikedArtists());
                                }
                              }),
                            shrinkWrap: true,
                            children: _artists.map((artist) {
                              return ArtistTile(artist: artist);
                            }).toList(),
                          )),
                          state is LoadingState
                              ? SpinKitRipple(
                                  color: Colors.grey,
                                  size: 50,
                                )
                              : Container(),
                          // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                          state is LoadedLikedArtists
                              ? state.artists.length == 0
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 25),
                                      child: Text('No More Artists!'),
                                    )
                                  : Container()
                              : Container(),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

Widget _upperSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      Text(
        'My Artists',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.more_vert,
            size: 20,
          ),
          onPressed: () {
            // Navigator.pushNamed(context, SearchPage.searchPageRouteName);
          },
        ),
      ),
    ],
  );
}
