import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/blocs/albums/album_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/blocs/like/like_bloc.dart';
import 'package:streaming_mobile/blocs/like/like_event.dart';
import 'package:streaming_mobile/blocs/like/like_state.dart';
import 'package:streaming_mobile/blocs/singletrack/track_bloc.dart';
import 'package:streaming_mobile/blocs/singletrack/track_event.dart';
import 'package:streaming_mobile/blocs/singletrack/track_state.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/presentation/common_widgets/error_widget.dart';
import 'package:streaming_mobile/presentation/common_widgets/rectangulat_loading_shimmer.dart';
import 'package:streaming_mobile/presentation/common_widgets/section_title.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_album.dart';
import 'package:streaming_mobile/presentation/common_widgets/single_track.dart';

import '../../../locator.dart';

class ArtistDetailPage extends StatefulWidget {
  static const String artistDetailPageRouteName =
      'artist_detail_page_route_name';
  final ArtistModel artist;
  ArtistDetailPage({this.artist});

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  final TrackBloc trackBloc = sl<TrackBloc>();
  final AlbumBloc albumBloc = sl<AlbumBloc>();
  final LikeBloc _likeBloc = sl<LikeBloc>();

  int likesCount;

  @override
  void initState() {
    likesCount = widget.artist.likeCount ?? 0;
    albumBloc.add(LoadAlbumsByArtistId(artistId: widget.artist.artistId));
    trackBloc.add(LoadSongsByArtistId(artistId: widget.artist.artistId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<LikeBloc, LikeState>(
              bloc: _likeBloc,
              listener: (context, state) {
                if (state is SuccessState) {
                  state.status
                      ? likesCount++
                      : likesCount > 0
                          ? likesCount--
                          : likesCount;
                }
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //the name and back navigator icon and vertical more option
                    _upperSection(context, widget.artist),
                    // Divider(),
                    //circular artist image
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Container(
                          width: 140,
                          height: 140,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                            imageUrl: widget.artist.image,
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/artist_placeholder.png',
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    //artist username
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.artist.firstName}${widget.artist.lastName} ',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        state is LoadingState
                            ? SpinKitRipple(
                                color: Colors.grey,
                                size: 20,
                              )
                            : FutureBuilder<bool>(
                                future: LikeBloc.checkLikedStatus(
                                    boxName: 'liked_artist',
                                    id: widget.artist.artistId),
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      _likeBloc.add(LikeArtist(
                                          id: widget.artist.artistId));
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: state is SuccessState
                                          ? state.status
                                              ? Colors.redAccent
                                              : Colors.grey
                                          : snapshot.hasData
                                              ? snapshot.data
                                                  ? Colors.redAccent
                                                  : Colors.grey
                                              : Colors.grey,
                                    ),
                                  );
                                }),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    _likeAndFollowersStat(widget.artist, likesCount),

                    // _followSection(),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    // _descriptionSection(),

                    // Container(
                    //   margin: EdgeInsets.symmetric(
                    //     horizontal: 10,
                    //   ),
                    //   width: double.infinity,
                    //   child: TextButton(
                    //     style: ButtonStyle(
                    //       alignment: AlignmentDirectional.centerEnd,
                    //     ),
                    //     onPressed: () {},
                    //     child: Text(
                    //       'More',
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    //ad container

                    // SizedBox(
                    //   height: 10,
                    // ),

                    Column(
                      children: [
                        //tab selectors
                        // _tabSelectors(),

                        SizedBox(
                          height: 10,
                        ),
                        SectionTitle(title: 'Albums', callback: () {}),
                        //album section
                        BlocBuilder<AlbumBloc, AlbumState>(
                            bloc: albumBloc,
                            builder: (context, state) {
                              if (state is LoadedAlbum) {
                                return state.albums.length == 0
                                    ? Center(
                                        child: Text(
                                            'No albums found for this artist.'),
                                      )
                                    : Container(
                                        height: 200,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state.albums.length,
                                            itemBuilder: (context, index) {
                                              return SingleAlbum(
                                                album: state.albums[index],
                                              );
                                            }),
                                      );
                              } else if (state is LoadingAlbum) {
                                return Container(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      RectangularShimmer(),
                                      RectangularShimmer(),
                                      RectangularShimmer(),
                                    ],
                                  ),
                                );
                              } else if (state is LoadingAlbumError) {
                                return CustomErrorWidget(
                                    onTap: () {
                                      albumBloc.add(LoadAlbumsByArtistId(
                                          artistId: widget.artist.artistId));
                                    },
                                    message: 'Error Loading Albums!');
                              }

                              return Container();
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SectionTitle(title: 'Songs', callback: () {}),
                        BlocBuilder<TrackBloc, TrackState>(
                            bloc: trackBloc,
                            builder: (context, state) {
                              if (state is LoadedTracks) {
                                return state.tracks.length == 0
                                    ? Center(
                                        child: Text(
                                            'No songs found for this artist.'),
                                      )
                                    : Container(
                                        height: 200,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state.tracks.length,
                                            itemBuilder: (context, index) {
                                              return SingleTrack(
                                                track: state.tracks[index],
                                              );
                                            }),
                                      );
                              } else if (state is LoadingTrack) {
                                return Container(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      RectangularShimmer(),
                                      RectangularShimmer(),
                                      RectangularShimmer(),
                                    ],
                                  ),
                                );
                              } else if (state is LoadingTrackError) {
                                return CustomErrorWidget(
                                    onTap: () {
                                      trackBloc.add(LoadSongsByArtistId(
                                          artistId: widget.artist.artistId));
                                    },
                                    message: 'Error Loading Tracks!');
                              }

                              return Container();
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

Widget _upperSection(BuildContext context, ArtistModel artist) {
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
        '${artist.firstName} ${artist.lastName}',
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
          onPressed: () {},
        ),
      ),
    ],
  );
}

