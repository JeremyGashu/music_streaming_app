import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/data/models/download_task.dart';

abstract class MediaDownloaderState extends Equatable{

}

class DownloadStarted extends MediaDownloaderState{
  @override
  List<Object> get props => [];
}

class DownloadCompleted extends MediaDownloaderState{
  final DownloadTask downloadedTask;
  DownloadCompleted({@required this.downloadedTask}):assert(downloadedTask != null);
  @override
  List<Object> get props => [downloadedTask];
}

class DownloadOnProgressState extends MediaDownloaderState{
  @override
  List<Object> get props => [];
}

class DownloadFailed extends MediaDownloaderState{
  @override
  List<Object> get props => [];
}

class DownloadDone extends MediaDownloaderState{
  @override
  List<Object> get props => [];
}