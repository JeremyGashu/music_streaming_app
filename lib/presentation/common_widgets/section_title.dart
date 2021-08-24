import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';

SectionTitle({title, callback}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 8.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$title',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: kBlack, fontSize: 16),
        ),
        InkWell(
          onTap: () => callback(),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Text(
              'View All >',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: kPurple, fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}
