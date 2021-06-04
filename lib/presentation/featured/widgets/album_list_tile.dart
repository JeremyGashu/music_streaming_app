import 'package:flutter/material.dart';

Widget AlbumListTile() {
  return ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            color: Color(0x882D2D2D),
          )
        ]),
        width: 50,
        height: 50,
        child: Image.asset(
          'assets/images/image3.jpg',
          fit: BoxFit.cover,
        ),
      ),
    ),
    title: Text(
      'Amelkalew',
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        letterSpacing: 1.05,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    subtitle: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Zema Songs',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          '12 Songs-1 hr 18 min',
          style: TextStyle(color: Colors.yellow[800], fontSize: 11),
        )
      ],
    ),
    trailing: IconButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      onPressed: () {},
    ),
  );
}
