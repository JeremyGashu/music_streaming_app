import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String phoneNo;
  SignUpEvent({@required this.phoneNo}) : assert(phoneNo != null);
  @override
  List<Object> get props => [phoneNo];
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
