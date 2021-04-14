import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/playlist/pages/playlist_detail.dart';

Widget musicTile(Music music) {
  return ListTile(
    leading: Card(
      color: Colors.transparent,
      elevation: 3,
      child: Container(
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/${music.imageName}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    title: Text(
      music.name,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 18,
        letterSpacing: 1.01,
      ),
    ),
    subtitle: Text(
      music.artistName,
      style: TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontSize: 14,
        letterSpacing: 1.01,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          music.duration,
          style: TextStyle(color: Colors.grey),
        ),
        Icon(
          Icons.more_vert,
          color: Colors.grey,
          size: 25,
        )
      ],
    ),
  );
}
