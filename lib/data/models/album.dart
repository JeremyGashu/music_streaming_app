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
  Artist artist;
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
      artist: json["artist"] != null ? Artist.fromJson(json["artist"]) : null,
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

class Artist {
  Artist({
    this.artistId,
    this.firstName,
    this.lastName,
    this.image,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  String artistId;
  String firstName;
  String lastName;
  String image;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        artistId: json["artist_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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

class MetaData {
  MetaData({
    this.page,
    this.perPage,
    this.pageCount,
    this.totalCount,
    this.links,
  });

  int page;
  int perPage;
  int pageCount;
  int totalCount;
  List<Link> links;

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        page: json["page"],
        perPage: json["per_page"],
        pageCount: json["page_count"],
        totalCount: json["total_count"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "page_count": pageCount,
        "total_count": totalCount,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
      };
}

class Link {
  Link({
    this.self,
    this.first,
    this.previous,
    this.next,
    this.last,
  });

  String self;
  String first;
  String previous;
  String next;
  String last;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        self: json["self"] == null ? null : json["self"],
        first: json["first"] == null ? null : json["first"],
        previous: json["previous"] == null ? null : json["previous"],
        next: json["next"] == null ? null : json["next"],
        last: json["last"] == null ? null : json["last"],
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
        "first": first == null ? null : first,
        "previous": previous == null ? null : previous,
        "next": next == null ? null : next,
        "last": last == null ? null : last,
      };
}
