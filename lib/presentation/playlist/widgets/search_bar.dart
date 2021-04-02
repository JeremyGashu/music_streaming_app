import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget searchBar() {
  return Container(
    color: Colors.purple.withOpacity(0.15),
    padding: EdgeInsets.symmetric(
      vertical: 2,
      horizontal: 20,
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          'assets/svg/search.svg',
          width: 22,
        ),
        Expanded(
            child: TextField(
          autofocus: false,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        )),
        SvgPicture.asset(
          'assets/svg/order.svg',
          width: 22,
        ),
      ],
    ),
  );
}
