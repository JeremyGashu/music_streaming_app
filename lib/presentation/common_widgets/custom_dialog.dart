import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/size_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;
  final String message;

  const CustomAlertDialog({@required this.type, @required this.message});

  @override
  Widget build(BuildContext context) {
    Color color = type == AlertType.ERROR
        ? Colors.red
        : type == AlertType.SUCCESS
            ? Colors.green
            : Colors.yellow;
    return Container(
      // height: 100,

      // height: 320,
      height: 65,
      width: kWidth(context),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            width: 60,
            child: Center(
              child: Icon(
                type == AlertType.SUCCESS ? Icons.check : Icons.error,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: color,
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ),
              SizedBox(width: 10,),
        ],
      ),
    );
  }
}

enum AlertType { WARNING, ERROR, SUCCESS }
