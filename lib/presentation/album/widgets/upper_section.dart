import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/data/models/album.dart';

Widget upperSection(context, {Album album}) {
  return Column(
    children: [
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 1,
                ),
                imageUrl: album.coverImageUrl,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/album_one.jpg',
                    fit: BoxFit.cover,
                  );
                },
                width: 140.0,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.grey.withOpacity(0.5),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            width: 140,
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(
                  strokeWidth: 1,
                ),
                imageUrl: album.coverImageUrl,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/album_one.jpg',
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(bottom: 40),
            child: SvgPicture.asset(
              'assets/svg/playlist.svg',
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 5,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              child: Column(
                children: [
                  Text(
                    album.title,
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.01,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${album.artist.firstName} ${album.artist.lastName}',
                    style: TextStyle(
                      letterSpacing: 1.01,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
