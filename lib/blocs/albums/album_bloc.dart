import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/albums/album_event.dart';
import 'package:streaming_mobile/blocs/albums/album_state.dart';
import 'package:streaming_mobile/data/repository/album_repository.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;
  AlbumBloc({@required this.albumRepository}) : super(InitialState());

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent event) async* {
    yield InitialState();
    if (event is LoadAlbums) {
      try {
        yield LoadingAlbum();
        await Future.delayed(Duration(seconds: 5));
        var albumsResponse = await albumRepository.getAllAlbums();

        yield LoadedAlbum(albums: albumsResponse.data.data);
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingAlbumError(message: "Error on loading Album");
        throw Exception(e);
      }
    }
  }
}
