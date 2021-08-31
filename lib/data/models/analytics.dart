import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'analytics.g.dart';

@HiveType(typeId: 3)
class Analytics extends Equatable {
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
  Analytics({
    this.analyticsId,
    this.songId,
    this.userId,
    this.duration,
    this.listenedAt,
    this.location,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
        analyticsId: json["analytics_id"],
        songId: json["song_id"],
        userId: json["user_id"],
        duration: json["duration"],
        listenedAt: json['listened_at'] != null ? DateTime.parse(json["listened_at"]) : DateTime.now(),
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        // "analytics_id": analyticsId ?? '',
        "song_id": songId ?? '',
        // "user_id": userId ?? '',
        "duration": duration ?? 0,
        // "listened_at": DateTime.now(),
        // "location": location ?? '',
      };

  @override
  List<Object> get props => [
        analyticsId,
        songId,
        userId,
        duration,
        listenedAt,
        location,
      ];
}

