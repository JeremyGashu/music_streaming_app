// import 'package:equatable/equatable.dart';
// import 'package:hive/hive.dart';
//
//
// class Playlist extends Equatable {
//   final Metadata mMetadata;
//   final Data data;
//   final bool success;
//   final int status;
//
//   Playlist({this.mMetadata, this.data, this.success, this.status});
//
//   factory Playlist.fromJson(Map<String, dynamic> json) {
//     return Playlist(
//         mMetadata: json['_metadata'] != null
//             ? new Metadata.fromJson(json['_metadata'])
//             : null,
//         data: json['data'] != null ? new Data.fromJson(json['data']) : null,
//         success: json['success'],
//         status: json['status']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.mMetadata != null) {
//       data['_metadata'] = this.mMetadata.toJson();
//     }
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     data['success'] = this.success;
//     data['status'] = this.status;
//     return data;
//   }
//
//   @override
//   List<Object> get props => [mMetadata, data, success, status];
// }
//
// class Metadata extends Equatable {
//   final int page;
//   final int perPage;
//   final int pageCount;
//   final int totalCount;
//   final List<Links> links;
//
//   Metadata(
//       {this.page, this.perPage, this.pageCount, this.totalCount, this.links});
//
//   factory Metadata.fromJson(Map<String, dynamic> json) {
//     var list = json['Links'] as List;
//     print(list.runtimeType);
//     List<Links> linksList = list.map((e) => Links.fromJson(e)).toList();
//
//     return Metadata(
//         page: json['page'],
//         perPage: json['per_page'],
//         pageCount: json['page_count'],
//         totalCount: json['total_count'],
//         links: linksList);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['page'] = this.page;
//     data['per_page'] = this.perPage;
//     data['page_count'] = this.pageCount;
//     data['total_count'] = this.totalCount;
//     if (this.links != null) {
//       data['Links'] = this.links.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   @override
//   List<Object> get props => [page, perPage, pageCount, totalCount, links];
// }
//
// class Links extends Equatable {
//   final String self;
//   final String first;
//   final String previous;
//   final String next;
//   final String last;
//
//   Links({this.self, this.first, this.previous, this.next, this.last});
//
//   factory Links.fromJson(Map<String, dynamic> json) {
//     return Links(
//         self: json['self'],
//         first: json['first'],
//         previous: json['previous'],
//         next: json['next'],
//         last: json['last']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['self'] = this.self;
//     data['first'] = this.first;
//     data['previous'] = this.previous;
//     data['next'] = this.next;
//     data['last'] = this.last;
//     return data;
//   }
//
//   @override
//   List<Object> get props => [self, first, previous, next, last];
// }
//
// class Data extends Equatable {
//   final String id;
//
//   final String title;
//
//   @HiveField(2)
//   final String createdBy;
//
//   @HiveField(3)
//   final String description;
//
//   @HiveField(4)
//   final String coverImg;
//
//   @HiveField(5)
//   final String type;
//
//   @HiveField(6)
//   final int views;
//
//   @HiveField(7)
//   final int trackCount;
//
//   @HiveField(8)
//   final int likes;
//
//   @HiveField(9)
//   final String createdAt;
//
//   Data(
//       {this.id,
//       this.views,
//       this.description,
//       this.coverImg,
//       this.likes,
//       this.title,
//       this.createdBy,
//       this.type,
//       this.trackCount,
//       this.createdAt});
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//         id: json['id'],
//         title: json['title'],
//         views: json['views'],
//         description: json["description"],
//         coverImg: json["cover_img"],
//         likes: json["likes"],
//         createdBy: json['created_by'],
//         type: json['type'],
//         trackCount: json['track_count'],
//         createdAt: json['created_at']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['created_by'] = this.createdBy;
//     data['type'] = this.type;
//     data['track_count'] = this.trackCount;
//     data['created_at'] = this.createdAt;
//     data['likes'] = this.likes;
//     data['views'] = this.views;
//     data['description'] = this.description;
//     data['cover_img'] = this.coverImg;
//     return data;
//   }
//
//   @override
//   List<Object> get props => [
//         id,
//         title,
//         createdBy,
//         createdAt,
//         type,
//         trackCount,
//         description,
//         views,
//         coverImg,
//         likes
//       ];
// }

class PlaylistsResponse {
  PlaylistsResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory PlaylistsResponse.fromJson(Map<String, dynamic> json) =>
      PlaylistsResponse(
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
  List<Playlist> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        metaData: MetaData.fromJson(json["meta_data"]),
        data:
            List<Playlist>.from(json["data"].map((x) => Playlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta_data": metaData.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Playlist {
  Playlist({
    this.playlistId,
    this.userId,
    this.title,
    this.createdBy,
    this.type,
    this.songs,
    this.createdAt,
    this.updatedAt,
  });

  String playlistId;
  String userId;
  String title;
  String createdBy;
  String type;
  List<SongData> songs;
  DateTime createdAt;
  DateTime updatedAt;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        playlistId: json["playlist_id"],
        userId: json["user_id"],
        title: json["title"],
        createdBy: json["created_by"],
        type: json["type"],
        songs:
            List<SongData>.from(json["songs"].map((x) => SongData.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "playlist_id": playlistId,
        "user_id": userId,
        "title": title,
        "created_by": createdBy,
        "type": type,
        "songs": List<dynamic>.from(songs.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SongData {
  SongData({
    this.id,
    this.playlistId,
    this.songId,
    this.song,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String playlistId;
  String songId;
  Song song;
  DateTime createdAt;
  DateTime updatedAt;

  factory SongData.fromJson(Map<String, dynamic> json) => SongData(
        id: json["id"],
        playlistId: json["playlist_id"],
        songId: json["song_id"],
        song: Song.fromJson(json["song"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "playlist_id": playlistId,
        "song_id": songId,
        "song": song.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Song {
  Song({
    this.songId,
    this.artistId,
    this.artist,
    this.title,
    this.coverImageUrl,
    this.songUrl,
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

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        songId: json["song_id"],
        artistId: json["artist_id"],
        artist: Artist.fromJson(json["artist"]),
        title: json["title"],
        coverImageUrl: json["cover_image_url"],
        songUrl: json["song_url"],
        genreId: json["genre_id"],
        genre: Genre.fromJson(json["Genre"]),
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
