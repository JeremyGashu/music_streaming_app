import 'package:equatable/equatable.dart';

abstract class UserDownloadState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserDownloadInitial extends UserDownloadState{}

class DownloadFailed extends UserDownloadState{
  final String message;
  final String id;
  DownloadFailed(this.message, this.id);
    @override
  List<Object> get props => [message, id];
}

class LoadingState extends UserDownloadState{
}

class DownloadDeleted extends UserDownloadState{
}