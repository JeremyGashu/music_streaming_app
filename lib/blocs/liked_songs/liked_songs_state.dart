//playlist loading error

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/track.dart';

class LikedSongsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends LikedSongsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends LikedSongsState {
  @override
  List<Object> get props => [];
}

class LoadedLikedSongs extends LikedSongsState {
  final List<Track> tracks;
  LoadedLikedSongs({@required this.tracks}) : assert(tracks != null);
  @override
  List<Object> get props => [tracks];
}

class ErrorState extends LikedSongsState {
  final String message;
  ErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}
