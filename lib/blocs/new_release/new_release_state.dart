import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/new_release.dart';

class NewReleaseState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends NewReleaseState {
  @override
  List<Object> get props => [];
}

class LoadingNewReleases extends NewReleaseState {
  @override
  List<Object> get props => [];
}

class LoadedNewReleases extends NewReleaseState {
  final NewRelease newRelease;
  LoadedNewReleases({@required this.newRelease}) : assert(newRelease != null);
  @override
  List<Object> get props => [newRelease];
}

class LoadingNewReleasesError extends NewReleaseState {
  final String message;
  LoadingNewReleasesError({@required this.message});
  @override
  List<Object> get props => [message];
}
