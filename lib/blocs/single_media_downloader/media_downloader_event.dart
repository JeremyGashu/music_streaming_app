import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/data/models/download_task.dart';

abstract class MediaDownloaderEvent extends Equatable{@override
  List<Object> get props => [];}

class AddDownload extends MediaDownloaderEvent{
  final List<DownloadTask> downloadTasks;
  AddDownload({@required this.downloadTasks}):assert(downloadTasks!=null);
  @override
  List<Object> get props => [downloadTasks];
}

class RetryDownload extends MediaDownloaderEvent{
  final String songId;

  RetryDownload({this.songId});
    @override
  List<Object> get props => [songId];
}

class UpdateDownloadState extends MediaDownloaderEvent{
  final MediaDownloaderState state;
  UpdateDownloadState({@required this.state}):assert(state!=null);
  @override
  List<Object> get props => [state];
}

class InitializeDownloader extends MediaDownloaderEvent{
}

class ClearDownload extends MediaDownloaderEvent{
}

class CancelDownload extends MediaDownloaderEvent{
  final String trackId;

  CancelDownload({this.trackId});
    @override
  List<Object> get props => [trackId];
}

class BeginDownload extends MediaDownloaderEvent{
  final List<DownloadTask> downloadTasks;
  BeginDownload({@required this.downloadTasks}):assert(downloadTasks!=null);
  @override
  List<Object> get props => [downloadTasks];
}