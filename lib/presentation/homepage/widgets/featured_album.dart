import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/album.dart';

Widget FeaturedAlbum(Album album) {
  return Container(
    margin: EdgeInsets.only(right: 8.0),
    child: Stack(children: [
      CachedNetworkImage(
        placeholder: (context, url) => Center(
          child: SpinKitRipple(
            size: 50,
            color: Colors.grey,
          ),
        ),
        imageUrl: album != null ? album.artist.image : '',
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/images/artist_image.jpg',
            fit: BoxFit.cover,
          );
        },
        width: 1000.0,
        fit: BoxFit.cover,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [kPurple, kViolet.withOpacity(0.0)])),
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album != null ? album.title : 'Unknown Album',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                album != null
                    ? '${album.artist.firstName} ${album.artist.firstName}'
                    : 'Unknown Artist',
                style: TextStyle(fontWeight: FontWeight.bold, color: kYellow),
              ),
            ],
          ),
        ),
      )
    ]),
  );
}
