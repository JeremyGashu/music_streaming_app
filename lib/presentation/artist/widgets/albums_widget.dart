import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            'Amelkalew',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            'Dawit Getachew',
            style: TextStyle(
                fontWeight: FontWeight.w400, color: kGray, fontSize: 12.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            'Album - 12 Tracks',
            style: TextStyle(
                fontWeight: FontWeight.w400, color: kYellow, fontSize: 12.0),
          ),
        )
      ]),
    );
  }
}
