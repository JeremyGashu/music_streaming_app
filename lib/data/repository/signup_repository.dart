import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/signup_dataprovider.dart';

class SignUpRepository {
  final SignUpDataProvider dataProvider;
  SignUpRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<SignupDataResponse> sendSignUpData({String phone, String password}) async {
    http.Response response =
        await dataProvider.sendSignUpData(password: password, phone: phone);
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['success']) {
      return SignupDataResponse(success: true);
    }
    return SignupDataResponse(success: false, error: decodedResponse['errors']['title']);
  }

  Future<SignupDataResponse> verifyPhoneNumber({String phoneNo}) async {
    http.Response authData =
        await dataProvider.verifyPhoneNumber(phoneNo: phoneNo);
    print('status code ${authData.statusCode}');
    var message = jsonDecode(authData.body);
    if(message['success']) {
      return SignupDataResponse(success: true);
    }
    else{
      return SignupDataResponse(success: false, error: message['errors']['title']);
    }
  }

  Future verifyOTP({String phoneNo, String otp}) async {
     http.Response authData =
        await dataProvider.verifyOTP(phoneNo: phoneNo, otp: otp);
    print('status code ${authData.statusCode}');
    var message = jsonDecode(authData.body);
    if(message['success']) {
      return SignupDataResponse(success: true);
    }
    else{
      return SignupDataResponse(success: false, error: message['errors']['title']);
    }
  }
}

class SignupDataResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String error;

  SignupDataResponse({this.success, this.data, this.error});
}
