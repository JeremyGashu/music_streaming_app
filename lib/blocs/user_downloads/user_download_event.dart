import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/data/models/track.dart';

abstract class UserDownloadEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartDownload extends UserDownloadEvent {
  final Track track;
  StartDownload({@required this.track});

  @override
  List<Object> get props => [track];
}

class UserRetryDownload extends UserDownloadEvent {
  final Track track;
  UserRetryDownload({@required this.track});

  @override
  List<Object> get props => [track];
}

class DeleteFailedDownload extends UserDownloadEvent {
  final Track track;
  DeleteFailedDownload({@required this.track});

  @override
  List<Object> get props => [track];
}

class Init extends UserDownloadEvent {}

class DeleteDownload extends UserDownloadEvent {
  final String trackId;
  DeleteDownload({@required this.trackId}):assert(trackId!=null);

}