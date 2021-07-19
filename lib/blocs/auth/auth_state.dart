import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class SendingPhoneVerification extends AuthState {
  @override
  List<Object> get props => [];
}

class VerifyingOTP extends AuthState {
  @override
  List<Object> get props => [];
}

class OTPVerified extends AuthState {
  final String phoneNo;
  final String otp;
  OTPVerified({@required this.otp, @required this.phoneNo});
  @override
  List<Object> get props => [otp, phoneNo];
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

class Authenticated extends AuthState {
  final AuthData authData;
  Authenticated({@required this.authData});
  @override
  List<Object> get props => [authData];
}

class Unauthenticated extends AuthState {
  final AuthData authData;
  Unauthenticated({@required this.authData});
  @override
  List<Object> get props => [authData];
}

class SendingLoginData extends AuthState {
  @override
  List<Object> get props => [];
}

//TODO add the refresh token states here
class SendingRefreshToken extends AuthState {
  @override
  List<Object> get props => [];
}

class TokenRefreshSuccessful extends AuthState {
  final String newToken;

  TokenRefreshSuccessful({this.newToken});
  @override
  List<Object> get props => [newToken];
}

class SendingRefreshTokenFailed extends AuthState {
  final String message;

  SendingRefreshTokenFailed({this.message});
  @override
  List<Object> get props => [];
}

//TODO add the states for request_reset_password
class SendingResetPasswordRequest extends AuthState {}

class SentPasswordResetRequest extends AuthState {
  final String phoneNo;

  SentPasswordResetRequest({this.phoneNo});
  @override
  List<Object> get props => [phoneNo];
}

class SendingPasswordResetFailed extends AuthState {
  final String message;

  SendingPasswordResetFailed({this.message});
  @override
  List<Object> get props => [message];
}

///
//TODO add the states for request_reset_password
class SendingVerifyPasswordReset extends AuthState {}

class VerifiedPasswordReset extends AuthState {
  final bool reset;

  VerifiedPasswordReset({this.reset});
  @override
  List<Object> get props => [reset];
}

class VerifyingPasswordResetError extends AuthState {
  final String message;

  VerifyingPasswordResetError({this.message});
  @override
  List<Object> get props => [message];
}

///
class CheckingAuthOnStartup extends AuthState {
  @override
  List<Object> get props => [];
}
