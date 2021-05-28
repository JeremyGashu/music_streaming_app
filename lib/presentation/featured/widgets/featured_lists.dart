import 'package:flutter/material.dart';

Widget FeaturedList({String albumArt}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Material(
      shadowColor: Colors.black,
      elevation: 8,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 150,
          width: 150,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 2,
              color: Color(0x882D2D2D),
            )
          ]),
          child: Image.asset(
            'assets/images/$albumArt',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
