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

class SendOTPVerification extends AuthEvent {
  final String phoneNo;
  final String otp;
  SendOTPVerification({@required this.phoneNo, this.otp})
      : assert(phoneNo != null && otp != null);
  @override
  List<Object> get props => [phoneNo, otp];
}

class LoginEvent extends AuthEvent {
  final String phoneNo;
  LoginEvent({@required this.phoneNo}) : assert(phoneNo != null);
  @override
  List<Object> get props => [phoneNo];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}