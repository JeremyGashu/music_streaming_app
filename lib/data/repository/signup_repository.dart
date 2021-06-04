import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/signup_dataprovider.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class SignUpRepository {
  final SignUpDataProvider dataProvider;
  SignUpRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<AuthData> sendSignUpData({String phone, String password}) async {
    http.Response response =
        await dataProvider.sendSignUpData(password: password, phone: phone);
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['success']) {
      return AuthData(isAuthenticated: true, phone: phone);
    }
    return AuthData(isAuthenticated: false, phone: '');
  }
}
