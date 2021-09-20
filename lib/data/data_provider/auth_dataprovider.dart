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
    http.Response response = await http.post(
      Uri.parse(REQUEST_OTP),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'phone': phoneNo}),
    );
    return response;
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

  Future<http.Response> resetPassword({String phoneNo}) async {
    http.Response response = await http.post(Uri.parse(RESET_PASSWORD_URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'phone': phoneNo,
        }));
    return response;
  }

  Future<http.Response> verifyPasswordReset(
      {String phoneNo,
      String password,
      String confirmPassword,
      String resetCode}) async {
    http.Response response =
        await http.post(Uri.parse(VERIFY_PASSWORD_RESET_URL),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'phone': phoneNo,
              'confirm_password': confirmPassword,
              'password': password,
              'reset_code': resetCode
            }));
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
