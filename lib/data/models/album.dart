import 'package:equatable/equatable.dart';

class Album extends Equatable {
  final Data data;
  final bool success;
  final int status;

  Album({this.data, this.success, this.status});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
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
  final String title;
  final String description;
  final String coverImage;
  final int trackCount;
  final int views;
  final int likes;
  final String artistId;

  Data(
      {this.id,
      this.title,
      this.description,
      this.coverImage,
      this.trackCount,
      this.views,
      this.likes,
      this.artistId});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        coverImage: json['cover_image'],
        views: json['views'],
        trackCount: json['track_count'],
        likes: json['likes'],
        artistId: json['artist_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['cover_image'] = this.coverImage;
    data['views'] = this.views;
    data['likes'] = this.likes;
    data['track_count'] = this.trackCount;
    data['artist_id'] = this.artistId;
    return data;
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        coverImage,
        trackCount,
        views,
        likes,
        artistId,
      ];
}
