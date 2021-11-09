import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_detail_page.dart';

class ArtistTile extends StatelessWidget {
  ArtistTile({this.artist});

  final ArtistModel artist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      onTap: () {
        Navigator.pushNamed(context, ArtistDetailPage.artistDetailPageRouteName,
            arguments: artist);
      },
      leading: Card(
        elevation: 3,
        color: Colors.transparent,
        child: Container(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/artist_placeholder.png',
                  fit: BoxFit.contain,
                );
              },
              imageUrl: artist.image ?? '',
              placeholder: (context, url) => SpinKitRipple(
                color: Colors.orange,
                size: 10,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      title: Text(
        '${artist.firstName} ${artist.lastName}',
        style: TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        '${artist.firstName} ${artist.lastName}',
        style: TextStyle(fontSize: 12),
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.orange,
              size: 15,
            ),
            SizedBox(
              width: 5,
            ),
            Text('${artist.likeCount}'),
          ],
        ),
      ),
    );
  }
}
