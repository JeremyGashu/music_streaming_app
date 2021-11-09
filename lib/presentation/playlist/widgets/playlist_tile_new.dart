import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;

  const PlaylistTile({this.playlist});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AlbumDetail.albumDetailRouterName,
            arguments: playlist);
      },
      leading: Card(
        elevation: 5,
        child: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/artist_placeholder.png',
                  fit: BoxFit.contain,
                );
              },
              imageUrl: playlist.image ?? '',
              placeholder: (context, url) => SpinKitRipple(
                color: Colors.orange,
                size: 10,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(playlist.title),
      trailing: Text(
        '${playlist.songs.length} Tracks',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
