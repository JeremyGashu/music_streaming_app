// import 'package:equatable/equatable.dart';
//
// class Artist extends Equatable {
//   final Data data;
//   final bool success;
//   final int status;
//
//   Artist({this.data, this.success, this.status});
//
//   factory Artist.fromJson(Map<String, dynamic> json) {
//     return Artist(
//         data: json['data'] != null ? new Data.fromJson(json['data']) : null,
//         success: json['success'],
//         status: json['status']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     data['success'] = this.success;
//     data['status'] = this.status;
//     return data;
//   }
//
//   @override
//   List<Object> get props => [data, success, status];
// }
//
// class Data extends Equatable {
//   final String id;
//   final String userName;
//   final String firstName;
//   final String lastName;
//   final String phoneNumber;
//   final String password;
//   final String bio;
//   final String createdAt;
//   final String updatedAt;
//   final String deletedAt;
//
//   Data(
//       {this.id,
//       this.userName,
//       this.firstName,
//       this.lastName,
//       this.phoneNumber,
//       this.password,
//       this.bio,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt});
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//         id: json['id'],
//         userName: json['user_name'],
//         firstName: json['first_name'],
//         lastName: json['last_name'],
//         phoneNumber: json['phone_number'],
//         password: json['password'],
//         bio: json['bio'],
//         createdAt: json['created_at'],
//         updatedAt: json['updated_at'],
//         deletedAt: json['deleted_at']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_name'] = this.userName;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['phone_number'] = this.phoneNumber;
//     data['password'] = this.password;
//     data['bio'] = this.bio;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     return data;
//   }
//
//   @override
//   List<Object> get props => [
//         id,
//         userName,
//         firstName,
//         lastName,
//         phoneNumber,
//         password,
//         bio,
//         createdAt,
//         updatedAt,
//         deletedAt
//       ];
// }

// To parse this JSON data, do
//
//     final artistsResonse = artistsResonseFromJson(jsonString);

import 'package:streaming_mobile/data/models/api_metadata.dart';

class ArtistsResponse {
  ArtistsResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory ArtistsResponse.fromJson(Map<String, dynamic> json) =>
      ArtistsResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.metaData,
    this.data,
  });

  MetaData metaData;
  List<ArtistModel> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        metaData: MetaData.fromJson(json["meta_data"]),
        data: List<ArtistModel>.from(
            json["data"].map((x) => ArtistModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta_data": metaData.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ArtistModel {
  ArtistModel({
    this.artistId,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
  });

  String artistId;
  String firstName;
  String lastName;
  String image;
  String email;
  DateTime createdAt;
  DateTime updatedAt;
  int likeCount;

  factory ArtistModel.fromJson(Map<String, dynamic> json) => ArtistModel(
        artistId: json["artist_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        likeCount: json['like_counts']
      );

  Map<String, dynamic> toJson() => {
        "artist_id": artistId,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
