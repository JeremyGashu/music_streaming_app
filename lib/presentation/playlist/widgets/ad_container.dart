import 'package:flutter/material.dart';

Widget adContainer(String path) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10,
    ),
    width: double.infinity,
    height: 150,
    child: Image.asset(
      'assets/images/$path',
      fit: BoxFit.cover,
    ),
  );
}
