import 'package:equatable/equatable.dart';

class LikeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LikeSong extends LikeEvent {
  final String id;

  LikeSong({this.id});
  @override
  List<Object> get props => [id];
}

class LikePlaylist extends LikeEvent {
  final String id;

  LikePlaylist({this.id});
  @override
  List<Object> get props => [id];
}

class LikeArtist extends LikeEvent {
  final String id;

  LikeArtist({this.id});
  @override
  List<Object> get props => [id];
}

class LikeAlbum extends LikeEvent {
  final String id;

  LikeAlbum({this.id});
  @override
  List<Object> get props => [id];
}
