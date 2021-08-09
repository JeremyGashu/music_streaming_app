import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/models/api_metadata.dart';
import 'package:streaming_mobile/data/models/track.dart';

class NewReleaseResponse {
  NewReleaseResponse({
    this.success,
    this.data,
  });

  bool success;
  NewReleaseResponseData data;

  factory NewReleaseResponse.fromJson(Map<String, dynamic> json) =>
      NewReleaseResponse(
        success: json["success"],
        data: NewReleaseResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class NewReleaseResponseData {
  NewReleaseResponseData({
    this.metaData,
    this.data,
  });

  MetaData metaData;
  NewRelease data;

  factory NewReleaseResponseData.fromJson(Map<String, dynamic> json) =>
      NewReleaseResponseData(
        metaData: MetaData.fromJson(json["meta_data"]),
        data: NewRelease.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta_data": metaData.toJson(),
        "data": data.toJson(),
      };
}

class NewRelease {
  NewRelease({
    this.songs,
    this.albums,
  });

  List<SongElement> songs;
  List<Album> albums;

  factory NewRelease.fromJson(Map<String, dynamic> json) => NewRelease(
        songs: List<SongElement>.from(
            json["songs"].map((x) => SongElement.fromJson(x))),
        albums: List<Album>.from(json["albums"].map((x) => Album.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
        "albums": List<dynamic>.from(albums.map((x) => x.toJson())),
      };
}

class Genre {
  Genre({
    this.genreId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  String genreId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        genreId: json["genre_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "genre_id": genreId,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
