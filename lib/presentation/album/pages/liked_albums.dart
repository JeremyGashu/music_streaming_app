import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_bloc.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_event.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_state.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/album/widgets/album_tile_new.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';

import '../../../locator.dart';

class LikedAlbumsPage extends StatefulWidget {
  static const String likedAlbumsRouteName = 'liked_albums_route_name';
  @override
  _LikedAlbumsPageState createState() => _LikedAlbumsPageState();
}

class _LikedAlbumsPageState extends State<LikedAlbumsPage> {
  final List<Album> _albums = [];

  final ScrollController _scrollController = ScrollController();

  LikedAlbumBloc likedAlbumBloc;
  @override
  void initState() {
    likedAlbumBloc = sl<LikedAlbumBloc>();
    likedAlbumBloc.add(LoadLikedAlbums());
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
          BlocConsumer<LikedAlbumBloc, LikedAlbumsState>(
              bloc: likedAlbumBloc,
              listener: (context, state) {
                if (state is ErrorState) {
                  likedAlbumBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedLikedAlbums) {
                  _albums.addAll(state.albums);
                  likedAlbumBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingState && _albums.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is ErrorState && _albums.isEmpty) {
                  return CustomErrorWidget(
                      onTap: () {
                        likedAlbumBloc.add(LoadLikedAlbums());
                      },
                      message: 'Error Loading Album!');
                }
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        primary: false,
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !likedAlbumBloc.isLoading) {
                              if (likedAlbumBloc.state is LoadedLikedAlbums) {
                                if ((likedAlbumBloc.state as LoadedLikedAlbums)
                                        .albums
                                        .length ==
                                    0) return;
                              }
                              likedAlbumBloc
                                ..isLoading = true
                                ..add(LoadLikedAlbums());
                            }
                          }),
                        shrinkWrap: true,
                        children: _albums.map((album) {
                          return AlbumTile(album: album);
                        }).toList(),
                      )),
                      state is LoadingState
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedLikedAlbums
                          ? state.albums.length == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Text('No More Albums!'),
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
        'Liked Albums',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: IconButton(
          icon: Icon(
            Icons.search,
            size: 20,
          ),
          onPressed: () {},
        ),
      ),
    ],
  );
}
