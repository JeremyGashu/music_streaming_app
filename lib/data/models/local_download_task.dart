import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/data/models/track.dart';

part 'local_download_task.g.dart';

@HiveType(typeId: 4)
class LocalDownloadTask{
  @HiveField(0)
  String songId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String coverImageUrl;
  @HiveField(3)
  String songUrl;
  @HiveField(4)
  int duration = 0;
  @HiveField(5)
  double progress = 0;
  @HiveField(6)
  final String artistFirstName;
  @HiveField(7)
  final String artistLastName;
  @HiveField(8)
  String genre = '';

  LocalDownloadTask({@required this.songId,@required this.title,@required this.coverImageUrl,@required this.songUrl,@required this.artistFirstName,@required this.artistLastName,this.genre
  ,this.duration,this.progress = 0});

  Track toTrack() {
    return Track(
      songId: this.songId,
      artist: ArtistModel(firstName: this.artistFirstName, lastName: this.artistLastName),
      coverImageUrl: this.coverImageUrl,
      genre: Genre(name: this.genre),
      title: this.title,
      duration: this.duration,

    );
  }
}