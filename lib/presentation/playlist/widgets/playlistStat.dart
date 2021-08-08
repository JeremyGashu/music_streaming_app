import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

Widget playListStat({Playlist playlist}) {
  int duration = 0;

  playlist.songs.forEach((song) {
    duration += song.song.duration;
  });
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          '${playlist.songs.length} songs, ${prettyDuration(Duration(seconds: duration))} length',
          style: TextStyle(
            fontSize: 17,
            color: Colors.orange[900],
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
              size: 20,
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
              size: 20,
            ),
          ],
        ),
      ),
    ],
  );
}
