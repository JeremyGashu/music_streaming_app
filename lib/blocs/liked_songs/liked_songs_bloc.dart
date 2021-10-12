import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_event.dart';
import 'package:streaming_mobile/blocs/liked_songs/liked_songs_state.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/data/repository/liked_songs_repository.dart';

class LikedSongsBloc extends Bloc<LikedSongsEvent, LikedSongsState> {
  int page = 1;
  bool isLoading = false;
  final LikedSongsRepository trackRepository;
  LikedSongsBloc({@required this.trackRepository}) : super(InitialState());

  @override
  Stream<LikedSongsState> mapEventToState(LikedSongsEvent event) async* {
    yield InitialState();
    if (event is LoadedLikedSongs) {
      try {
        yield LoadingState();
        var tracksResponse = await trackRepository.getLikedSongs(page: page);
        if (page > tracksResponse.data.metaData.pageCount) {
          yield LoadedLikedSongs(tracks: []);
        } else {
          List<Track> tracks = tracksResponse.data.data.songs
              .map((songElement) => songElement.song)
              .toList();
          yield LoadedLikedSongs(tracks: tracks);
          page++;
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield ErrorState(message: "Error on loading liked songs!");
        // throw Exception(e);
      }
    }
  }
}
