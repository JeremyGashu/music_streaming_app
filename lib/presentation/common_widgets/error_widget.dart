import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Function onTap;
  final String message;

  const CustomErrorWidget({@required this.onTap, @required this.message})
      : assert(onTap != null && message != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.redAccent.withOpacity(0.8),
                size: 30,
              ),
              onPressed: onTap),
        ],
      ),
    );
  }
}
