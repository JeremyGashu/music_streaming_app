import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/albums/album_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/blocs/artist/artist_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
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
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/services/audio_player_task.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_all.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_all.dart';
import 'package:streaming_mobile/presentation/common_widgets/ad_container.dart';
import 'package:streaming_mobile/presentation/common_widgets/artist.dart';
import 'package:streaming_mobile/presentation/common_widgets/circular_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/genre.dart';
import 'package:streaming_mobile/presentation/common_widgets/player_overlay.dart';
import 'package:streaming_mobile/presentation/common_widgets/playlist.dart';
import 'package:streaming_mobile/presentation/common_widgets/rectangulat_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';
import 'package:streaming_mobile/presentation/common_widgets/tracklistitem.dart';
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
                      height: 220,
                      child: CarouselSlider(
                        options: CarouselOptions(
                            height: 220,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false),
                        items: carouselImages
                            .map((e) => Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  child: Stack(children: [
                                    Image.asset(
                                      e,
                                      fit: BoxFit.cover,
                                      width: 1000,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                              kPurple,
                                              kViolet.withOpacity(0.0)
                                            ])),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Amelkalew',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Dawit Getachew',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kYellow),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ))
                            .toList(),
                      ),
                    ),
                    adContainer('ad.png'),
                    //TODO: do the featured lists
                    SectionTitle(
                        title: "Newly Released Songs",
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AllNewReleaseTracks()));
                        }),
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
                                    'Error Loading New Songs!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<NewReleaseBloc>(context)
                                            .add(LoadNewReleasesInit());
                                      }),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),

                    SectionTitle(
                        title: "Newly Released Albums",
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      AllNewReleasedAlbumsPage()));
                        }),
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
                                    'Error Loading New Albums!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<NewReleaseBloc>(context)
                                            .add(LoadNewReleasesInit());
                                      }),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),

                    SectionTitle(
                        title: "Popular Playlists",
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AllPlaylistsPage()));
                        }),
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
                            return ListView.builder(
                              itemCount: state.playlists.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return SinglePlaylist(
                                  playlist: state.playlists[index],
                                );
                              },
                            );
                          } else if (state is LoadingPlaylistError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Error Loading Playlists!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<PlaylistBloc>(context)
                                            .add(LoadPlaylistsInit());
                                      }),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    SectionTitle(title: "Most Played Tracks", callback: () {}),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TrackListItem(),
                        TrackListItem(),
                        TrackListItem(),
                      ],
                    ),
                    SectionTitle(title: "Genres", callback: () {}),
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
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Error Loading Genres!',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.update,
                                          color:
                                              Colors.redAccent.withOpacity(0.8),
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<GenresBloc>(context)
                                              .add(FetchGenres());
                                        }),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        )),

                    SectionTitle(
                        title: "Artists",
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AllArtistsPage()));
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
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Error Loading Artist!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<ArtistBloc>(context)
                                            .add(LoadInitArtists());
                                      }),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    adContainer('ad.png'),
                    SectionTitle(
                        title: "Albums",
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AllAlbumsPage()));
                        }),
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
                                    'Error Loading Album!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<AlbumBloc>(context)
                                            .add(LoadInitAlbums());
                                      }),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    SectionTitle(
                        title: "Single Tracks",
                        callback: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => AllTracks()));
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
                                      return SingleTrack(
                                          track: state.tracks[index]);
                                    },
                                  )
                                : Center(
                                    child: Text('No Songs are Available!'),
                                  );
                          } else if (state is LoadingTrackError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Error Loading Songs!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.update,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<TrackBloc>(context)
                                            .add(LoadTracksInit());
                                      }),
                                ],
                              ),
                            );
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
