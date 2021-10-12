import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_event.dart';
import 'package:streaming_mobile/blocs/liked_albums/liked_albums_state.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/repository/liked_albums_repository.dart';

class LikedAlbumBloc extends Bloc<LikedAlbumsEvent, LikedAlbumsState> {
  int page = 1;
  bool isLoading = false;
  final LikedAlbumsRepository albumRepo;
  LikedAlbumBloc({@required this.albumRepo}) : super(InitialState());

  @override
  Stream<LikedAlbumsState> mapEventToState(LikedAlbumsEvent event) async* {
    yield InitialState();
    if (event is LoadLikedAlbums) {
      try {
        yield LoadingState();
        var tracksResponse = await albumRepo.getLikedAlbums(page: page);
        if (page > tracksResponse.data.metaData.pageCount) {
          yield LoadedLikedAlbums(albums: []);
        } else {
          List<Album> tracks = tracksResponse.data.data;
          yield LoadedLikedAlbums(albums: tracks);
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
