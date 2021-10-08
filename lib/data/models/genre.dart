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