import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/artist.dart';

class ArtistState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends ArtistState {
  @override
  List<Object> get props => [];
}

class LoadingArtist extends ArtistState {
  @override
  List<Object> get props => [];
}

class LoadedArtist extends ArtistState {
  final List<ArtistModel> artists;
  LoadedArtist({@required this.artists}) : assert(artists != null);
  @override
  List<Object> get props => [artists];
}

class LoadingArtistError extends ArtistState {
  final String message;
  LoadingArtistError({@required this.message});
}
