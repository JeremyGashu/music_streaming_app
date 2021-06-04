import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/auth_dataprovider.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;
  AuthRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<String> verifyPhoneNumber({String phoneNo}) async {
    http.Response authData =
        await dataProvider.verifyPhoneNumber(phoneNo: phoneNo);
    var otp = jsonDecode(authData.body)['data'];
    return otp;
  }

  Future<String> verifyOTP({String phoneNo, String otp}) async {
    http.Response verificationData =
        await dataProvider.verifyOTP(phoneNo: phoneNo, otp: otp);
    var authToken = jsonDecode(verificationData.body)['data'];
    return authToken;
  }
}
