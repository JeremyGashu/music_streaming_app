import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';

class SignUpDataProvider {
  final http.Client client;

  SignUpDataProvider({this.client}) : assert(client != null);

  Future<http.Response> sendSignUpData({String phone, String password}) async {
    http.Response response = await http.post(
      Uri.parse(SIGN_UP_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    return response;
  }

  Future<http.Response> verifyPhoneNumber({String phoneNo}) async {
    http.Response response = await http.post(
      Uri.parse(REQUEST_OTP),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'phone': phoneNo}),
    );
    return response;
  }

  Future<http.Response> verifyOTP({String phoneNo, String otp}) async {
    http.Response response = await http.post(
      Uri.parse(VERIFY_OTP),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'phone': phoneNo, 'otp' : otp}),
    );
    return response;
  }
}
