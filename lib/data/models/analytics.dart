
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'analytics.g.dart';

@HiveType(typeId: 3)
class Analytics extends Equatable{
  @HiveField(0)
  final String analyticsId;
  @HiveField(1)
  final String songId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final int duration;
  @HiveField(4)
  final DateTime listenedAt;
  @HiveField(5)
  final String location;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;
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

      @override
      List<Object> get props => [analyticsId, songId, userId, duration, listenedAt, location, createdAt, updatedAt];
}
