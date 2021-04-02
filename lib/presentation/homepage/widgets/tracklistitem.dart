import 'package:flutter/material.dart';

class TrackListItem extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 8.0, right: 8.0),
      child: Row(
        children: [
          _imageWithDetailRow(),
          Spacer(),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  Row _imageWithDetailRow() {
    return Row(
      children: [
        _customClippedImage(),
        SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amelkalew',
              style: TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xDD2D2D2D)),
            ),
            Text(
              'Dawit Getachew',
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0x882D2D2D)),
            ),
          ],
        ),
      ],
    );
  }

  Container _customClippedImage() {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 2,
                color: Color(0x882D2D2D),
              )
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image(
            image: AssetImage('assets/images/artist_one.jpg'),
            fit: BoxFit.cover,
          ),
        ));
  }
}