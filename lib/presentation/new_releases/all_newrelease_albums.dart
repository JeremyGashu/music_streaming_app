import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/data/data_provider/new_release_dataprovider.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/repository/new_release_repository.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album_small.dart';

class AllNewReleasedAlbumsPage extends StatefulWidget {
  static const String allNewReleaseAlbumsRouterName = 'all_new_release_albums_router_name';
  @override
  _AllNewReleasedAlbumsPageState createState() =>
      _AllNewReleasedAlbumsPageState();
}

class _AllNewReleasedAlbumsPageState extends State<AllNewReleasedAlbumsPage> {
  final List<Album> _albums = [];

  final ScrollController _scrollController = ScrollController();

  NewReleaseBloc newReleaseBloc;
  @override
  void initState() {
    newReleaseBloc = NewReleaseBloc(
        newReleaseRepository: NewReleaseRepository(
            dataProvider: NewReleaseDataProvider(client: http.Client())));
    newReleaseBloc.add(LoadNewReleases());
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
          BlocConsumer<NewReleaseBloc, NewReleaseState>(
              bloc: newReleaseBloc,
              listener: (context, state) {
                if (state is LoadingNewReleases) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Loading Album!')));
                } else if (state is LoadedNewReleases &&
                    state.newRelease.songs.isEmpty) {
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('No More Albums!')));
                } else if (state is LoadingNewReleasesError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  newReleaseBloc.isLoading = false;
                }
                return;
              },
              builder: (context, state) {
                if (state is LoadedNewReleases) {
                  _albums.addAll(state.newRelease.albums);
                  newReleaseBloc.isLoading = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else if (state is InitialState ||
                    state is LoadingNewReleases && _albums.isEmpty) {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                } else if (state is LoadingNewReleasesError &&
                    _albums.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error Loading New Albums!!',
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
                              newReleaseBloc.add(LoadNewReleases());
                            }),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: GridView.count(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !newReleaseBloc.isLoading) {
                              newReleaseBloc
                                ..isLoading = true
                                ..add(LoadNewReleases());
                            }
                          }),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: _albums.map((album) {
                          return Center(
                            child: SingleAlbumSmall(
                              album: album,
                            ),
                          );
                        }).toList(),
                      )),
                      state is LoadingNewReleases
                          ? SpinKitRipple(
                              color: Colors.grey,
                              size: 50,
                            )
                          : Container(),
                      // stat state.albums.length == 0 ? Text('No More Albums!') : Container();
                      state is LoadedNewReleases
                          ? state.newRelease.songs.length == 0
                              ? Text('No More New Album!')
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
        'All New Albums',
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
