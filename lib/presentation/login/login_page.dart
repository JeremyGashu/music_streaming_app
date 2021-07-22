import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/mainpage/mainpage.dart';

class LoginPage extends StatefulWidget {
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: kHeight(context),
            width: kWidth(context),
            child: SvgPicture.asset("assets/svg/login_bg.svg", fit: BoxFit.cover, height: kHeight(context), width: kWidth(context),)
          ),
          BlocConsumer<AuthBloc, AuthState>(listener: (ctx, state) {
            if (state is AuthenticationError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }else if(state is Authenticated){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20),
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
                                  'LOG IN',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                )))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.only(top: 15),
                            child: Image.asset("assets/images/app_logo_white.png"),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Expanded(
                              child: TextFormField(
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'Phone number',
                                    enabledBorder: _inputBorderStyle(),
                                    border: _inputBorderStyle(),
                                    focusedBorder: _inputBorderStyle(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    fontSize: 14.0
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: kBlack,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
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
                                    focusedBorder: _inputBorderStyle(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  hintStyle: TextStyle(
                                      fontSize: 14.0
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_rounded,
                                    color: kBlack,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          state is Unauthenticated
                              ? Text('Incorrect username or password!')
                              : Container(),

                          Container(
                            width: kWidth(context),
                            height: 50,
                            child: state is SendingLoginData
                                ? Center(child: CircularProgressIndicator(color: Colors.white,))
                                : state is Authenticated
                                ? Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                ))
                                : OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState
                                    .validate()) {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(LoginEvent(
                                    phone: _phoneNumberController
                                        .value.text,
                                    password: _passwordTextController
                                        .value.text,
                                  ));
                                }
                              },
                              child: Text('LOG IN',
                                  style:
                                  TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<
                                      Color>(kYellow),
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

                          Container(
                            width: double.infinity,
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              ResetPasswordPage()));
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
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
              ),
            );
          }),
        ],
      ),
    );
  }
}

_inputBorderStyle() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
      borderRadius: BorderRadius.circular(25));
}
