import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/core/color_constants.dart';
import 'package:streaming_mobile/core/size_constants.dart';
import 'package:streaming_mobile/data/models/country_codes.dart';

import 'otp_page.dart';

class PhoneInputPage extends StatefulWidget {
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
      child: SafeArea(
        child: Scaffold(
          body: Stack(
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
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      height: 50.0,
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
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
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      decoration: InputDecoration(
                                          hintText: 'Phone Number',
                                          enabledBorder: _inputBorderStyle(),
                                          border: _inputBorderStyle(),
                                          focusedBorder: _inputBorderStyle()),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: kWidth(context),
                              height: 50,
                              margin: EdgeInsets.only(top: 100),
                              child: OutlinedButton(
                                onPressed: () {
                                  String pattern =
                                      r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                  RegExp regExp = new RegExp(pattern);

                                  if (regExp.hasMatch(
                                      _phoneNumberController.value.text)) {
                                    BlocProvider.of<AuthBloc>(context).add(
                                        VerifyPhoneNumberEvent(
                                            phoneNo: _phoneNumberController
                                                .value.text));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => OTP(
                                                  phoneNumber:
                                                      _phoneNumberController
                                                          .value.text,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Please Enter a valid phone number!'),
                                    ));
                                  }
                                },
                                child: Text('Continue',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kBlack),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
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
        borderSide: BorderSide(color: Colors.white, width: 3.0),
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
