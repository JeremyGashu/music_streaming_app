//playlist loading error

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/track.dart';

class TrackState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends TrackState {
  @override
  List<Object> get props => [];
}

class LoadingTrack extends TrackState {
  @override
  List<Object> get props => [];
}

class LoadedTrack extends TrackState {
  final Track track;
  LoadedTrack({@required this.track}) : assert(track != null);
  @override
  List<Object> get props => [track];
}

class LoadingTrackError extends TrackState {
  final String message;
  LoadingTrackError({@required this.message});
  @override
  List<Object> get props => [message];
}
