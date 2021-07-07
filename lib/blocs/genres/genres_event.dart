import 'package:equatable/equatable.dart';

abstract class GenresEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchGenres extends GenresEvent{}
