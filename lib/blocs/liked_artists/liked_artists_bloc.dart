import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/liked_artists/liked_artists_event.dart';
import 'package:streaming_mobile/blocs/liked_artists/liked_artists_state.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/data/repository/liked_artists_repository.dart';

class LikedArtistsBloc extends Bloc<LikedArtistsEvent, LikedArtistsState> {
  int page = 1;
  bool isLoading = false;
  final LikedArtistsRepository artistsRepository;
  LikedArtistsBloc({@required this.artistsRepository}) : super(InitialState());

  @override
  Stream<LikedArtistsState> mapEventToState(LikedArtistsEvent event) async* {
    yield InitialState();
    if (event is LoadLikedArtists) {
      try {
        yield LoadingState();
        var tracksResponse = await artistsRepository.getLikedArtists(page: page);
        if (page > tracksResponse.data.metaData.pageCount) {
          yield LoadedLikedArtists(artists: []);
        } else {
          List<ArtistModel> tracks = tracksResponse.data.data;
          yield LoadedLikedArtists(artists: tracks);
          page++;
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield ErrorState(message: "Error on loading liked artists!");
        // throw Exception(e);
      }
    }
  }
}
