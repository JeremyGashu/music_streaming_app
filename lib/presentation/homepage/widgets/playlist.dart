import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streaming_mobile/bloc/playlist/playlist_bloc.dart';
import 'package:streaming_mobile/bloc/playlist/playlist_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlist_detail.dart';

class PlayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (_, state) {
          if (state is LoadedPlaylist) {
            return Container(
              width: 120,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaylistDetail(
                            albumId: state.playlists.data.id,
                          );
                        }));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.asset(
                                  'assets/images/singletrack_one.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: kPurple.withOpacity(.6),
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                          Positioned(
                              top: 35,
                              left: 35,
                              child: SvgPicture.asset(
                                'assets/svg/playlist.svg',
                                height: 30,
                                width: 30,
                                fit: BoxFit.scaleDown,
                              ))
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            '${state.playlists.data.trackCount} new songs',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.favorite,
                                color: kYellow,
                                size: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                '35,926',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: kGray,
                                    fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]),
            );
          } else if (state is LoadingPlaylistError) {
            return Center(
              child: Text(
                'Failed Loading playlists!',
              ),
            );
          } else if (state is LoadingPlaylist) {
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
