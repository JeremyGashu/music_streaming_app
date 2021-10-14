import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/core/utils/check_phone_number.dart';
import 'package:streaming_mobile/presentation/auth/pages/verify_password_reset_page.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String resetPasswordPageRouterName =
      'reset_password_page_router_name';
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(listener: (ctx, state) {
          if (state is SentPasswordResetRequest) {
            print('the state is listened');
            Navigator.pushNamed(context,
                VerifyPasswordResetPage.verifyPasswordResetPageRouterName,
                arguments: state.phoneNo);
          }

          if (state is SendingPasswordResetFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: CustomAlertDialog(
                  type: AlertType.ERROR,
                  message: 'Error reseting password please try again!',
                )));
          }
        }, builder: (context, state) {
          return Stack(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                              height: 20,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              margin: EdgeInsets.only(top: 30),
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
                              height: 15,
                            ),

                            Container(
                                width: kWidth(context),
                                height: 50,
                                margin: EdgeInsets.only(top: 30),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: state is SendingResetPasswordRequest
                                    ? Center(
                                        child: Center(
                                        child: SpinKitRipple(
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ))
                                    : OutlinedButton(
                                        onPressed: () {
                                          if (_phoneNumberController
                                                  .value.text.isNotEmpty &&
                                              (_phoneNumberController
                                                      .value.text !=
                                                  null)) {
                                            if (isPhoneNumber(
                                                _phoneNumberController
                                                    .value.text) && _phoneNumberController.value.text.length == 10) {
                                              BlocProvider.of<AuthBloc>(context)
                                                  .add(ResetPassword(
                                                      phoneNo:
                                                          _phoneNumberController
                                                              .value.text));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      content:
                                                          CustomAlertDialog(
                                                        type: AlertType.ERROR,
                                                        message:
                                                            'Please enter valid phone number!',
                                                      )));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    content: CustomAlertDialog(
                                                      type: AlertType.ERROR,
                                                      message:
                                                          'Please enter valid phone number!',
                                                    )));
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
                                      )),
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
          );
        }),
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
