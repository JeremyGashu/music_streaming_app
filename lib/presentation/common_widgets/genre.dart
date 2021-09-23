import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/genre.dart';
import 'package:streaming_mobile/presentation/tracks/tracks_by_genre.dart';

class GenreWidget extends StatelessWidget {
  final Genre genre;
  GenreWidget({@required this.genre}) : assert(genre != null);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TracksByGenre.tracksByGenreRouteName, arguments: genre.id);
      },
      child: Container(
        width: 140,
        padding: EdgeInsets.all(8.0).copyWith(left: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(children: [
          Container(
            width: 140,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/artist_one.jpg',
                    fit: BoxFit.cover,
                  );
                },
                imageUrl: genre.name,
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
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kYellow.withOpacity(.6)),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${genre.name}',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ]),
      ),
    );
  }
}
