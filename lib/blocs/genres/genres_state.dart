import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:streaming_mobile/data/models/genre.dart';

abstract class GenresState extends Equatable{
  @override
  List<Object> get props => [];
}

class GenresInitial extends GenresState{}

class GenresLoadInProgress extends GenresState{}

class GenresLoadSuccess extends GenresState {
  final List<Genre> genres;
  GenresLoadSuccess({@required this.genres}):assert(genres!=null);
}

class GenresLoadFailed extends GenresState {}