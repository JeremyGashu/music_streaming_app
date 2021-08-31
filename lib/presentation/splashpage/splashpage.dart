import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/analytics/analytics_bloc.dart';
import 'package:streaming_mobile/blocs/analytics/analytics_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/data_provider/analytics_dataprovider.dart';
import 'package:streaming_mobile/data/repository/analytics_repository.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  static const splashPageRuterName = 'splash_page_router_name';
  State<SplashPage> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

    final _analyticsBloc = AnalyticsBloc(analyticsRepository: AnalyticsRepository(
    dataProvider: AnalyticsDataProvider(client: http.Client())));
  @override
  initState() {
    _analyticsBloc.add(SendAnalyticsDataOnAppInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) => MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    print("splash page state: [$state]");
                    if (state is Authenticated) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false);
                    } else if (state is Unauthenticated ||
                        state is InitialState) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                          (route) => false);
                    }
                  },
                ),
              ],
              child: Scaffold(
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
                      Center(
                        child: Image.asset(
                          "assets/images/sewasew_logo.png",
                          width: 100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
