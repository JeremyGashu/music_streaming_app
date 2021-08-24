import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/albums/album_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/data/data_provider/album_dataprovider.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/repository/album_repository.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album_small.dart';

class AllAlbumsPage extends StatefulWidget {
  static const String allAlbumsRouterName = 'all_albums_router_name';
  @override
  _AllAlbumsPageState createState() => _AllAlbumsPageState();
}

class _AllAlbumsPageState extends State<AllAlbumsPage> {
  final List<Album> _albums = [];

  final ScrollController _scrollController = ScrollController();

  AlbumBloc albumBloc;
  @override
  void initState() {
    albumBloc = AlbumBloc(
        albumRepository: AlbumRepository(
            dataProvider: AlbumDataProvider(client: http.Client())));
    albumBloc.add(LoadAlbums());
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
          BlocConsumer<AlbumBloc, AlbumState>(
              bloc: albumBloc,
              listener: (context, state) {
                if (state is LoadingAlbum) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Loading Album!')));
                } else if (state is LoadedAlbum && state.albums.isEmpty) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('No More Albums!')));
                } else if (state is LoadingAlbumError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  albumBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedAlbum) {
                  _albums.addAll(state.albums);
                  albumBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingAlbum && _albums.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is LoadingAlbumError && _albums.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error Loading Album!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.update,
                              color: Colors.redAccent.withOpacity(0.8),
                              size: 45,
                            ),
                            onPressed: () {
                              albumBloc.add(LoadAlbums());
                            }),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: GridView.count(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !albumBloc.isLoading) {
                              albumBloc
                                ..isLoading = true
                                ..add(LoadAlbums());
                            }
                          }),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: _albums.map((album) {
                          return Center(child: SingleAlbumSmall(album: album));
                        }).toList(),
                      )),
                      state is LoadingAlbum
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedAlbum
                          ? state.albums.length == 0
                              ? Text('No More Albums!')
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
        'All Albums',
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
