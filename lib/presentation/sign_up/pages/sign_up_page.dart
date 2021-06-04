import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';

class SignUpPage extends StatefulWidget {
  final String phone;
  SignUpPage({@required this.phone});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
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
                                'SIGN UP',
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
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _usernameTextController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 8) {
                                      return 'Username must be at least 8 Characters.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 20),
                                      hintText: 'Username',
                                      enabledBorder: _inputBorderStyle(),
                                      border: _inputBorderStyle(),
                                      focusedBorder: _inputBorderStyle()),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordTextController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 8) {
                                      return 'Password must be at least 8 Characters!';
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
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _confirmPasswordTextController,
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
                                      contentPadding: EdgeInsets.only(left: 20),
                                      hintText: 'Confirm Password',
                                      enabledBorder: _inputBorderStyle(),
                                      border: _inputBorderStyle(),
                                      focusedBorder: _inputBorderStyle()),
                                ),
                              ),
                            ],
                          ),
                        ),

                        BlocConsumer<SignUpBloc, SignUpState>(
                            listener: (ctx, state) {
                          if (state is SignUpError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }
                        }, builder: (ctx, state) {
                          return Container(
                            width: kWidth(context),
                            height: 50,
                            margin: EdgeInsets.only(top: 30),
                            child: state is SendingSignUpData
                                ? CircularProgressIndicator()
                                : OutlinedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        BlocProvider.of<SignUpBloc>(context)
                                            .add(SendSignUpData(
                                          password: _passwordTextController
                                              .value.text,
                                          phone: '0936951272',
                                        ));
                                      }
                                    },
                                    child: Text('Sign Up',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                kBlack),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
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
