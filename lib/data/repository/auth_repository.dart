import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/auth_dataprovider.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

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

  Future<bool> resetPassword({String phoneNo}) async {
    http.Response resetData =
        await dataProvider.resetPassword(phoneNo: phoneNo);
    bool success = jsonDecode(resetData.body)['success'];
    return success;
  }

  Future<bool> verifyPasswordReset(
      {String phoneNo,
      String password,
      String confirmPassword,
      String resetCode}) async {
    http.Response verifyResponse = await dataProvider.verifyPasswordReset(
        phoneNo: phoneNo,
        password: password,
        confirmPassword: confirmPassword,
        resetCode: resetCode);
    bool success = jsonDecode(verifyResponse.body)['success'];
    return success;
  }

  Future<AuthData> loginUser({String phone, String password}) async {
    http.Response response = await dataProvider.loginUser(
      password: password,
      phone: phone,
    );
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['success']) {
      return AuthData(
          isAuthenticated: true,
          phone: phone,
          token: decodedResponse['data']['token'],
          message: '',
          refreshToken: decodedResponse['data']['refresh_token']);
    }

    //todo add for the case of 401 response

    return AuthData(
      isAuthenticated: false,
      phone: phone,
      message: decodedResponse['errors']['title'],
    );
  }

  Future<AuthData> refreshAccessToken({String refreshToken}) async {
    http.Response response =
        await dataProvider.refreshAccessToken(refreshToken: refreshToken);
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (decodedResponse['success']) {
      return AuthData(
        isAuthenticated: true,
        token: decodedResponse['data']['access_token'],
        refreshToken: decodedResponse['data']['refresh_token'],
      );
    }
    //todo add for the case of 401 response

    return AuthData(
      isAuthenticated: false,
      message: decodedResponse['errors']['title'],
    );
  }
}
