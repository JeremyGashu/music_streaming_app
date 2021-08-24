import 'package:streaming_mobile/data/models/api_metadata.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/data/models/track.dart';

class AlbumsResponse {
  AlbumsResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory AlbumsResponse.fromJson(Map<String, dynamic> json) => AlbumsResponse(
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
  List<Album> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        metaData: MetaData.fromJson(json["meta_data"]),
        data: List<Album>.from(json["data"].map((x) => Album.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta_data": metaData.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Album {
  Album({
    this.albumId,
    this.artistId,
    this.artist,
    this.title,
    this.coverImageUrl,
    this.views,
    this.tracks,
    this.createdAt,
    this.updatedAt,
  });

  String albumId;
  String artistId;
  ArtistModel artist;
  String title;
  String coverImageUrl;
  int views;
  List<Track> tracks;
  DateTime createdAt;
  DateTime updatedAt;

  factory Album.fromJson(Map<String, dynamic> json) {
    // print('this is it ${json["tracks"]['song']}');
    return Album(
      albumId: json["album_id"],
      artistId: json["artist_id"],
      artist:
          json["artist"] != null ? ArtistModel.fromJson(json["artist"]) : null,
      title: json["title"],
      coverImageUrl: json["cover_image_url"],
      views: json["views"] ?? 0,
      tracks: json["tracks"] != null
          ? List<Track>.from(json["tracks"].map((x) {
              print('parse parse parse ${x}');
              return Track.fromJson(x['song']);
            }))
          : [],
      // tracks: [],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "album_id": albumId,
        "artist_id": artistId,
        "artist": artist.toJson(),
        "title": title,
        "cover_image_url": coverImageUrl,
        "views": views,
        "tracks": List<dynamic>.from(tracks.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
