import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlist_detail.dart';

class SinglePlaylist extends StatelessWidget {
  final Album album;
  SinglePlaylist({this.album});
  @override
  Widget build(BuildContext context) {
    return album != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaylistDetail(
                            tracks: album.tracks,
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
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                  imageUrl: album.coverImageUrl,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      'assets/images/singletrack_one.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  width: 140.0,
                                  height: 120,
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
                            '${album.tracks.length} new songs',
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
                                '${album.views}',
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
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlaylistDetail();
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
                            '23 new songs',
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
            ),
          );
  }
}
