class Genre {
  Genre({
    this.genreId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.image
  });

  String genreId;
  String name;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        genreId: json["genre_id"],
        name: json["name"],
        image : json['cover_image_url'],
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