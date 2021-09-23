import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends LikeState {}

class LoadingState extends LikeState {}

class SuccessState extends LikeState {
  final bool status;

  SuccessState({this.status});
  @override
  List<Object> get props => [status];
}

class ErrorState extends LikeState {
  final String message;

  ErrorState({this.message});
  @override
  List<Object> get props => [message];
}
