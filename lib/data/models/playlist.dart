import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final Metadata mMetadata;
  final Data data;
  final bool success;
  final int status;

  Playlist({this.mMetadata, this.data, this.success, this.status});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
        mMetadata: json['_metadata'] != null
            ? new Metadata.fromJson(json['_metadata'])
            : null,
        data: json['data'] != null ? new Data.fromJson(json['data']) : null,
        success: json['success'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mMetadata != null) {
      data['_metadata'] = this.mMetadata.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }

  @override
  List<Object> get props => [mMetadata, data, success, status];
}

class Metadata extends Equatable {
  final int page;
  final int perPage;
  final int pageCount;
  final int totalCount;
  final List<Links> links;

  Metadata(
      {this.page, this.perPage, this.pageCount, this.totalCount, this.links});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    var list = json['Links'] as List;
    print(list.runtimeType);
    List<Links> linksList = list.map((e) => Links.fromJson(e)).toList();

    return Metadata(
      page: json['page'],
      perPage: json['per_page'],
      pageCount: json['page_count'],
      totalCount: json['total_count'],
      links: linksList
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['page_count'] = this.pageCount;
    data['total_count'] = this.totalCount;
    if (this.links != null) {
      data['Links'] = this.links.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [page, perPage, pageCount, totalCount, links];
}

class Links extends Equatable {
  final String self;
  final String first;
  final String previous;
  final String next;
  final String last;

  Links({this.self, this.first, this.previous, this.next, this.last});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
        self: json['self'],
        first: json['first'],
        previous: json['previous'],
        next: json['next'],
        last: json['last']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['self'] = this.self;
    data['first'] = this.first;
    data['previous'] = this.previous;
    data['next'] = this.next;
    data['last'] = this.last;
    return data;
  }

  @override
  List<Object> get props => [self, first, previous, next, last];
}

class Data extends Equatable {
  final String id;
  final String title;
  final String createdBy;
  final String description;
  final String coverImg;
  final String type;
  final int views;
  final int trackCount;
  final int likes;
  final String createdAt;

  Data(
      {this.id,
      this.views,
      this.description,
      this.coverImg,
      this.likes,
      this.title,
      this.createdBy,
      this.type,
      this.trackCount,
      this.createdAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        title: json['title'],
        views: json['views'],
        description: json["description"],
        coverImg: json["cover_img"],
        likes: json["likes"],
        createdBy: json['created_by'],
        type: json['type'],
        trackCount: json['track_count'],
        createdAt: json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_by'] = this.createdBy;
    data['type'] = this.type;
    data['track_count'] = this.trackCount;
    data['created_at'] = this.createdAt;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['description'] = this.description;
    data['cover_img'] = this.coverImg;
    return data;
  }

  @override
  List<Object> get props => [
        id,
        title,
        createdBy,
        createdAt,
        type,
        trackCount,
        description,
        views,
        coverImg,
        likes
      ];
}
