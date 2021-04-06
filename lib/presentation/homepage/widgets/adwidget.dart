import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ad extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/ad_one.jpg',
              height: 140,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 2.0),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text('Ad'),
              ),
            )
          ],
        ),
      );
  }
}