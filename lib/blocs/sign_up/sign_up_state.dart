import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

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

class SignedUpSuccessfully extends SignUpState {
  final AuthData authData;
  SignedUpSuccessfully({@required this.authData});
  @override
  List<Object> get props => [authData];
}

class SignUpError extends SignUpState {
  final String message;
  SignUpError({@required this.message});
}
