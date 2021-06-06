import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/library/pages/album_page.dart';

class SingleAlbum extends StatefulWidget {
  final Album album;
  SingleAlbum({@required this.album});
  @override
  _SingleAlbumState createState() => _SingleAlbumState();
}

class _SingleAlbumState extends State<SingleAlbum> {
  @override
  Widget build(BuildContext context) {
    return widget.album != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlbumPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              child: SvgPicture.asset(
                                'assets/svg/album.svg',
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
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                                imageUrl: widget.album.coverImageUrl,
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/images/album_one.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                                width: 140.0,
                                height: 120,
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
                        child: SvgPicture.asset(
                          'assets/svg/album.svg',
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
