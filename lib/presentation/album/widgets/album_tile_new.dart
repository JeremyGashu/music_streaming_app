import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/presentation/album/pages/albums_detail.dart';

class AlbumTile extends StatelessWidget {
  final Album album;

  const AlbumTile({this.album});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AlbumDetail.albumDetailRouterName, arguments: album);
      },
      leading: Card(
        elevation: 3,
        child: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/album_one.jpg',
                  fit: BoxFit.contain,
                );
              },
              imageUrl: album.coverImageUrl ?? '',
              placeholder: (context, url) => SpinKitRipple(color: Colors.orange, size: 10,),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),

      title: Text(album.title),
      subtitle: Text('${album.artist.firstName} ${album.artist.lastName}'),
      trailing: Text('${album.tracks.length} Tracks', style: TextStyle(color: Colors.grey),),
    );
  }
}
