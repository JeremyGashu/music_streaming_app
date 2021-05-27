import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class SendingAuthData extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final bool isAuthenticated;
  final String otp;
  Authenticated({@required this.isAuthenticated, @required this.otp});
  @override
  List<Object> get props => [isAuthenticated, otp];
}

class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class VerifyingOTP extends AuthState {
  @override
  List<Object> get props => [];
}

class OTPVerified extends AuthState {
  final String token;
  final String phoneNo;
  final String otp;
  OTPVerified(
      {@required this.token, @required this.otp, @required this.phoneNo});
  @override
  List<Object> get props => [token, otp, phoneNo];
}

class OTPVerificationFailed extends AuthState {
  final String phoneNo;
  OTPVerificationFailed({@required this.phoneNo});
  @override
  List<Object> get props => [phoneNo];
}

class OTPReceived extends AuthState {
  final String otp;
  final String phoneNo;
  OTPReceived({@required this.otp, this.phoneNo});
  @override
  List<Object> get props => [otp];
}

class AuthenticationError extends AuthState {
  final String message;
  AuthenticationError({this.message}) : assert(message != null);
  @override
  List<Object> get props => [message];
}
