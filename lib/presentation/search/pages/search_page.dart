import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
// import 'package:streaming_mobile/blocs/search/search_state.dart' as searchState;
import 'package:streaming_mobile/blocs/search/search_state.dart' as searchState;
import 'package:streaming_mobile/blocs/search/search_state.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';
import 'package:streaming_mobile/presentation/common_widgets/album.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/loading_playlist_shimmer.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/loadint_track_shimmer.dart';
import 'package:streaming_mobile/presentation/search/widgets/album_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/artists_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/custom_list_tile.dart';
import 'package:streaming_mobile/presentation/search/widgets/custom_title_text.dart';
import 'package:streaming_mobile/presentation/search/widgets/playlist_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/search_field.dart';
import 'package:streaming_mobile/presentation/search/widgets/songs_result.dart';

import '../../../blocs/albums/album_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<SearchBloc>(context).add(ExitSearch());
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              bottom: !(state is searchState.InitialState)
                  ? TabBar(
                      unselectedLabelColor: Colors.black54,
                      labelColor: Colors.black87,
                      indicatorColor: Colors.grey,
                      onTap: (index) {
                        print(index);
                      },
                      tabs: [
                          Tab(
                            text: 'Songs',
                          ),
                          Tab(
                            text: 'Artists',
                          ),
                          Tab(
                            text: 'Playlists',
                          ),
                          Tab(
                            text: 'Albums',
                          ),
                        ])
                  : PreferredSize(child: SizedBox(), preferredSize: Size.zero),
              backgroundColor: Colors.white,
              elevation: 0,
              title: SearchField(),
            ),
            body: !(state is searchState.InitialState)
                ? TabBarView(children: [
                    state is searchState.SearchingState
                        ? SpinKitRipple(
                            color: Colors.grey,
                          )
                        : state is searchState.SearchFinished
                            ? SongsResult(
                                result: state.result,
                              )
                            : Container(),
                    state is searchState.SearchingState
                        ? SpinKitRipple(
                            color: Colors.grey,
                          )
                        : state is searchState.SearchFinished
                            ? ArtistsResult(
                                result: state.result,
                              )
                            : Container(),
                    state is searchState.SearchingState
                        ? SpinKitRipple(
                            color: Colors.grey,
                          )
                        : state is searchState.SearchFinished
                            ? PlaylistResult(
                                result: state.result,
                              )
                            : Container(),
                    // state is searchState.SearchingState
                    //     ? SpinKitRipple(
                    //         color: Colors.grey,
                    //       )
                    //     : Center(child: Text('Playlists')),
                    state is searchState.SearchingState
                        ? SpinKitRipple(
                            color: Colors.grey,
                          )
                        : state is searchState.SearchFinished
                            ? AlbumResult(
                                result: state.result,
                              )
                            : Container(),
                  ])
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTitleText(
                          text: 'Recently Searched',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 220,
                          padding: EdgeInsets.only(right: 4, left: 4),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: getHeight(6)),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return MusicListTile();
                              }),
                        ),
                        CustomTitleText(
                          text: 'Popular Playlist',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 170,
                          child: BlocBuilder<PlaylistBloc, PlaylistState>(
                            builder: (ctx, state) {
                              if (state is LoadingAlbum) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircularShimmer(),
                                    CircularShimmer(),
                                    CircularShimmer(),
                                  ],
                                );
                              } else if (state is LoadedPlaylist) {
                                return ListView.builder(
                                  itemCount: state.playlists.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SinglePlaylist(
                                      playlist: state.playlists[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingAlbumError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Error Loading Playlist!',
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
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 45,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<AlbumBloc>(context)
                                                .add(LoadAlbums());
                                          }),
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),
                        CustomTitleText(
                          text: 'Newly Released Albums',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 200,
                          child: BlocBuilder<NewReleaseBloc, NewReleaseState>(
                            builder: (ctx, state) {
                              if (state is LoadingNewReleases) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                  ],
                                );
                              } else if (state is LoadedNewReleases) {
                                return ListView.builder(
                                  itemCount: state.newRelease.albums.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SingleAlbum(
                                      album: state.newRelease.albums[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingNewReleasesError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Error on loading new Albums!!',
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
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 45,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<NewReleaseBloc>(
                                                    context)
                                                .add(LoadNewReleases());
                                          }),
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),

                        CustomTitleText(
                          text: 'Newly Released Songs',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 200,
                          child: BlocBuilder<NewReleaseBloc, NewReleaseState>(
                            builder: (ctx, state) {
                              if (state is LoadingNewReleases) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                  ],
                                );
                              } else if (state is LoadedNewReleases) {
                                return ListView.builder(
                                  itemCount: state.newRelease.songs.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SingleTrack(
                                      track: state.newRelease.songs[index].song,
                                    );
                                  },
                                );
                              } else if (state is LoadingNewReleasesError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Error on loading new Songs!!',
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
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 45,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<NewReleaseBloc>(
                                                    context)
                                                .add(LoadNewReleases());
                                          }),
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),

                        CustomTitleText(
                          text: 'Recently Searched',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 170,
                          child: BlocBuilder<PlaylistBloc, PlaylistState>(
                            builder: (ctx, state) {
                              if (state is LoadingPlaylist) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircularShimmer(),
                                    CircularShimmer(),
                                    CircularShimmer(),
                                  ],
                                );
                              } else if (state is LoadedPlaylist) {
                                return ListView.builder(
                                  itemCount: state.playlists.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SinglePlaylist(
                                      playlist: state.playlists[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingAlbumError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Error Loading Playlist!',
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
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 45,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<AlbumBloc>(context)
                                                .add(LoadAlbums());
                                          }),
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),
                        CustomTitleText(
                          text: 'Albums',
                          onTapHandler: () {},
                        ),
                        Container(
                          height: 200,
                          child: BlocBuilder<AlbumBloc, AlbumState>(
                            builder: (ctx, state) {
                              if (state is LoadingAlbum) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                    RectangularShimmer(),
                                  ],
                                );
                              } else if (state is LoadedAlbum) {
                                return ListView.builder(
                                  itemCount: state.albums.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SingleAlbum(
                                      album: state.albums[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingAlbumError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Error Loading Albums!!',
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
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 45,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<AlbumBloc>(context)
                                                .add(LoadAlbums());
                                          }),
                                    ],
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        )
                        // state is searchState.InitialState
                        //     ?
                        //     : Padding(
                        //         padding: EdgeInsets.only(top: 50),
                        //         child: Column(
                        //           children: [
                        //             TabBar(
                        //               controller: _tabController,
                        //               // give the indicator a decoration (color and border radius)
                        //
                        //               labelColor: Colors.black,
                        //               unselectedLabelColor: Colors.black45,
                        //               tabs: [
                        //                 // first tab [you can add an icon using the icon property]
                        //                 Tab(
                        //                   text: 'Songs',
                        //                 ),
                        //
                        //                 // second tab [you can add an icon using the icon property]
                        //                 Tab(
                        //                   text: 'Albums',
                        //                 ),
                        //                 Tab(
                        //                   text: 'Artists',
                        //                 ),
                        //                 Tab(
                        //                   text: 'Albums',
                        //                 ),
                        //               ],
                        //             ),
                        //             TabBarView(
                        //               controller: _tabController,
                        //               children: [
                        //                 // first tab bar view widget
                        //                 Expanded(
                        //                   child: Center(
                        //                     child: Text(
                        //                       'Place Bid',
                        //                       style: TextStyle(
                        //                         fontSize: 25,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //
                        //                 // second tab bar view widget
                        //                 Expanded(
                        //                   child: Center(
                        //                     child: Text(
                        //                       'Buy Now',
                        //                       style: TextStyle(
                        //                         fontSize: 25,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Expanded(
                        //                   child: Center(
                        //                     child: Text(
                        //                       'Buy Now',
                        //                       style: TextStyle(
                        //                         fontSize: 25,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Expanded(
                        //                   child: Center(
                        //                     child: Text(
                        //                       'Buy Now',
                        //                       style: TextStyle(
                        //                         fontSize: 25,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
