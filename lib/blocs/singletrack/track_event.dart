//load playlist
import 'package:equatable/equatable.dart';

class TrackEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTracks extends TrackEvent {
  @override
  List<Object> get props => [];
}

class LoadTracksInit extends TrackEvent {
  @override
  List<Object> get props => [];
}

class LoadSongsByArtistId extends TrackEvent {
  final String artistId;
  LoadSongsByArtistId({this.artistId});
  @override
  List<Object> get props => [artistId];
}