Widget _likeAndFollowersStat(ArtistModel artist, int likesCount) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              '$likesCount',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Followers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.01,
                color: Colors.black.withOpacity(
                  0.5,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '$likesCount',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Likes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.01,
                color: Colors.black.withOpacity(
                  0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget _followSection() {
//   return Padding(
//     padding: EdgeInsets.symmetric(
//       vertical: 10,
//       horizontal: 15,q
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextButton(
//               onPressed: () {},
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 10,
//                 ),
//                 child: Text(
//                   'Follow',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 25,
//                   ),
//                 ),
//               )),
//         ),
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _socialMediaIcon(
//                 'facebook.png',
//               ),
//               _socialMediaIcon(
//                 'instagram.png',
//               ),
//               _socialMediaIcon(
//                 'youtube.png',
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _socialMediaIcon(String name) {
//   return Container(
//     height: 32,
//     width: 32,
//     child: Image.asset(
//       'images/$name',
//       fit: BoxFit.cover,
//     ),
//   );
// }

// Widget _descriptionSection() {
//   return Container(
//     padding: EdgeInsets.all(10),
//     child: Text(
//       '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero...''',
//       style: TextStyle(
//         letterSpacing: 1.05,
//         fontSize: 15,
//         color: Colors.black.withOpacity(0.6),
//       ),
//     ),
//   );
// }



// Widget _tabSelectors() {
//   return Padding(
//     padding: EdgeInsets.symmetric(
//       horizontal: 10,
//       vertical: 20,
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _tabItem('home.svg'),
//         _tabItem('search.svg'),
//         _tabItem('Pressed Library Icon (notification).svg'),
//         _tabItem('account.svg'),
//       ],
//     ),
//   );
// }
//
// Widget _tabItem(String svgName) {
//   return Container(
//     width: 25,
//     height: 25,
//     child: SvgPicture.asset(
//       'assets/svg/$svgName',
//       height: 22,
//       width: 22,
//     ),
//   );
// }

// Widget _trackBuilder(Track track) {
//   return Padding(
//     padding: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 220,
//           height: 180,
//           child: Card(
//             color: Colors.transparent,
//             elevation: 10,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.asset(
//                 'images/${track.imageName}',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${track.name}',
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.9),
//                     fontSize: 22,
//                     letterSpacing: 1.05,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${track.artistName}',
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.6),
//                     fontSize: 17,
//                     letterSpacing: 1.05,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 7,
//               ),
//               child: Text(
//                 '${track.duration}',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.yellow[900],
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _playlistBuilder(PlaylistModel playlist) {
//   return Padding(
//     padding: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             color: Colors.purple[900].withOpacity(0.6),
//             borderRadius: BorderRadius.circular(60),
//             image: DecorationImage(
//               colorFilter: new ColorFilter.mode(
//                   Colors.black.withOpacity(0.4), BlendMode.dstATop),
//               image: AssetImage('images/${playlist.imageName}'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             alignment: AlignmentDirectional.center,
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 child: SvgPicture.asset(
//                   'images/search.svg',
//                   color: Colors.white.withOpacity(0.8),
//                   fit: BoxFit.cover,
//                 ),
//               )
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 7,
//         ),
//         Text(
//           '${playlist.length} - New Songs',
//           style: TextStyle(
//             color: Colors.black.withOpacity(0.6),
//             fontSize: 22,
//             letterSpacing: 1.05,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(
//               Icons.favorite,
//               color: Colors.yellow[800],
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Text(
//               '${playlist.loveCount}',
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.6),
//                 fontSize: 17,
//                 letterSpacing: 1.05,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
