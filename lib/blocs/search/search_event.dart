import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String searchKey;
  final String searchBy;
  final SearchIn searchIn;

  Search({this.searchBy, this.searchKey, this.searchIn = SearchIn.SONGS});
  @override
  List<Object> get props => [searchKey, searchBy, searchIn];
}

class ExitSearch extends SearchEvent {
  @override
  List<Object> get props => [];
}

enum SearchIn { ARTISTS, SONGS, ALBUMS, PLAYLISTS }
