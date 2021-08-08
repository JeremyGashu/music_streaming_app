// class TracksResponse {
//   TracksResponse({this.success, this.data, this.error});
//
//   bool success;
//   Data data;
//   Error error;
//
//   factory TracksResponse.fromJson(Map<String, dynamic> json) => TracksResponse(
//       success: json["success"] != null ? json["success"] : false,
//       data: json["data"] != null ? Data.fromJson(json["data"]) : null,
//       error: json['error'] != null ? Error.fromJson(json['error']) : null);
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data.toJson(),
//       };
// }
//
// class Error {
//   final int code;
//   final String source;
//   final String title;
//
//   Error({this.code, this.source, this.title});
//
//   factory Error.fromJson(Map<String, dynamic> json) => Error(
//         title: json['title'],
//         code: json['code'],
//         source: json['source'],
//       );
// }
//
// class Data {
//   Data({
//     this.metaData,
//     this.data,
//   });
//
//   MetaData metaData;
//   List<Track> data;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         metaData: MetaData.fromJson(json["meta_data"]),
//         data: List<Track>.from(
//             json["data"]['songs'].map((x) => Track.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "meta_data": metaData.toJson(),
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }
//
// class Track {
//   Track({
//     this.trackId,
//     this.albumId,
//     this.album,
//     this.songId,
//     this.song,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   String trackId;
//   String albumId;
//   Album album;
//   String songId;
//   Song song;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Track.fromJson(Map<String, dynamic> json) => Track(
//         trackId: json["track_id"],
//         albumId: json["album_id"],
//         album: json["album"] != null ? Album.fromJson(json["album"]) : null,
//         songId: json["song_id"],
//         song: json["song"] != null ? Song.fromJson(json["song"]) : Song(),
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "track_id": trackId,
//         "album_id": albumId,
//         "album": album.toJson(),
//         "song_id": songId,
//         "song": song.toJson(),
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
//
// class Album {
//   Album({
//     this.albumId,
//     this.artistId,
//     this.artist,
//     this.title,
//     this.coverImageUrl,
//     this.views,
//     this.tracks,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   String albumId;
//   String artistId;
//   Artist artist;
//   String title;
//   String coverImageUrl;
//   int views;
//   dynamic tracks;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Album.fromJson(Map<String, dynamic> json) => Album(
//         albumId: json["album_id"],
//         artistId: json["artist_id"],
//         artist: Artist.fromJson(json["artist"]),
//         title: json["title"],
//         coverImageUrl: json["cover_image_url"],
//         views: json["views"],
//         tracks: json["tracks"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "album_id": albumId,
//         "artist_id": artistId,
//         "artist": artist.toJson(),
//         "title": title,
//         "cover_image_url": coverImageUrl,
//         "views": views,
//         "tracks": tracks,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
//
// class Artist {
//   Artist({
//     this.artistId,
//     this.firstName,
//     this.lastName,
//     this.image,
//     this.email,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   String artistId;
//   String firstName;
//   String lastName;
//   String image;
//   String email;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Artist.fromJson(Map<String, dynamic> json) => Artist(
//         artistId: json["artist_id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         image: json["image"],
//         email: json["email"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "artist_id": artistId,
//         "first_name": firstName,
//         "last_name": lastName,
//         "image": image,
//         "email": email,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
//
// class Song {
//   Song({
//     this.songId,
//     this.title,
//     this.coverImageUrl,
//     this.songUrl,
//     this.views,
//     this.duration,
//     this.releasedAt,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   String songId;
//   String title;
//   String coverImageUrl;
//   String songUrl;
//   int views;
//   int duration;
//   DateTime releasedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Song.fromJson(Map<String, dynamic> json) => Song(
//         songId: json["song_id"],
//         title: json["title"],
//         coverImageUrl: json["cover_image_url"],
//         songUrl: json["song_url"],
//         views: json["views"],
//         duration: json["duration"],
//         releasedAt: DateTime.parse(json["released_at"]),
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "song_id": songId,
//         "title": title,
//         "cover_image_url": coverImageUrl,
//         "song_url": songUrl,
//         "views": views,
//         "duration": duration,
//         "released_at": releasedAt.toIso8601String(),
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
//
// class MetaData {
//   MetaData({
//     this.page,
//     this.perPage,
//     this.pageCount,
//     this.totalCount,
//     this.links,
//   });
//
//   int page;
//   int perPage;
//   int pageCount;
//   int totalCount;
//   List<Link> links;
//
//   factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
//         page: json["page"],
//         perPage: json["per_page"],
//         pageCount: json["page_count"],
//         totalCount: json["total_count"],
//         links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "page": page,
//         "per_page": perPage,
//         "page_count": pageCount,
//         "total_count": totalCount,
//         "links": List<dynamic>.from(links.map((x) => x.toJson())),
//       };
// }
//
// class Link {
//   Link({
//     this.self,
//     this.first,
//     this.previous,
//     this.next,
//     this.last,
//   });
//
//   String self;
//   String first;
//   String previous;
//   String next;
//   String last;
//
//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         self: json["self"] == null ? null : json["self"],
//         first: json["first"] == null ? null : json["first"],
//         previous: json["previous"] == null ? null : json["previous"],
//         next: json["next"] == null ? null : json["next"],
//         last: json["last"] == null ? null : json["last"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "self": self == null ? null : self,
//         "first": first == null ? null : first,
//         "previous": previous == null ? null : previous,
//         "next": next == null ? null : next,
//         "last": last == null ? null : last,
//       };
// }

