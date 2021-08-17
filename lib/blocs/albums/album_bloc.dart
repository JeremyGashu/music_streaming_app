import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/data/repository/album_repository.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  int page = 1;
  bool isLoading = false;
  final AlbumRepository albumRepository;
  AlbumBloc({@required this.albumRepository}) : super(InitialState());

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent event) async* {
    yield InitialState();
    if (event is LoadAlbums) {
      try {
        yield LoadingAlbum();
        var albumsResponse = await albumRepository.getAllAlbums(page: page);

        yield LoadedAlbum(albums: albumsResponse.data.data);
        print('page before increment => ${page}');
        page++;
        print('page after increment => ${page}');
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingAlbumError(message: "Error on loading Album");
        throw Exception(e);
      }
    } else if (event is LoadInitAlbums) {
      try {
        yield LoadingAlbum();
        page = 1;
        var albumsResponse = await albumRepository.getAllAlbums(page: 1);

        yield LoadedAlbum(albums: albumsResponse.data.data);
        print('page => ${page}');
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingAlbumError(message: "Error on loading Album");
        throw Exception(e);
      }
    } else if (event is LoadAlbumsByArtistId) {
      try {
        yield LoadingAlbum();
        var albumsResponse =
            await albumRepository.getAlbumsByArtistId(artistId: event.artistId);
        yield LoadedAlbum(albums: albumsResponse.data.data);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingAlbumError(message: "Error on loading Album");
        throw Exception(e);
      }
    }
  }
}
