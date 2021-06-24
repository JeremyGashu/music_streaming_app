import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Stack(
            children: [
              Column(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  Container(
                    width: kWidth(context),
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneInputPage()));
                      },
                      child: Text('SIGN UP', style: TextStyle(color: kBlack)),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      side: BorderSide(
                                          color: kBlack, width: 2.0)))),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50.0),
                  height: 50.0,
                  child: SignInButtonBuilder(
                    text: 'Sign up with Google',
                    image: Image.asset('assets/images/google_icon.png'),
                    onPressed: () {},
                    width: kWidth(context),
                    height: 50.0,
                    textColor: kBlack,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
