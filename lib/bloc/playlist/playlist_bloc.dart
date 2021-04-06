import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/bloc/playlist/playlist_event.dart';
import 'package:streaming_mobile/bloc/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository playlistRepository;
  PlaylistBloc({@required this.playlistRepository}) : super(InitialState());

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    yield InitialState();
    if (event is LoadPlaylists) {
      try {
        yield LoadingPlaylist();
        await Future.delayed(Duration(seconds: 5));
        var playlists = await playlistRepository.getPlaylists();

        yield LoadedPlaylist(playlists: playlists);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingPlaylistError(message: "Error one loading playlists");
      }
    }
  }
}
