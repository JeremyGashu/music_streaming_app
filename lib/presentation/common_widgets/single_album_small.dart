import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';

class SingleAlbumSmall extends StatefulWidget {
  final Album album;
  SingleAlbumSmall({@required this.album});
  @override
  _SingleAlbumSmallState createState() => _SingleAlbumSmallState();
}

class _SingleAlbumSmallState extends State<SingleAlbumSmall> {
  @override
  Widget build(BuildContext context) {
    return widget.album != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlbumDetail(
                            album: widget.album,
                            tracks: widget.album.tracks,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 100,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/images/album_disk_new.png',
                                fit: BoxFit.cover,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.zero,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                  child: SpinKitRipple(
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                                imageUrl: widget.album.coverImageUrl,
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/images/album_one.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                                width: 120.0,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '${widget.album.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${widget.album.artist.firstName} ${widget.album.artist.lastName} ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kGray,
                            fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${widget.album.title} - ${widget.album.tracks.length} Tracks',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kYellow,
                            fontSize: 12.0),
                      ),
                    )
                  ]),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 180,
                height: 120,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/album_disk_new.png',
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/album_one.jpg',
                          fit: BoxFit.cover,
                          width: 140.0,
                          height: 120,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Amelkalew',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'Dawit Getachew',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kGray,
                      fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'Album - 12 Tracks',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kYellow,
                      fontSize: 12.0),
                ),
              )
            ]),
          );
  }
}
