import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  final String text;
  final Function onTapHandler;
  const CustomTitleText({
    Key key,
    @required this.text,
    @required this.onTapHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xCC2D2D2D)),
          ),
          GestureDetector(
            onTap: onTapHandler,
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(fontSize: 14, color: Color(0xCC7521D5)),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(Icons.arrow_forward_ios_outlined,
                    size: 14, color: Color(0xCC7521D5))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
