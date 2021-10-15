import 'package:equatable/equatable.dart';

class CacheState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends CacheState {}

class LoadingState extends CacheState {}

class SuccessfulState extends CacheState {
    final String message;

  SuccessfulState({this.message});
  @override
  List<Object> get props => [message];
}

class ErrorState extends CacheState {
  final String message;

  ErrorState({this.message});
  @override
  List<Object> get props => [message];
}
