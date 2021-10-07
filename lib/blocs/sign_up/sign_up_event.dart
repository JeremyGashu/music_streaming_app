import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendSignUpData extends SignUpEvent {
  final String phone;
  final String password;
  SendSignUpData({@required this.password, @required this.phone});
  @override
  List<Object> get props => [phone, password];
}

class VerifyPhoneNumber extends SignUpEvent {
  final String phone;
  VerifyPhoneNumber({@required this.phone});
  @override
  List<Object> get props => [phone];
}

class VerifyOTP extends SignUpEvent {
  final String phone;
  final String otp;
  VerifyOTP({@required this.phone,@required this.otp});
  @override
  List<Object> get props => [phone, required];
}
