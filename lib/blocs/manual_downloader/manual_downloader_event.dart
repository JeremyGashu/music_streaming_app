import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/data/models/download_task.dart';

abstract class ManualMediaDownloaderEvent extends Equatable{}

class AddDownload extends ManualMediaDownloaderEvent{
  final List<DownloadTask> downloadTasks;
  AddDownload({@required this.downloadTasks}):assert(downloadTasks!=null);
  @override
  List<Object> get props => [downloadTasks];
}

class RetryDownload extends ManualMediaDownloaderEvent{
  @override
  List<Object> get props => [];
}

class DownloadFinished extends ManualMediaDownloaderEvent {
  //when this event is fired update the UI from the foreground
  //check if all files are downloaded
  final String songId;

  DownloadFinished({this.songId});
  
  @override
  List<Object> get props => [songId];
}

class DownloadFailed extends ManualMediaDownloaderEvent {
  //when this event is fired clear the downloaded medias and clear the database info, when the downloaded event is triggered restart the download from 0
  final String songId;

  DownloadFailed({this.songId});
  
  @override
  List<Object> get props => [songId];
}

class ClearDownload extends ManualMediaDownloaderEvent{
  @override
  List<Object> get props => [];
}
