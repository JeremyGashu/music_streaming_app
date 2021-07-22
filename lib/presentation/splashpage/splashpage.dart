import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';

class SplashPage extends StatefulWidget {
  State<SplashPage> createState(){
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (context, snapshot) => BlocListener<AuthBloc, AuthState>(
          listener:  (context, state) {
            print("splash page state: [$state]");
            if (state is Authenticated) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                  // return Container();
                  // return AudioServiceWidget(child: HomePage());
            } else if(state is Unauthenticated) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
              // return MaterialApp(
              //   debugShowCheckedModeBanner: false,
              //   title: 'Streaming App',
              //   home: WelcomePage(),
              // );
            }
          },
          child:Scaffold(
            body: Container(
              height: kHeight(context),
              width: kWidth(context),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: SvgPicture.asset(assetName)
              //   )
              // ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset(
                    "assets/svg/splash_bg.svg",
                    fit: BoxFit.cover,
                    width: kWidth(context),
                    height: kHeight(context),
                  ),
                  Center(child: Image.asset("assets/images/app_logo_white.png", width: 100,))
                ],
              ),
            ),
          ),
        ),
    );
  }
}