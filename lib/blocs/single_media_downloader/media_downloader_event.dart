import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/data/models/download_task.dart';

abstract class MediaDownloaderEvent extends Equatable{}

class AddDownload extends MediaDownloaderEvent{
  final List<DownloadTask> downloadTasks;
  AddDownload({@required this.downloadTasks}):assert(downloadTasks!=null);
  @override
  List<Object> get props => [downloadTasks];
}

class RetryDownload extends MediaDownloaderEvent{
  @override
  List<Object> get props => [];
}

class UpdateDownloadState extends MediaDownloaderEvent{
  final MediaDownloaderState state;
  UpdateDownloadState({@required this.state}):assert(state!=null);
  @override
  List<Object> get props => [state];
}

class InitializeDownloader extends MediaDownloaderEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ClearDownload extends MediaDownloaderEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
