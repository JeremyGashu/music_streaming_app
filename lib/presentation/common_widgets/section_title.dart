import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';

SectionTitle({title, callback, hasMore = true}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 3.0,
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
        hasMore ? InkWell(
          onTap: () => callback(),
          child: Padding(
            padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: Text(
              'View All >',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[700], fontSize: 12),
            ),
          ),
        ) : Container(),
      ],
    ),
  );
}
