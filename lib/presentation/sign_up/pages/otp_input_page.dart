// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
// import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
// import 'package:streaming_mobile/core/color_constants.dart';
// import 'package:streaming_mobile/core/size_constants.dart';

// class SignUpOTPInputPage extends StatefulWidget {
//   static const String signUpOtpInputPage = 'signup_otp_page_router_name';
//   final String phoneNumber;
//   SignUpOTPInputPage({@required this.phoneNumber});
//   @override
//   _SignUpOTPInputPageState createState() => _SignUpOTPInputPageState();
// }

// class _SignUpOTPInputPageState extends State<SignUpOTPInputPage> {
//   int _seconds = 30;
//   String _otp = '';

//   Timer _timer;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_seconds > 0) {
//           _seconds -= 1;
//         }
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: BlocConsumer<SignUpBloc, SignUpState>(
//           listener: (ctx, state) {
//             if (state is OTPVerified) {
//               print('phone number is verified');
//               // Navigator.pushNamed(context, SignUpPage.signUpPageRouterName, arguments: state.phoneNo);
//             }
//           },
//           builder: (ctx, state) {
//             return Stack(
//               children: [
//                 Positioned(
//                   top: -50,
//                   child: Container(
//                     width: kWidth(context),
//                     height: kHeight(context) * 0.25,
//                     margin: EdgeInsets.only(top: 40),
//                     child: SvgPicture.asset('assets/svg/melody.svg'),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: kHeight(context),
//                       child: Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                                 margin: EdgeInsets.symmetric(vertical: 10),
//                                 width: 300,
//                                 padding: EdgeInsets.only(bottom: 8),
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                         bottom: BorderSide(
//                                   color: kYellow,
//                                   width: 1,
//                                 ))),
//                                 child: Text(
//                                   'Code Sent To: ${widget.phoneNumber}',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     letterSpacing: 1.09,
//                                   ),
//                                 )),
//                             SizedBox(
//                               height: 50,
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               child: OTPTextField(
//                                 length: 4,
//                                 width: MediaQuery.of(context).size.width,
//                                 fieldWidth: 80,
//                                 style: TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey[800]),
//                                 textFieldAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 fieldStyle: FieldStyle.box,
//                                 onCompleted: (pin) {
//                                   setState(() {
//                                     _otp = pin;
//                                   });
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             state is SendingPhoneVerification
//                                 ? Text(
//                                     'Code will be sent in ${_seconds}',
//                                     style: TextStyle(
//                                       letterSpacing: 1.09,
//                                       fontSize: 18,
//                                     ),
//                                   )
//                                 : Container(),
//                             state is OTPVerificationFailed
//                                 ? Text(
//                                     'OTP Verification Failed!',
//                                     style: TextStyle(
//                                       letterSpacing: 1.09,
//                                       fontSize: 18,
//                                     ),
//                                   )
//                                 : Container(),
//                             Container(
//                               width: kWidth(context),
//                               height: 50,
//                               padding: EdgeInsets.symmetric(horizontal: 30),
//                               margin: EdgeInsets.only(top: 40),
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   //TODO do all the OTP verification here
//                                   if (_otp.length < 4) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                             content: Text(
//                                                 'Please enter valid OTP')));
//                                   } else {
//                                     BlocProvider.of<AuthBloc>(context).add(
//                                         SendOTPVerification(
//                                             phoneNo: widget.phoneNumber,
//                                             otp: _otp));
//                                   }
//                                 },
//                                 child: state is VerifyingOTP
//                                     ? Padding(
//                                         padding: EdgeInsets.all(5),
//                                         child: CircularProgressIndicator())
//                                     : Text('Continue',
//                                         style: TextStyle(color: Colors.white)),
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                         MaterialStateProperty.all<Color>(
//                                             kBlack),
//                                     shape: MaterialStateProperty.all<
//                                             RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(25)),
//                                     ))),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
