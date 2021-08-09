import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  int page = 1;
  bool isLoading = false;
  final PlaylistRepository playlistRepository;
  PlaylistBloc({@required this.playlistRepository}) : super(InitialState());

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    yield InitialState();
    if (event is LoadPlaylists) {
      try {
        yield LoadingPlaylist();
        var playlists = await playlistRepository.getPlaylists();

        yield LoadedPlaylist(playlists: playlists);
        print('page before increment => ${page}');
        page++;
        print('page after increment => ${page}');
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingPlaylistError(message: "Error on loading playlists");
        throw Exception(e);
      }
    }
  }
}
