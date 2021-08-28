import 'package:flutter/material.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/phone_input_page.dart';
import 'package:streaming_mobile/presentation/login/login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: kHeight(context),
        width: kWidth(context),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [kRed, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/playlist_top_bg.png',
                  height: 200,
                ),
                Container(
                  width: 120,
                  height: 120,
                  margin: EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Image.asset(
                    "assets/images/sewasew_logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: kWidth(context),
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.loginPageRouteName);
                    },
                    child:
                        Text('LOG IN', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kBlack),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ))),
                  ),
                ),
                Container(
                  width: kWidth(context),
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, PhoneInputPage.phoneInputStorageRouterName);
                    },
                    child: Text('SIGN UP', style: TextStyle(color: kBlack)),
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                side: BorderSide(color: kBlack, width: 2.0)))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
