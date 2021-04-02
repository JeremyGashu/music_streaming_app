import 'package:flutter/material.dart';

Widget playListStat() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          '38 songs, 1hr 28 min',
          style: TextStyle(
            fontSize: 19,
            color: Colors.yellow[900].withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Icon(
              Icons.favorite,
              color: Colors.purple,
              size: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '31k',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    ],
  );
}