// To parse this JSON data, do
//
//     final tracksResponse = tracksResponseFromJson(jsonString);

class TracksResponse {
  TracksResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory TracksResponse.fromJson(Map<String, dynamic> json) => TracksResponse(
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
  DataData data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        metaData: MetaData.fromJson(json["meta_data"]),
        data: DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta_data": metaData.toJson(),
        "data": data.toJson(),
      };
}

class DataData {
  DataData({
    this.songs,
  });

  List<SongElement> songs;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        songs: List<SongElement>.from(
            json["songs"].map((x) => SongElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
      };
}

class SongElement {
  SongElement({
    this.song,
  });

  Track song;

  factory SongElement.fromJson(Map<String, dynamic> json) => SongElement(
        song: Track.fromJson(json["song"]),
      );

  Map<String, dynamic> toJson() => {
        "song": song.toJson(),
      };
}

class Track {
  Track({
    this.songId,
    this.artistId,
    this.artist,
    this.title,
    this.coverImageUrl,
    this.songUrl,
    this.isSingle,
    this.genreId,
    this.genre,
    this.views,
    this.duration,
    this.lyricsLocation,
    this.imageLocation,
    this.trackLocation,
    this.releasedAt,
    this.createdAt,
    this.updatedAt,
  });

  String songId;
  String artistId;
  Artist artist;
  String title;
  String coverImageUrl;
  String songUrl;
  bool isSingle;
  String genreId;
  Genre genre;
  int views;
  int duration;
  String lyricsLocation;
  String imageLocation;
  String trackLocation;
  DateTime releasedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        songId: json["song_id"],
        artistId: json["artist_id"],
        artist: json["artist"] != null ? Artist.fromJson(json["artist"]) : null,
        title: json["title"],
        coverImageUrl: json["cover_image_url"],
        songUrl: json["song_url"],
        isSingle: json["is_single"],
        genreId: json["genre_id"],
        genre: json["Genre"] != null ? Genre.fromJson(json["Genre"]) : null,
        views: json["views"],
        duration: json["duration"],
        lyricsLocation: json["lyrics_location"],
        imageLocation: json["image_location"],
        trackLocation: json["track_location"],
        releasedAt: DateTime.parse(json["released_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "song_id": songId,
        "artist_id": artistId,
        "artist": artist.toJson(),
        "title": title,
        "cover_image_url": coverImageUrl,
        "song_url": songUrl,
        "is_single": isSingle,
        "genre_id": genreId,
        "Genre": genre.toJson(),
        "views": views,
        "duration": duration,
        "lyrics_location": lyricsLocation,
        "image_location": imageLocation,
        "track_location": trackLocation,
        "released_at": releasedAt.toIso8601String(),
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
