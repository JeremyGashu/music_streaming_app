import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'download_task.g.dart';

enum DownloadType {
  image,
  media,
  key,
  manifest
}

@HiveType(typeId : 1)
class DownloadTask extends Equatable{
  @HiveField(0)
  final String track_id;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final String download_path;
  @HiveField(3)
  final int segment_number; // set segment number to -1 if downloadType is different from media
  @HiveField(4)
  final bool downloaded;
  @HiveField(5)
  final DownloadType downloadType;

  DownloadTask({this.track_id, this.url, this.download_path, this.segment_number, this.downloadType, this.downloaded});

  @override
  List<Object> get props => [url, download_path, segment_number, downloaded, downloadType];
}