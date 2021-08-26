import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/artist.dart';

import '../artist/pages/artist_detail_page.dart';

class Artist extends StatelessWidget {
  final ArtistModel artist;

  const Artist({this.artist});
  @override
  Widget build(BuildContext context) {
    return artist != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, ArtistDetailPage.artistDetailPageRouteName,
                    arguments: artist);
              },
              child: Container(
                width: 120,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/images/artist_one.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                              imageUrl: artist.image,
                              placeholder: (context, url) => Center(
                                child: SpinKitRipple(
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${artist.firstName} ${artist.lastName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '3 Albums, 42 Tracks',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kYellow,
                                  fontSize: 12.0),
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
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, ArtistDetailPage.artistDetailPageRouteName,
                    arguments: artist);
              },
              child: Container(
                width: 120,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              'assets/images/artist_one.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Fenan Befikadu',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '3 Albums, 42 Tracks',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kYellow,
                                  fontSize: 12.0),
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
            ),
          );
  }
}
