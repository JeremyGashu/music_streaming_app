import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ResultListTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Function onTap;

  const ResultListTile({this.imageUrl, this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(3),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 50,
            width: 50,
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(
                strokeWidth: 1,
              ),
              imageUrl: imageUrl,
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/artist_placeholder.png',
                  fit: BoxFit.contain,
                );
              },
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.009),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
