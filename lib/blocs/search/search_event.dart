import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String searchKey;
  final SearchIn searchIn;

  Search({@required this.searchKey, this.searchIn});
  @override
  List<Object> get props => [searchKey, searchIn];
}

class SetCurrentPage extends SearchEvent {
  final SearchIn currentPage;

  SetCurrentPage({this.currentPage});
  @override
  List<Object> get props => [currentPage];
}

class SetCurrentKey extends SearchEvent {
  final Map<String, dynamic> result;
  final String currentKey;

  SetCurrentKey({this.result, this.currentKey});
  @override
  List<Object> get props => [result, currentKey];
}

class FocusInputField extends SearchEvent {
  @override
  List<Object> get props => [];
}

class ExitSearch extends SearchEvent {
  @override
  List<Object> get props => [];
}

enum SearchIn { ARTISTS, SONGS, ALBUMS, PLAYLISTS }
