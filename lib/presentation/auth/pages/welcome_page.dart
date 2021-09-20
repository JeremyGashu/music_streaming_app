import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/phone_input_page.dart';
import 'package:streaming_mobile/presentation/login/login_page.dart';

class WelcomePage extends StatelessWidget {
  static const String welcomePageRouteName = 'welcome_page_router_name';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            child: Container(
              width: kWidth(context),
              height: kHeight(context) * 0.25,
              margin: EdgeInsets.only(top: 40),
              child: SvgPicture.asset('assets/svg/melody.svg'),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(bottom: 75),
                    child: SvgPicture.asset('assets/svg/Logo.svg'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  Container(
                    width: kWidth(context),
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, LoginPage.loginPageRouteName);
                      },
                      child: Text('LOG IN',
                          style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kBlack),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                          ))),
                    ),
                  ),
                  Container(
                    width: kWidth(context),
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            PhoneInputPage.phoneInputStorageRouterName);
                      },
                      child: Text('SIGN UP', style: TextStyle(color: kBlack)),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  side: BorderSide(
                                      color: kBlack, width: 2.0)))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
