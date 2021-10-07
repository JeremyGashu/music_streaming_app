import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class CheckAuthOnStartUp extends AuthEvent {
  @override
  List<Object> get props => [];
}

class RefreshToken extends AuthEvent {
  RefreshToken();
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;
  LoginEvent({@required this.phone, @required this.password})
      : assert(phone != null && password != null);
  @override
  List<Object> get props => [phone, password];
}

class SendOTPVerification extends AuthEvent {
  final String phoneNo;
  final String otp;
  SendOTPVerification({@required this.phoneNo, this.otp})
      : assert(phoneNo != null && otp != null);
  @override
  List<Object> get props => [phoneNo, otp];
}

//todo add events for require reset and verify password
class ResetPassword extends AuthEvent {
  final String phoneNo;

  ResetPassword({this.phoneNo});
  @override
  List<Object> get props => [phoneNo];
}

class VerifyPasswordReset extends AuthEvent {
  final String phoneNo;
  final String password;
  final String confirmPassword;
  final String resetCode;

  VerifyPasswordReset(
      {this.phoneNo, this.password, this.confirmPassword, this.resetCode});

  @override
  List<Object> get props => [phoneNo, password, confirmPassword, resetCode];
}

class VerifyPhoneNumberEvent extends AuthEvent {
  final String phoneNo;
  VerifyPhoneNumberEvent({@required this.phoneNo}) : assert(phoneNo != null);
  @override
  List<Object> get props => [phoneNo];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
