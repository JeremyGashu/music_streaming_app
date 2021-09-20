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
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';

class SplashPage extends StatefulWidget {
  static const splashPageRuterName = 'splash_page_router_name';
  State<SplashPage> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  final _analyticsBloc = AnalyticsBloc(
      analyticsRepository: AnalyticsRepository(
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
                    // fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: -50,
                        child: Container(
                          width: kWidth(context),
                          height: kHeight(context) * 0.25,
                          margin: EdgeInsets.only(top: 40),
                          child: SvgPicture.asset('assets/svg/melody.svg'),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset('assets/svg/logo_2.svg'),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 30,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Powered By  ',
                                  style: TextStyle(color: Colors.black, fontSize: 14)),
                             TextSpan(
                                  text: ' Zema ',
                                  style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
