import 'package:equatable/equatable.dart';

abstract class UserDownloadState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserDownloadInitial extends UserDownloadState{}

class DownloadFailed extends UserDownloadState{
}

class DownloadDeleted extends UserDownloadState{
}