import 'package:equatable/equatable.dart';

abstract class UserDownloadState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserDownloadInitial extends UserDownloadState{}

class DownloadFailed extends UserDownloadState{
  final String message;

  DownloadFailed(this.message);
    @override
  List<Object> get props => [message];
}

class DownloadDeleted extends UserDownloadState{
}