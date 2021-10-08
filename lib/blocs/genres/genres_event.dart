import 'package:equatable/equatable.dart';

abstract class GenresEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGenres extends GenresEvent{}
