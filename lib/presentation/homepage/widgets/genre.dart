import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/data/models/genre.dart';

class GenreWidget extends StatelessWidget {
  final Genre genre;
  GenreWidget({@required this.genre}) : assert(genre != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(children: [
        Container(
          width: 140,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                'assets/images/artist_one.jpg',
                fit: BoxFit.cover,
              )),
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
    );
  }
}
