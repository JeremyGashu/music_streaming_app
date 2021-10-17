import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/login/login_page.dart';

class VerifyPasswordResetPage extends StatefulWidget {
  static const String verifyPasswordResetPageRouterName =
      'verify_password_reset_page_router_name';
  final String phoneNo;

  const VerifyPasswordResetPage({this.phoneNo});
  @override
  _VerifyPasswordResetPageState createState() =>
      _VerifyPasswordResetPageState();
}

class _VerifyPasswordResetPageState extends State<VerifyPasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _resetCodeTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
            Container(
              height: kHeight(context),
              child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (ctx, state) async {
                if (state is VerifiedPasswordReset) {
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pushNamed(context, LoginPage.loginPageRouteName);
                } else if (state is VerifyingPasswordResetError) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please check your reset code')));
                }
              }, builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Hero(
                              tag: 'logo_image',
                              child: Container(
                                width: 120,
                                height: 120,
                                margin: EdgeInsets.only(top: 40),
                                child: SvgPicture.asset('assets/svg/Logo.svg'),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Code sent to ${widget.phoneNo}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                      Icons.lock,
                                      color: Colors.white,
                                    )),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _passwordTextController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          hintText: 'Password',
                                          enabledBorder: _inputBorderStyle(),
                                          border: _inputBorderStyle(),
                                          focusedBorder: _inputBorderStyle()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
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
                                      Icons.lock,
                                      color: Colors.white,
                                    )),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _confirmPasswordTextController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          hintText: 'Confirm Password',
                                          enabledBorder: _inputBorderStyle(),
                                          border: _inputBorderStyle(),
                                          focusedBorder: _inputBorderStyle()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
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
                                      Icons.sms,
                                      color: Colors.white,
                                    )),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _resetCodeTextController,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          hintText: 'Reset Code (E.g 1234)',
                                          enabledBorder: _inputBorderStyle(),
                                          border: _inputBorderStyle(),
                                          focusedBorder: _inputBorderStyle()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: kWidth(context),
                              height: 50,
                              margin: EdgeInsets.only(top: 30),
                              child: state is SendingVerifyPasswordReset
                                  ? Center(
                                      child: SpinKitRipple(
                                      color: Colors.grey,
                                      size: 30,
                                    ))
                                  : state is VerifiedPasswordReset
                                      ? Center(
                                          child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 40,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Password Reset Successfully!',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ))
                                      : OutlinedButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              if (_passwordTextController
                                                          .value.text ==
                                                      null ||
                                                  _passwordTextController
                                                      .value.text.isEmpty ||
                                                  _passwordTextController
                                                          .value.text.length <
                                                      6) {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Password cannot be lass than 6 characters!')));
                                                return;
                                              }

                                              if (_confirmPasswordTextController
                                                          .value.text ==
                                                      null ||
                                                  _confirmPasswordTextController
                                                      .value.text.isEmpty ||
                                                  _confirmPasswordTextController
                                                          .value.text !=
                                                      _passwordTextController
                                                          .value.text) {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Password did not match!')));
                                                return;
                                              }

                                              if (_resetCodeTextController
                                                          .value.text ==
                                                      null ||
                                                  _resetCodeTextController
                                                      .value.text.isEmpty) {
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Wrong reset code!')));
                                                return;
                                              }

                                              BlocProvider.of<AuthBloc>(context)
                                                  .add(VerifyPasswordReset(
                                                      password:
                                                          _passwordTextController
                                                              .value.text,
                                                      confirmPassword:
                                                          _confirmPasswordTextController
                                                              .value.text,
                                                      resetCode:
                                                          _resetCodeTextController
                                                              .value.text,
                                                      phoneNo: widget.phoneNo));
                                            }
                                          },
                                          child: Text('Confirm',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(kBlack),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                              ))),
                                        ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
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
