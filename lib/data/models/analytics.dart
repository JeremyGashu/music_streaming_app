class Analytics {
  Analytics({
    this.analyticsId,
    this.songId,
    this.userId,
    this.duration,
    this.listenedAt,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  String analyticsId;
  String songId;
  String userId;
  int duration;
  DateTime listenedAt;
  String location;
  DateTime createdAt;
  DateTime updatedAt;

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
        analyticsId: json["analytics_id"],
        songId: json["song_id"],
        userId: json["user_id"],
        duration: json["duration"],
        listenedAt: DateTime.parse(json["listened_at"]),
        location: json["location"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "analytics_id": analyticsId,
        "song_id": songId,
        "user_id": userId,
        "duration": duration,
        "listened_at": listenedAt.toIso8601String(),
        "location": location,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
