import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final Data data;
  final bool success;
  final int status;

  Track({this.data, this.success, this.status});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
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
  final int likes;
  final String title;
  final String releaseDate;
  final String artistId;
  final String albumId;
  final String coverImgUrl;
  final String trackUrl;
  final int views;
  final int duration;
  final String lyricsUrl;
  final String createdBy;

  Data(
      {this.id,
      this.likes,
      this.title,
      this.releaseDate,
      this.artistId,
      this.albumId,
      this.coverImgUrl,
      this.trackUrl,
      this.views,
      this.duration,
      this.lyricsUrl,
      this.createdBy});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        likes: json['likes'],
        title: json['title'],
        releaseDate: json['release_date'],
        artistId: json['artist_id'],
        albumId: json['album_id'],
        coverImgUrl: json['cover_img_url'],
        trackUrl: json['track_url'],
        views: json['views'],
        duration: json['duration'],
        lyricsUrl: json['lyrics_url'],
        createdBy: json['created_by']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['likes'] = this.likes;
    data['title'] = this.title;
    data['release_date'] = this.releaseDate;
    data['artist_id'] = this.artistId;
    data['album_id'] = this.albumId;
    data['cover_img_url'] = this.coverImgUrl;
    data['track_url'] = this.trackUrl;
    data['views'] = this.views;
    data['duration'] = this.duration;
    data['lyrics_url'] = this.lyricsUrl;
    data['created_by'] = this.createdBy;
    return data;
  }

  @override
  List<Object> get props => [
        id,
        likes,
        title,
        releaseDate,
        artistId,
        albumId,
        coverImgUrl,
        trackUrl,
        views,
        duration,
        lyricsUrl,
        createdBy
      ];
}
