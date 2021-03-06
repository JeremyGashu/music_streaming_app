import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_tile.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import '../../../locator.dart';

class AllArtistsPage extends StatefulWidget {
  static const String allPArtistsRouterName = 'all_artists_router_name';
  @override
  _AllArtistsPageState createState() => _AllArtistsPageState();
}

class _AllArtistsPageState extends State<AllArtistsPage> {
  final List<ArtistModel> _artists = [];

  final ScrollController _scrollController = ScrollController();

  ArtistBloc artistBloc;
  @override
  void initState() {
    artistBloc = sl<ArtistBloc>();
    artistBloc.add(LoadArtists());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              //back button and search page
              _upperSection(context),
              // Divider(),
              BlocConsumer<ArtistBloc, ArtistState>(
                  bloc: artistBloc,
                  listener: (context, state) {
                    if (state is LoadingArtistError) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                      artistBloc.isLoading = false;
                    }
                    return;
                  },
                  builder: (context, state) {
                    if (state is LoadedArtist) {
                      _artists.addAll(state.artists);
                      artistBloc.isLoading = false;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    } else if (state is InitialState ||
                        state is LoadingArtist && _artists.isEmpty) {
                      return Center(
                        child: SpinKitRipple(
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    } else if (state is LoadingArtistError && _artists.isEmpty) {
                      return CustomErrorWidget(
                          onTap: () {
                            artistBloc.add(LoadArtists());
                          },
                          message: 'Error Loading Artists!');
                    }
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ListView(
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.offset ==
                                        _scrollController
                                            .position.maxScrollExtent &&
                                    !artistBloc.isLoading) {
                                  if (artistBloc.state is LoadedArtist) {
                                    if ((artistBloc.state as LoadedArtist)
                                            .artists
                                            .length ==
                                        0) return;
                                  }
                                  artistBloc
                                    ..isLoading = true
                                    ..add(LoadArtists());
                                }
                              }),
                            shrinkWrap: true,
                            children: _artists.map((artist) {
                              return ArtistTile(artist: artist);
                            }).toList(),
                          )),
                          state is LoadingArtist
                              ? SpinKitRipple(
                                  color: Colors.grey,
                                  size: 50,
                                )
                              : Container(),
                          // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                          state is LoadedArtist
                              ? state.artists.length == 0
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 25),
                                      child: Text('No More Artists!'),
                                    )
                                  : Container()
                              : Container(),
                        ],
                      ),
                    );
                  }),
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
        'All Artists',
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
