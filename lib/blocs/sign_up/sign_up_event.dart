import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendSignUpData extends SignUpEvent {
  final String phone;
  final password;
  SendSignUpData({@required this.password, @required this.phone});
  @override
  List<Object> get props => [];
}
