class Genre {
  String id;
  String name;

  Genre({
      this.id,
      this.name
  });

  factory Genre.fromJson(Map<String, dynamic> json){
    return Genre(
      id: json['genre_id'],
      name: json['name']
    );
  }

}