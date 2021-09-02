import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_event.dart';
import 'package:streaming_mobile/blocs/playlist/playlist_state.dart';
import 'package:streaming_mobile/data/repository/playlist_repository.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  int page = 1;
  int privatePage = 1;
  bool isLoading = false;
  final PlaylistRepository playlistRepository;
  PlaylistBloc({@required this.playlistRepository}) : super(InitialState());

  @override
  Stream<PlaylistState> mapEventToState(PlaylistEvent event) async* {
    yield InitialState();
    if (event is LoadPlaylists) {
      try {
        yield LoadingPlaylist();
        var playlistResponse =
            await playlistRepository.getPlaylists(page: page);
        if (page > playlistResponse.data.metaData.pageCount) {
          yield LoadedPlaylist(playlists: []);
        } else {
          yield LoadedPlaylist(playlists: playlistResponse.data.data);
          print('page before increment => ${page}');
          page++;
          print('page after increment => ${page}');
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingPlaylistError(message: "Error on loading playlists");
        throw Exception(e);
      }
    } else if (event is LoadPlaylistsInit) {
      try {
        yield LoadingPlaylist();
        var playlists = await playlistRepository.getPlaylists(page: 1);

        yield LoadedPlaylist(playlists: playlists.data.data);
        page = 1;
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingPlaylistError(message: "Error on loading playlists");
        throw Exception(e);
      }
    } else if (event is AddSongsToPrivatePlaylists) {
      yield LoadingState();

      try {
        bool added = await playlistRepository.addMusicToPrivatePlaylist(
            playlistId: event.playlistId, songId: event.songId);
        if (added) {
          yield SuccessState();
        } else {
          yield ErrorState(
              message:
                  'Error on Adding Music to your playlist. Please Try Again!');
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield ErrorState(message: "Error on loading playlists");
        throw Exception(e);
      }
    } else if (event is CreatePrivatePlaylist) {
      yield LoadingState();

      try {
        bool created = await playlistRepository.createPlaylist(
          title: event.title,
        );
        if (created) {
          yield SuccessState();
        } else {
          yield ErrorState(
              message: 'Error on creating playlist! Please Try Again!');
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield ErrorState(
            message: "Error on creating playlist! Please Try Again!");
        throw Exception(e);
      }
    } else if (event is GetPrivatePlaylists) {
      try {
        yield LoadingState();
        var playlistResponse =
            await playlistRepository.getPrivatePlaylists(page: privatePage);
        if (privatePage > playlistResponse.data.metaData.pageCount) {
          yield LoadedPlaylist(playlists: []);
        } else {
          yield LoadedPlaylist(playlists: playlistResponse.data.data);
          print('page before increment => ${privatePage}');
          privatePage++;
          print('page after increment => ${privatePage}');
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingPlaylistError(message: "Error on loading playlists");
        throw Exception(e);
      }
    }
  }
}
