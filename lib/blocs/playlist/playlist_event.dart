import 'package:equatable/equatable.dart';

class PlaylistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPlaylists extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

class CreatePrivatePlaylist extends PlaylistEvent {
  final String title;

  CreatePrivatePlaylist({this.title});
  @override
  List<Object> get props => [title];
}

class GetPrivatePlaylists extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

class LoadPrivatePlaylistsInit extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

class AddSongsToPrivatePlaylists extends PlaylistEvent {
  final String playlistId;
  final String songId;

  AddSongsToPrivatePlaylists({this.playlistId, this.songId});
  @override
  List<Object> get props => [playlistId, songId];
}

class LoadPlaylistsInit extends PlaylistEvent {
  @override
  List<Object> get props => [];
}
