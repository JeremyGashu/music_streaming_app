import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget upperSection(context) {
  return Column(
    children: [
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/images/artist_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.grey.withOpacity(0.85),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            width: 140,
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/images/artist_image.jpg',
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
                size: 27,
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
                    'Healing',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.01,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Zema Songs',
                    style: TextStyle(
                      letterSpacing: 1.01,
                      color: Colors.black,
                      fontSize: 23,
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
