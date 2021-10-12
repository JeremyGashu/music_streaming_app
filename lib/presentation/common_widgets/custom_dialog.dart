import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/size_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;
  final String message;

  const CustomAlertDialog({@required this.type,@required this.message});

  @override
  Widget build(BuildContext context) {
    Color color = type == AlertType.ERROR ? Colors.red : type == AlertType.SUCCESS ? Colors.green : Colors.yellow;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 320,
        width: kWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color:color,
              ),
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      // color: type == AlertType.SUCCESS ?  Colors.green[900] : Colors.red[900],
                      // borderRadius: BorderRadius.circular(25),
                    ),
                    // width: 50,
                    // height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type == AlertType.SUCCESS ? Icons.check : Icons.error,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5,),
                        type == AlertType.SUCCESS ? Text('Success', style: TextStyle(color: Colors.white, fontSize: 18),) : Text('Error', style: TextStyle(color: Colors.white, fontSize: 18),),
                      ],
                    )),
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(message, style: TextStyle(fontSize: 20),),
                  )),
            ),
            Container(
              height: 45,
              width: double.infinity,
              
              decoration: BoxDecoration(

                color: color,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK', style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

enum AlertType { WARNING, ERROR, SUCCESS }
