import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/login/login_page.dart';

class VerifyPasswordResetPage extends StatefulWidget {
  static const String verifyPasswordResetPageRouterName = 'verify_password_reset_page_router_name';
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: kHeight(context),
          width: kWidth(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/playlist_top_bg.png",
                ),
                alignment: Alignment.topCenter,
              ),
              gradient: LinearGradient(
                colors: [kRed, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment(0.8, 0.8),
              )),
          child:
              BlocConsumer<AuthBloc, AuthState>(listener: (ctx, state) async {
            if (state is VerifiedPasswordReset) {
              await Future.delayed(Duration(seconds: 2));
              Navigator.pushNamed(context, LoginPage.loginPageRouteName);
            } else if (state is VerifyingPasswordResetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please check your reset code')));
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.zero,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.chevron_left,
                              color: Colors.white70,
                            ),
                            iconSize: 40,
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 40),
                                child: Text(
                                  'VERIFY CODE',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Image.asset('assets/images/sewasew_logo.png'),
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
                            margin: EdgeInsets.only(top: 20),
                            child: Expanded(
                              child: TextFormField(
                                controller: _passwordTextController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password!';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'Password',
                                    enabledBorder: _inputBorderStyle(),
                                    border: _inputBorderStyle(),
                                    focusedBorder: _inputBorderStyle()),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Expanded(
                              child: TextFormField(
                                controller: _confirmPasswordTextController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      _confirmPasswordTextController
                                              .value.text !=
                                          _passwordTextController.value.text) {
                                    return 'Can\'t be empty or different from password!';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'Confirm Password',
                                    enabledBorder: _inputBorderStyle(),
                                    border: _inputBorderStyle(),
                                    focusedBorder: _inputBorderStyle()),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Expanded(
                              child: TextFormField(
                                controller: _resetCodeTextController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      _resetCodeTextController
                                              .value.text.length !=
                                          4) {
                                    return 'Can\'t be empty or different from 4 digits!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'Reset Code (E.g 1234)',
                                    enabledBorder: _inputBorderStyle(),
                                    border: _inputBorderStyle(),
                                    focusedBorder: _inputBorderStyle()),
                              ),
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
                                ? Center(child: CircularProgressIndicator())
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
                                            style:
                                                TextStyle(color: Colors.white)),
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
              ),
            );
          }),
        ),
      ),
    );
  }
}

_inputBorderStyle() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
      borderRadius: BorderRadius.circular(25));
}
