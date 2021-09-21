import 'package:equatable/equatable.dart';

class ArtistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadArtists extends ArtistEvent {
  @override
  List<Object> get props => [];
}

class LikeArtist extends ArtistEvent {
  final String artistId;

  LikeArtist({this.artistId});
  @override
  List<Object> get props => [artistId];
}

class LoadInitArtists extends ArtistEvent {
  @override
  List<Object> get props => [];
}
