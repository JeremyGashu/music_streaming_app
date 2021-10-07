import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SendingSignUpData extends SignUpState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SignUpState {
  @override
  List<Object> get props => [];
}

class OTPReceived extends SignUpState {
  final String phoneNo;
  OTPReceived({@required this.phoneNo});
  @override
  List<Object> get props => [phoneNo];
}

class OTPVerified extends SignUpState {
  final String phoneNo;
  OTPVerified({@required this.phoneNo});
  @override
  List<Object> get props => [phoneNo];
}

class SignedUpSuccessfully extends SignUpState {
  SignedUpSuccessfully();
  @override
  List<Object> get props => [];
}

class SignUpError extends SignUpState {
  final String message;
  SignUpError({@required this.message});
}
