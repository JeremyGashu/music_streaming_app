import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/utils/pretty_duration.dart';
import 'package:streaming_mobile/data/models/track.dart';

Widget musicTile(Track music, Function onPressed, [isPlaying = false]) {
  return GestureDetector(
    onTap: () {
      onPressed();
    },
    child: ListTile(
      leading: Card(
        elevation: 3,
        child: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: music.song.coverImageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        music.song.title,
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontSize: 18,
          letterSpacing: 1.01,
        ),
      ),
      subtitle: Text(
        music.songId,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 14,
          letterSpacing: 1.01,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isPlaying
              ? Row(
                  children: [
                    Image.asset(
                      "assets/images/playing_wave.gif",
                      height: 20,
                      color: kRed,
                    ),
                    SizedBox(width: 10),
                  ],
                )
              : SizedBox(),
          Text(
            prettyDuration(Duration(milliseconds: music.song.duration)),
            style: TextStyle(color: Colors.grey),
          ),
          Icon(
            Icons.more_vert,
            color: Colors.grey,
            size: 25,
          )
        ],
      ),
    ),
  );
}
