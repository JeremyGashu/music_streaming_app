import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/albums/album_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/featured/featured_bloc.dart';
import 'package:streaming_mobile/blocs/featured/featured_event.dart';
import 'package:streaming_mobile/blocs/featured/featured_state.dart';
import 'package:streaming_mobile/blocs/genres/genres_bloc.dart';
import 'package:streaming_mobile/blocs/genres/genres_event.dart';
import 'package:streaming_mobile/blocs/genres/genres_state.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_bloc.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_event.dart';
import 'package:streaming_mobile/blocs/new_release/new_release_state.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
import 'package:streaming_mobile/core/services/audio_player_task.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_all.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_all.dart';
import 'package:streaming_mobile/presentation/common_widgets/artist.dart';
import 'package:streaming_mobile/presentation/common_widgets/circular_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/genre.dart';
import 'package:streaming_mobile/presentation/common_widgets/player_overlay.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/rectangulat_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';
import 'package:streaming_mobile/presentation/common_widgets/tracklistitem.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/featured_album.dart';
import 'package:streaming_mobile/presentation/homepage/widgets/loading_genre_shimmer.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_albums.dart';
import 'package:streaming_mobile/presentation/new_releases/all_newrelease_tracks.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlists_all.dart';
import 'package:streaming_mobile/presentation/tracks/tracks_all.dart';

backgroundTaskEntryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription playbackStateStream;

  bool isStopped(PlaybackState state) =>
      state != null && state.processingState == AudioProcessingState.stopped;

  void reloadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }

  @override
  void initState() {
    super.initState();
    playbackStateStream =
        AudioService.playbackStateStream.where(isStopped).listen((_) {
      reloadPrefs();
    });
  }

  final List<String> carouselImages = [
    'assets/images/carousel_image.jpg',
    'assets/images/carousel_image.jpg',
    'assets/images/carousel_image.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrackBloc, TrackState>(
          listener: (ctx, state) {
            if (state is LoadingTrackError) {
              BlocProvider.of<AuthBloc>(context).add(RefreshToken());
            }
            //todo in case one of the endpoints fail for some reason, add refresh tokens for album,playlists and artist
            //todo for later use if the status code is 401 use the refresh token
          },
        ),
      ],
      // listeners: [
      //   BlocListener<TrackBloc, TrackState>(
      //     listener: (ctx, state) {
      //       if (state is LoadingTrackError) {
      //         BlocProvider.of<AuthBloc>(context).add(RefreshToken());
      //     },
      //   ),
      //   BlocListener<AlbumBloc, AlbumState>(
      //     listener: (ctx, state) {
      //       if (state is LoadingAlbumError) {
      //         BlocProvider.of<AuthBloc>(context).add(RefreshToken());
      //       }
      //     },
      //   ),
      //   BlocListener<PlaylistBloc, PlaylistState>(
      //     listener: (ctx, state) {
      //       if (state is LoadingPlaylistError) {
      //         BlocProvider.of<AuthBloc>(context).add(RefreshToken());
      //       }
      //     },
      //   ),
      //   BlocListener<ArtistBloc, ArtistState>(
      //     listener: (ctx, state) {
      //       if (state is LoadingArtistError) {
      //         BlocProvider.of<AuthBloc>(context).add(RefreshToken());
      //       }
      //     },
      //   ),
      //   BlocListener<AuthBloc, AuthState>(
      //     listener: (ctx, state) {
      //       if (state is TokenRefreshSuccessful) {
      //         BlocProvider.of<TrackBloc>(context).add(LoadTracks());
      //         BlocProvider.of<AlbumBloc>(context).add(LoadAlbums());
      //         BlocProvider.of<PlaylistBloc>(context).add(LoadPlaylists());
      //         BlocProvider.of<ArtistBloc>(context).add(LoadArtists());
      //       }
      //     },
      //   ),
      // ],
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<TrackBloc>(context).add(LoadTracksInit());
          BlocProvider.of<AlbumBloc>(context).add(LoadInitAlbums());
          BlocProvider.of<PlaylistBloc>(context).add(LoadPlaylistsInit());
          BlocProvider.of<ArtistBloc>(context).add(LoadInitArtists());
          BlocProvider.of<NewReleaseBloc>(context).add(LoadNewReleasesInit());
          BlocProvider.of<GenresBloc>(context).add(FetchGenres());
          BlocProvider.of<FeaturedAlbumBloc>(context)
              .add(LoadFeaturedAlbumsInit());
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      height: 300,
                      child: BlocBuilder<FeaturedAlbumBloc, FeaturedAlbumState>(
                          builder: (context, state) {
                        if (state is LoadedFeaturedAlbum) {
                          return state.albums.length == 0
                              ? Center(
                                  child: Text(
                                    'No Featured Album!',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                )
                              : CarouselSlider(
                                  options: CarouselOptions(
                                      height: 310,
                                      viewportFraction: 1.05,
                                      initialPage: 0,
                                      enableInfiniteScroll: false),
                                  items: state.albums
                                      .map((e) => GestureDetector(
                                          onTap: () {
                                            if (e == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Incomplete album info!')));
                                              return;
                                            }
                                            Navigator.pushNamed(
                                                context,
                                                AlbumDetail
                                                    .albumDetailRouterName,
                                                arguments: e);
                                          },
                                          child: FeaturedAlbum(e)))
                                      .toList(),
                                );
                        } else if (state is LoadingFeaturedAlbum) {
                          return Center(
                            child: SpinKitRipple(
                              color: Colors.grey,
                              size: 60,
                            ),
                          );
                        } else if (state is LoadingFeaturedAlbumError) {
                          return CustomErrorWidget(
                              onTap: () {
                                BlocProvider.of<FeaturedAlbumBloc>(context)
                                    .add(LoadFeaturedAlbumsInit());
                              },
                              message: 'Error Loading Featured Albums!');
                        }
                        return Container();
                      }),
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    // adContainer('ad.png'),
                    SectionTitle(
                        title: "Newly Released Songs",
                        callback: () {
                          Navigator.pushNamed(
                              context,
                              AllNewReleaseTracks
                                  .allNewReleaseTracksRouterName);
                        }),
                    SizedBox(
                      height: 5,
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
                                return index ==
                                        state.newRelease.songs.length - 1
                                    ? Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: SingleTrack(
                                          track: state
                                              .newRelease.songs[index].song,
                                        ),
                                      )
                                    : SingleTrack(
                                        track:
                                            state.newRelease.songs[index].song,
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
                        title: "Newly Released Albums",
                        callback: () {
                          Navigator.pushNamed(
                              context,
                              AllNewReleasedAlbumsPage
                                  .allNewReleaseAlbumsRouterName);
                        }),
                    SizedBox(
                      height: 10,
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
                        title: "Popular Playlists",
                        callback: () {
                          Navigator.pushNamed(
                              context, AllPlaylistsPage.allPlaylistsRouterName);
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircularShimmer(),
                                CircularShimmer(),
                                CircularShimmer(),
                              ],
                            );
                          } else if (state is LoadedPlaylist) {
                            return state.playlists.length == 0
                                ? Center(child: Text('No Playlist Found!'))
                                : ListView.builder(
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
                    SectionTitle(title: "Most Played Tracks", callback: () {}),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          TrackListItem(),
                          TrackListItem(),
                          TrackListItem(),
                        ],
                      ),
                    ),
                    SectionTitle(title: "Genres", callback: () {}, hasMore: false),
                    Container(
                        height: 130,
                        child: BlocBuilder<GenresBloc, GenresState>(
                          builder: (ctx, state) {
                            if (state is GenresLoadInProgress) {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  LoadingGenreShimmer(),
                                  LoadingGenreShimmer(),
                                  LoadingGenreShimmer(),
                                ],
                              );
                            } else if (state is GenresLoadSuccess) {
                              return ListView.builder(
                                itemCount: state.genres.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  return GenreWidget(
                                      genre: state.genres[index]);
                                },
                              );
                            } else if (state is GenresLoadFailed) {
                              return CustomErrorWidget(
                                  onTap: () {
                                    BlocProvider.of<GenresBloc>(context)
                                        .add(FetchGenres());
                                  },
                                  message: 'Error Loading Genres!');
                            }
                            return Container();
                          },
                        )),

                    SectionTitle(
                        title: "Artists",
                        callback: () {
                          Navigator.pushNamed(
                              context, AllArtistsPage.allPArtistsRouterName);
                        }),
                    Container(
                      height: 180,
                      child: BlocBuilder<ArtistBloc, ArtistState>(
                        builder: (ctx, state) {
                          if (state is LoadingArtist) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircularShimmer(),
                                CircularShimmer(),
                                CircularShimmer(),
                              ],
                            );
                          } else if (state is LoadedArtist) {
                            return ListView.builder(
                              itemCount: state.artists.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return Artist(
                                  artist: state.artists[index],
                                );
                              },
                            );
                          } else if (state is LoadingArtistError) {
                            return CustomErrorWidget(
                                onTap: () {
                                  BlocProvider.of<ArtistBloc>(context)
                                      .add(LoadInitArtists());
                                },
                                message: 'Error Loading Artist!');
                          }

                          return Container();
                        },
                      ),
                    ),
                    // adContainer('ad.png'),
                    SectionTitle(
                        title: "Albums",
                        callback: () {
                          Navigator.pushNamed(
                              context, AllAlbumsPage.allAlbumsRouterName);
                        }),
                    SizedBox(
                      height: 10,
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
                            return state.albums.length == 0
                                ? Center(
                                    child: Text('No Album Found!'),
                                  )
                                : ListView.builder(
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
                                message: 'Error Loading Album!');
                          }

                          return Container();
                        },
                      ),
                    ),
                    SectionTitle(
                        title: "Single Tracks",
                        callback: () {
                          Navigator.pushNamed(
                              context, AllTracks.allTracksRouterName);
                        }),
                    Container(
                      height: 200,
                      child: BlocBuilder<TrackBloc, TrackState>(
                        builder: (ctx, state) {
                          if (state is LoadingTrack) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                RectangularShimmer(),
                                RectangularShimmer(),
                                RectangularShimmer(),
                              ],
                            );
                          } else if (state is LoadedTracks) {
                            return state.tracks.length > 0
                                ? ListView.builder(
                                    itemCount: state.tracks.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      return state.tracks.length - 1 == index
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: SingleTrack(
                                                  track: state.tracks[index]),
                                            )
                                          : SingleTrack(
                                              track: state.tracks[index]);
                                    },
                                  )
                                : Center(
                                    child: Text('No Songs are Available!'),
                                  );
                          } else if (state is LoadingTrackError) {
                            return CustomErrorWidget(
                                onTap: () {
                                  BlocProvider.of<TrackBloc>(context)
                                      .add(LoadTracksInit());
                                },
                                message: 'Error Loading Songs!');
                          }

                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                  stream: AudioService.playbackStateStream,
                  builder: (context, AsyncSnapshot<PlaybackState> snapshot) {
                    if (snapshot.hasData) {
                      print("SnapshotData: ${snapshot.data.processingState}");
                    }
                    if (snapshot.hasData) {
                      var snapShotData = snapshot.data.processingState;
                      if (snapShotData != AudioProcessingState.stopped) {
                        return StreamBuilder(
                            stream: AudioService.currentMediaItemStream,
                            builder: (context,
                                AsyncSnapshot<MediaItem>
                                    currentMediaItemSnapshot) {
                              return currentMediaItemSnapshot.hasData &&
                                      currentMediaItemSnapshot.data != null
                                  ? PlayerOverlay(
                                      playing: snapshot.data.playing)
                                  : SizedBox();
                            });
                      }
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
