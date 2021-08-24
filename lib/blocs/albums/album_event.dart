import 'package:equatable/equatable.dart';

class AlbumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAlbums extends AlbumEvent {
  @override
  List<Object> get props => [];
}

class LoadInitAlbums extends AlbumEvent {
  @override
  List<Object> get props => [];
}

class LoadAlbumsByArtistId extends AlbumEvent {
  final String artistId;
  LoadAlbumsByArtistId({this.artistId});
  @override
  List<Object> get props => [artistId];
}
