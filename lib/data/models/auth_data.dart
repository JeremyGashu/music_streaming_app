import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthData extends Equatable {
  final bool isAuthenticated;
  final String phone;

  AuthData({@required this.isAuthenticated, @required this.phone});

  @override
  List<Object> get props => [isAuthenticated, phone];
}
