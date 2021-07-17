import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchingState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchFinished extends SearchState {
  //TODO: make the search data type and change the dynamic DT to SearchResult data type
  final dynamic result;

  SearchFinished({this.result});
  @override
  List<Object> get props => [result];
}

class SearchError extends SearchState {
  final String message;

  SearchError({this.message});
  @override
  List<Object> get props => [message];
}
