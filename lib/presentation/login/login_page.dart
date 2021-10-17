import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';

class LoginPage extends StatefulWidget {
  static const String loginPageRouteName = 'login_page_route_name';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              child: Hero(
                tag: 'melody_image',
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
            ),
            Center(
              child: Container(
                height: kHeight(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo_image',
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 40),
                        child: SvgPicture.asset('assets/svg/Logo.svg'),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    BlocConsumer<AuthBloc, AuthState>(listener: (ctx, state) {
                      if (state is AuthenticationError) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      } else if (state is Authenticated) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            MainPage.mainPageRouterName, (route) => false);
                      }
                    }, builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 48,
                                          child: Center(
                                              child: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          )),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(30)),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _phoneNumberController,
                                            // validator: (value) {
                                            //   if (value == null || value.isEmpty) {
                                            //     return 'Please enter phone!';
                                            //   }
                                            //   return null;
                                            // },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                              hintText: 'Phone number',
                                              enabledBorder:
                                                  _inputBorderStyle(),
                                              border: _inputBorderStyle(),
                                              focusedBorder:
                                                  _inputBorderStyle(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintStyle:
                                                  TextStyle(fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 48,
                                          child: Center(
                                              child: Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                          )),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(30)),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _passwordTextController,
                                            // validator: (value) {
                                            //   if (value == null || value.isEmpty) {
                                            //     return 'Please enter password!';
                                            //   }
                                            //   return null;
                                            // },
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                              hintText: 'Password',
                                              enabledBorder:
                                                  _inputBorderStyle(),
                                              border: _inputBorderStyle(),
                                              focusedBorder:
                                                  _inputBorderStyle(),
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintStyle:
                                                  TextStyle(fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  state is Unauthenticated
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            'Incorrect username or password!',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.red[700],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              ResetPasswordPage
                                                  .resetPasswordPageRouterName);
                                        },
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: kWidth(context),
                                    height: 70,
                                    child: state is SendingLoginData
                                        ? Center(
                                            child: SpinKitRipple(
                                            size: 40,
                                            color: Colors.grey,
                                          ))
                                        : state is Authenticated
                                            ? Center(
                                                child: Icon(
                                                Icons.check,
                                                color: Colors.grey[800],
                                                size: 40,
                                              ))
                                            : Container(
                                                width: kWidth(context),
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      if (_phoneNumberController
                                                                  .value.text ==
                                                              null ||
                                                          _phoneNumberController
                                                                  .value.text ==
                                                              '') {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'Password cannot be empty!')));
                                                        return;
                                                      }

                                                      if (_passwordTextController
                                                                  .value.text ==
                                                              null ||
                                                          _passwordTextController
                                                                  .value.text ==
                                                              '') {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'Phone number cannot be empty!')));
                                                        return;
                                                      }
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .add(LoginEvent(
                                                        phone:
                                                            _phoneNumberController
                                                                .value.text,
                                                        password:
                                                            _passwordTextController
                                                                .value.text,
                                                      ));
                                                    }
                                                  },
                                                  child: Text('LOG IN',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  kBlack),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    25)),
                                                      ))),
                                                ),
                                              ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text('Don\'t have account?',
                                  //     style: TextStyle(fontSize: 18))
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_inputBorderStyle() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[800], width: 1),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), bottomRight: Radius.circular(25)));
}
