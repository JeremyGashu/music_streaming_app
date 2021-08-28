import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/artist/artist_event.dart';
import 'package:streaming_mobile/blocs/artist/artist_state.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/data/repository/artist_repository.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  int page = 1;
  bool isLoading = false;
  final ArtistRepository artistRepository;
  ArtistBloc({@required this.artistRepository}) : super(InitialState());

  @override
  Stream<ArtistState> mapEventToState(ArtistEvent event) async* {
    yield InitialState();
    if (event is LoadArtists) {
      try {
        yield LoadingArtist();
        var artistResponse = await artistRepository.getAllArtists(page: page);
        if (page > artistResponse.data.metaData.pageCount) {
          yield LoadedArtist(artists: []);
        } else {
          yield LoadedArtist(artists: artistResponse.data.data);
          print('page before increment => ${page}');
          page++;
          print('page after increment => ${page}');
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingArtistError(message: "Error on loading Artists");
        throw Exception(e);
      }
    } else if (event is LoadInitArtists) {
      try {
        yield LoadingArtist();
        ArtistsResponse artistResponse =
            await artistRepository.getAllArtists(page: 1);

        yield LoadedArtist(artists: artistResponse.data.data);
        page = 1;
        print('page  => ${page}');
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingArtistError(message: "Error on loading Artists");
        throw Exception(e);
      }
    }
  }
}
