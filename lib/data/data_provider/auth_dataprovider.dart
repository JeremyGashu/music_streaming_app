import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';

var testData = '''
{
  "data": "1234",
  "success": true,
  "status": 200
}
''';

var testVerificationData = '''
{
  "data": "some bearer token to be sent with the with header",
  "success": true,
  "status": 200
}
''';

var testVerificationFailureData = '''
{
  "data": "",
  "success": false,
  "status": 200
}
''';

class AuthDataProvider {
  final http.Client client;
  AuthDataProvider({@required this.client}) : assert(client != null);

  Future<http.Response> verifyPhoneNumber({String phoneNo}) async {
    //TODO for later use use the valid URL and send the data there
    // http.Response response = await http.post(
    //   Uri.parse('http://138.68.163.236:8866/v1/request_otp'),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode({'phone': phoneNo}),
    // );
    return http.Response(testData, 200);
  }

  Future<http.Response> verifyOTP({String phoneNo, String otp}) async {
    if (otp == '1234') {
      return http.Response(testVerificationData, 200);
    }
    return http.Response(testVerificationFailureData, 200);
  }

  Future<http.Response> loginUser({String phone, String password}) async {
    http.Response response = await http.post(Uri.parse(LOGIN_URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'phone': phone, 'password': password}));
    return response;
  }

  Future<http.Response> refreshAccessToken({String refreshToken}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $refreshToken',
      'Content-Type': 'application/json'
    };
    http.Response response =
        await http.post(Uri.parse(REFRESH_TOKEN_URL), headers: headers);

    return response;
  }
}
