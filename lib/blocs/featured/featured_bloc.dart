import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/featured/featured_event.dart';
import 'package:streaming_mobile/blocs/featured/featured_state.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/repository/featured_repository.dart';

class FeaturedAlbumBloc extends Bloc<FeaturedAlbumEvent, FeaturedAlbumState> {
  int page = 1;
  bool isLoading = false;
  final FeaturedAlbumRepository featuredAlbumRepo;
  FeaturedAlbumBloc({@required this.featuredAlbumRepo}) : super(InitialState());

  @override
  Stream<FeaturedAlbumState> mapEventToState(FeaturedAlbumEvent event) async* {
    yield InitialState();
    if (event is LoadFeaturedAlbums) {
      try {
        yield LoadingFeaturedAlbum();
        var featuredAlbumResponse =
            await featuredAlbumRepo.getFeaturedAlbums(page: page);
        if (page > featuredAlbumResponse.data.metaData.pageCount) {
          yield LoadedFeaturedAlbum(albums: []);
        } else {
          List<Album> albums = featuredAlbumResponse.data.data
              .map((albumInfo) => albumInfo.album)
              .toList();

          yield LoadedFeaturedAlbum(albums: albums);
          page++;
        }
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingFeaturedAlbumError(
            message: "Error one loading featured album!");
        throw Exception(e);
      }
    } else if (event is LoadFeaturedAlbumsInit) {
      try {
        yield LoadingFeaturedAlbum();
        var featuredAlbumResponse =
            await featuredAlbumRepo.getFeaturedAlbums(page: 1);
        List<Album> albums = featuredAlbumResponse.data.data
            .map((albumInfo) => albumInfo.album)
            .toList();

        yield LoadedFeaturedAlbum(albums: albums);
        page = 1;
      } catch (e) {
        print("ERROR ON BLOC " + e.toString());
        yield LoadingFeaturedAlbumError(
            message: "Error one loading featured album!");
        throw Exception(e);
      }
    }
  }
}
