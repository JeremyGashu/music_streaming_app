import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/core/utils/check_phone_number.dart';
import 'package:streaming_mobile/presentation/auth/pages/otp_page.dart';

class SignUpPage extends StatefulWidget {
  static const String signUpPageRouterName = 'signup_page_router_name';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _phoneNumberController = TextEditingController();
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
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.only(top: 40),
                            child: SvgPicture.asset('assets/svg/Logo.svg'),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 75,
                                  height: 50,
                                  child: Center(
                                      child: Icon(
                                    Icons.phone,
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
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (isPhoneNumber(_phoneNumberController
                                              .value.text) &&
                                          _phoneNumberController
                                                  .value.text.length ==
                                              10) {
                                        return null;
                                      } else {
                                        return 'Please enter valid phone number';
                                      }
                                    },
                                    controller: _phoneNumberController,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintText: 'Phone Number',
                                        enabledBorder: _inputBorderStyle(),
                                        border: _inputBorderStyle(),
                                        focusedBorder: _inputBorderStyle()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 75,
                                  height: 50,
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
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 6) {
                                        return 'Password must be at least 6 Characters!';
                                      }
                                      return null;
                                    },
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
                            height: 10,
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 75,
                                  height: 50,
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
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          (value !=
                                              _passwordTextController
                                                  .value.text)) {
                                        return 'Password did not Match!';
                                      }
                                      return null;
                                    },
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
                            height: 25,
                          ),

                          BlocConsumer<SignUpBloc, SignUpState>(
                              listener: (ctx, state) async {
                            if (state is SignUpError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)));
                            } else if (state is SignedUpSuccessfully) {
                              await Future.delayed(Duration(seconds: 2));
                              BlocProvider.of<SignUpBloc>(context).add(
                                  VerifyPhoneNumber(
                                      phone:
                                          _phoneNumberController.value.text));
                            } else if (state is OTPReceived) {
                              Navigator.pushNamed(
                                  context, OTP.otpPageRouterName);
                            }
                          }, builder: (ctx, state) {
                            return Container(
                              width: kWidth(context),
                              height: 50,
                              margin: EdgeInsets.only(top: 30),
                              child: state is LoadingState
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: SpinKitRipple(
                                        color: Colors.grey,
                                        size: 50,
                                      )))
                                  : state is SignedUpSuccessfully
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.orange,
                                                  size: 20,
                                                ),
                                                Text(
                                                    'Verifying your phone...')
                                              ],
                                            ),
                                            SpinKitRing(
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ],
                                        )
                                      : OutlinedButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              BlocProvider.of<SignUpBloc>(
                                                      context)
                                                  .add(SendSignUpData(
                                                password:
                                                    _passwordTextController
                                                        .value.text,
                                                phone: _phoneNumberController
                                                    .value.text,
                                              ));
                                            }
                                          },
                                          child: Text('Sign Up',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(kBlack),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(25)),
                                              ))),
                                        ),
                            );
                          }),

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
