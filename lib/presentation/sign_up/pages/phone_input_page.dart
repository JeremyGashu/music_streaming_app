import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/core/utils/check_phone_number.dart';
import 'package:streaming_mobile/data/models/country_codes.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';

import '../../auth/pages/otp_page.dart';

class PhoneInputPage extends StatefulWidget {
  static const String phoneInputStorageRouterName =
      'phone_input_storage_router_name';
  @override
  _PhoneInputPageState createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  bool _showCountryCode = false;
  String _countryCode = '+251';
  List<CountryCode> _countryCodesList;
  TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showCountryCode) {
          setState(() {
            _showCountryCode = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is OTPReceived) {
              Navigator.pushNamed(context, OTP.otpPageRouterName,
                  arguments: _phoneNumberController.value.text);
            }

            if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                    content: CustomAlertDialog(
                  type: AlertType.ERROR,
                  message: '${state.message}',
                )));
            }
          },
          builder: (context, state) => Stack(
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
                width: kWidth(context),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

                            Container(
                              height: 50.0,
                              margin: EdgeInsets.only(top: 50),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      height: 50.0,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25))),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showCountryCode = true;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '$_countryCode',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              bottom: 10,
                                              right: 10),
                                          hintText: 'Phone Number',
                                          enabledBorder: _inputBorderStyle(),
                                          border: _inputBorderStyle(),
                                          focusedBorder: _inputBorderStyle()),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            state is LoadingState
                                ? Center(
                                    child: SpinKitRipple(
                                      color: Colors.grey[800],
                                      size: 40,
                                    ),
                                  )
                                : Container(
                                    width: kWidth(context),
                                    height: 50,
                                    margin: EdgeInsets.only(top: 20),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (isPhoneNumber(_phoneNumberController
                                                .value.text) &&
                                            _phoneNumberController
                                                    .value.text.length ==
                                                10) {
                                          BlocProvider.of<SignUpBloc>(context)
                                              .add(VerifyPhoneNumber(
                                                  phone: _phoneNumberController
                                                      .value.text));
                                          print(
                                              'phone number => ${_countryCode + _phoneNumberController.value.text}');
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                    content: CustomAlertDialog(
                  type: AlertType.ERROR,
                  message: 'Please enter valif phone number!',
                )));
                                        }
                                      },
                                      child: Text('Continue',
                                          style:
                                              TextStyle(color: Colors.white)),
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
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text('Don\'t have account?',
                            //     style: TextStyle(fontSize: 18))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _showCountryCode ? _buildCountryCodeList(context) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _inputBorderStyle() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[800], width: 1),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomRight: Radius.circular(25)));
  }

  Future<List<CountryCode>> _getCountries() async {
    if (_countryCodesList == null) {
      _countryCodesList = [];
      var rawJson =
          await rootBundle.loadString('assets/json/country_codes.json');
      List<dynamic> countryCodesListRaw = jsonDecode(rawJson);
      print(countryCodesListRaw);
      countryCodesListRaw.forEach((e) {
        _countryCodesList.add(CountryCode.fromJson(e));
      });
      return _countryCodesList;
    } else {
      return _countryCodesList;
    }
  }

  _buildCountryCodeList(context) {
    return FutureBuilder<List<CountryCode>>(
      builder:
          (BuildContext context, AsyncSnapshot<List<CountryCode>> snapshot) {
        if (snapshot.hasData) {
          return Card(
            elevation: 4.0,
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ListTile(
                        tileColor: snapshot.data[index].dialCode == _countryCode
                            ? kYellow
                            : Colors.white,
                        onTap: () {
                          setState(() {
                            _countryCode = snapshot.data[index].dialCode;
                            _showCountryCode = false;
                          });
                        },
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].dialCode),
                      )),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
              color: Colors.white, child: Text(snapshot.error.toString()));
        }
        return Container(
          child: CircularProgressIndicator(),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.all(8.0),
        );
      },
      future: _getCountries(),
    );
  }
}
