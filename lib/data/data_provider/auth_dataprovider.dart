import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<http.Response> sendAuthData({String phoneNo}) async {
    //TODO for later use use the valid URL
    // String url = '${BASE_URL}';
    return http.Response(testData, 200);
  }

  Future<http.Response> verifyOTP({String phoneNo, String otp}) async {
    if (otp == '1234') {
      return http.Response(testVerificationData, 200);
    }
    return http.Response(testVerificationFailureData, 200);
  }
}
