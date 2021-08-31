import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/models/api_metadata.dart';

class FeaturedAlbumResponse {
  FeaturedAlbumResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory FeaturedAlbumResponse.fromJson(Map<String, dynamic> json) => FeaturedAlbumResponse(
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
  List<Datum> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    metaData: MetaData.fromJson(json["meta_data"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta_data": metaData.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.featuredAlbumId,
    this.albumId,
    this.album,
    this.createdAt,
    this.updatedAt,
  });

  String featuredAlbumId;
  String albumId;
  Album album;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    featuredAlbumId: json["featured_album_id"],
    albumId: json["album_id"],
    album:json["album"] != null ? Album.fromJson(json["album"]) : null,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "featured_album_id": featuredAlbumId,
    "album_id": albumId,
    "album": album.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
