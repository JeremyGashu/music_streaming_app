import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/presentation/auth/pages/verify_password_reset_page.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(listener: (ctx, state) {
          if (state is SentPasswordResetRequest) {
            print('the state is listened');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => VerifyPasswordResetPage(
                          phoneNo: state.phoneNo,
                        )));
          }
        }, builder: (context, state) {
          return Container(
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
            child: SingleChildScrollView(
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
                                  'RESET PASSWORD',
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
                            child:
                                Image.asset('assets/images/sewasew_logo.png'),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Expanded(
                              child: TextFormField(
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: 'Phone...',
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
                            child: state is SendingResetPasswordRequest
                                ? Center(child: CircularProgressIndicator())
                                : state is SentPasswordResetRequest
                                    ? Center(
                                        child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 40,
                                      ))
                                    : OutlinedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(ResetPassword(
                                                    phoneNo:
                                                        _phoneNumberController
                                                            .value.text));
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

                          // Text('Don\'t have account?',
                          //     style: TextStyle(fontSize: 18))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

_inputBorderStyle() {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
      borderRadius: BorderRadius.circular(25));
}
