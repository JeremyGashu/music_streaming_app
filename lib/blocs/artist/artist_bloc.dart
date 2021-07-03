import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/data/repository/artist_repository.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistRepository artistRepository;
  ArtistBloc({@required this.artistRepository}) : super(InitialState());

  @override
  Stream<ArtistState> mapEventToState(ArtistEvent event) async* {
    yield InitialState();
    if (event is LoadArtists) {
      try {
        yield LoadingArtist();
        var artistResponse = await artistRepository.getAllArtists();

        yield LoadedArtist(artists: artistResponse.data.data);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingArtistError(message: "Error on loading Artists");
        throw Exception(e);
      }
    }
  }
}
