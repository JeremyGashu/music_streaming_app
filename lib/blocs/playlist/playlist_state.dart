//playlist loading error

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

class PlaylistState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends PlaylistState {
  @override
  List<Object> get props => [];
}

class LoadingPlaylist extends PlaylistState {
  @override
  List<Object> get props => [];
}

class LoadedPlaylist extends PlaylistState {
  final Playlist playlists;
  LoadedPlaylist({@required this.playlists}) : assert(playlists != null);
  @override
  List<Object> get props => [playlists];
}

class LoadingPlaylistError extends PlaylistState {
  final String message;
  LoadingPlaylistError({@required this.message});
}
