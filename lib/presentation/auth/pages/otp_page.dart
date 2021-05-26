import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  int _seconds = 30;
  String _otp = '';

  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds -= 1;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (ctx, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                                        'Verification',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70),
                                        textAlign: TextAlign.center,
                                      ))),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 25,
                        ),
                        state is OTPReceived
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: 300,
                                padding: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: kYellow,
                                  width: 1,
                                ))),
                                child: Text(
                                  state is OTPReceived
                                      ? 'Code Sent To: ${(state).phoneNo}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.09,
                                  ),
                                ))
                            : Container(),
                        SizedBox(
                          height: 50,
                        ),
                        OTPTextField(
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 80,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          onCompleted: (pin) {
                            setState(() {
                              _otp = pin;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        state is SendingAuthData
                            ? Text(
                                'Code will be sent in ${_seconds}',
                                style: TextStyle(
                                  letterSpacing: 1.09,
                                  fontSize: 18,
                                ),
                              )
                            : Container(),
                        state is OTPVerificationFailed
                            ? Text(
                                'OTP Verification Failed!',
                                style: TextStyle(
                                  letterSpacing: 1.09,
                                  fontSize: 18,
                                ),
                              )
                            : Container(),
                        Container(
                          width: 300,
                          height: 50,
                          margin: EdgeInsets.only(top: 40),
                          child: OutlinedButton(
                            onPressed: () {
                              //TODO do all the OTP verification here
                              if (state is OTPReceived) {
                                BlocProvider.of<AuthBloc>(context).add(
                                    SendOTPVerification(
                                        phoneNo: state.phoneNo, otp: _otp));
                              }

                              if (state is OTPVerified) {
                                BlocProvider.of<AuthBloc>(context).add(
                                    SendOTPVerification(
                                        phoneNo: state.phoneNo, otp: _otp));
                              }

                              if (state is OTPVerificationFailed) {
                                BlocProvider.of<AuthBloc>(context).add(
                                    SendOTPVerification(
                                        phoneNo: state.phoneNo, otp: _otp));
                              }
                            },
                            child: state is VerifyingOTP
                                ? Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircularProgressIndicator())
                                : Text('Continue',
                                    style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(kBlack),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
