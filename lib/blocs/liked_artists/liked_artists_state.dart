//playlist loading error

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/artist.dart';

class LikedArtistsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends LikedArtistsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends LikedArtistsState {
  @override
  List<Object> get props => [];
}

class LoadedLikedArtists extends LikedArtistsState {
  final List<ArtistModel> artists;
  LoadedLikedArtists({@required this.artists}) : assert(artists != null);
  @override
  List<Object> get props => [artists];
}

class ErrorState extends LikedArtistsState {
  final String message;
  ErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}
