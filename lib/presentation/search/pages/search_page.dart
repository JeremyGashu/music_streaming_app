import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
// import 'package:streaming_mobile/blocs/search/search_state.dart' as searchState;
import 'package:streaming_mobile/blocs/search/search_state.dart' as searchState;
import 'package:streaming_mobile/blocs/search/search_state.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_all.dart';
import 'package:streaming_mobile/presentation/common_widgets/circular_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/rectangulat_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_albums.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_tracks.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlists_all.dart';
import 'package:streaming_mobile/presentation/search/widgets/album_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/artists_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/playlist_result.dart';
import 'package:streaming_mobile/presentation/search/widgets/recently_searched.dart';
import 'package:streaming_mobile/presentation/search/widgets/search_field.dart';
import 'package:streaming_mobile/presentation/search/widgets/songs_result.dart';

import '../../../blocs/albums/album_bloc.dart';

class SearchPage extends StatefulWidget {
  static const String searchPageRouteName = 'search_page_route_name';
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
              leading: null,
              // leading: Container(),
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
              title: Container(
                height: 120,
                margin: EdgeInsets.only(
                  top: 90,
                ),
                child: SearchField(),
              ),
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
                        // SearchField(),

                        SizedBox(
                          height: 30,
                        ),
                        SectionTitle(
                            title: 'Recently Searched', callback: () {}, hasMore: false),

                        Container(
                          height: 220,
                          padding: EdgeInsets.only(right: 4, left: 4),
                          child: RecentlyeSearched(),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        SectionTitle(
                            title: "Newly Released Albums",
                            callback: () {
                              Navigator.pushNamed(
                                  context,
                                  AllNewReleasedAlbumsPage
                                      .allNewReleaseAlbumsRouterName);
                            }),
                        SizedBox(
                          height: 15,
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
                                return CustomErrorWidget(
                                    onTap: () {
                                      BlocProvider.of<NewReleaseBloc>(context)
                                          .add(LoadNewReleasesInit());
                                    },
                                    message: 'Error Loading New Albums!');
                              }

                              return Container();
                            },
                          ),
                        ),

                        SectionTitle(
                            title: "Newly Released Songs",
                            callback: () {
                              Navigator.pushNamed(
                                  context,
                                  AllNewReleaseTracks
                                      .allNewReleaseTracksRouterName);
                            }),
                        SizedBox(
                          height: 25,
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
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 2, right: 5),
                                      child: SingleTrack(
                                        track:
                                            state.newRelease.songs[index].song,
                                      ),
                                    );
                                  },
                                );
                              } else if (state is LoadingNewReleasesError) {
                                return CustomErrorWidget(
                                    onTap: () {
                                      BlocProvider.of<NewReleaseBloc>(context)
                                          .add(LoadNewReleasesInit());
                                    },
                                    message: 'Error Loading New Songs!');
                              }

                              return Container();
                            },
                          ),
                        ),

                        SectionTitle(
                            title: "Popular Playlists",
                            callback: () {
                              Navigator.pushNamed(context,
                                  AllPlaylistsPage.allPlaylistsRouterName);
                            }),
                        SizedBox(
                          height: 15,
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
                                return state.playlists.length == 0 ? Center(child: Text('No Playlist Found!'),) : ListView.builder(
                                  itemCount: state.playlists.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SinglePlaylist(
                                      playlist: state.playlists[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingPlaylistError) {
                                return CustomErrorWidget(
                                    onTap: () {
                                      BlocProvider.of<PlaylistBloc>(context)
                                          .add(LoadPlaylistsInit());
                                    },
                                    message: 'Error Loading Playlists!');
                              }

                              return Container();
                            },
                          ),
                        ),
                        SectionTitle(
                            title: "Albums",
                            callback: () {
                              Navigator.pushNamed(
                                  context, AllAlbumsPage.allAlbumsRouterName);
                            }),
                        SizedBox(
                          height: 15,
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
                                return state.albums.length == 0 ? Center(child: Text('No Albums Found!'),) : ListView.builder(
                                  itemCount: state.albums.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return SingleAlbum(
                                      album: state.albums[index],
                                    );
                                  },
                                );
                              } else if (state is LoadingAlbumError) {
                                return CustomErrorWidget(
                                    onTap: () {
                                      BlocProvider.of<AlbumBloc>(context)
                                          .add(LoadInitAlbums());
                                    },
                                    message: 'Error Loading New Albums!');
                              }

                              return Container();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
