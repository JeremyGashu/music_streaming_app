import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SignUpDataProvider {
  final http.Client client;

  SignUpDataProvider({this.client}) : assert(client != null);

  Future<http.Response> sendSignUpData({String phone, String password}) async {
    http.Response response = await http.post(
      Uri.parse('http://138.68.163.236:8866/v1/signup/user'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    return response;
  }
}
