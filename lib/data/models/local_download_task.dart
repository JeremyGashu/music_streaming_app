import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

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
  int duration;
  @HiveField(5)
  double progress = 0;

  LocalDownloadTask({@required this.songId,@required this.title,@required this.coverImageUrl,@required this.songUrl,
  @required this.duration,this.progress = 0});
}