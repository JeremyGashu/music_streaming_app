import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final Data data;
  final bool success;
  final int status;

  Artist({this.data, this.success, this.status});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
        data: json['data'] != null ? new Data.fromJson(json['data']) : null,
        success: json['success'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }

  @override
  List<Object> get props => [data, success, status];
}

class Data extends Equatable {
  final String id;
  final String userName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String bio;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  Data(
      {this.id,
      this.userName,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.password,
      this.bio,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        userName: json['user_name'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phoneNumber: json['phone_number'],
        password: json['password'],
        bio: json['bio'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['bio'] = this.bio;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }

  @override
  List<Object> get props => [
        id,
        userName,
        firstName,
        lastName,
        phoneNumber,
        password,
        bio,
        createdAt,
        updatedAt,
        deletedAt
      ];
}
