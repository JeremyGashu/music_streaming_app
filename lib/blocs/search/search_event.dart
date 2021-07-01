import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String searchParam;

  Search({this.searchParam});
  @override
  List<Object> get props => [searchParam];
}
