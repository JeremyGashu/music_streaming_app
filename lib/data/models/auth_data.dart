import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'auth_data.g.dart';

@HiveType(typeId: 2)
class AuthData extends Equatable {
  @HiveField(0)
  final bool isAuthenticated;
  @HiveField(1)
  final String phone;
  @HiveField(2)
  final String token;
  @HiveField(3)
  final String message;
  @HiveField(4)
  final String refreshToken;
  @HiveField(5)
  final String userId;

  AuthData(
      {@required this.isAuthenticated,
      this.phone,
      this.token,
      this.message,
      this.refreshToken, this.userId});

  @override
  List<Object> get props => [isAuthenticated, phone, token, message, userId, refreshToken];
}
