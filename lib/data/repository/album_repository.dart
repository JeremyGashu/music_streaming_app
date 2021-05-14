import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/album_dataprovider.dart';
import 'package:streaming_mobile/data/models/album.dart';

class AlbumRepository {
  final AlbumDataProvider dataProvider;
  AlbumRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<List<Album>> getAllAlbums(
      {int page, int perPage, String sort, String sortKey}) async {
    page ??= 0;
    perPage ??= 10;
    sort ??= 'ASC';
    sortKey ??= 'title';
    http.Response albums = await dataProvider.getAllAlbums(
        page: page, perPage: perPage, sort: sort, sortKey: sortKey);

    var decodedPlaylists = jsonDecode(albums.body)['data']['data'] as List;
    return decodedPlaylists.map((album) => Album.fromJson(album)).toList();
  }

  Future<Album> getAlbumById(String albumId) async {
    http.Response album = await dataProvider.getAlbumById(albumId);
    var decodedAlbum = jsonDecode(album.body)['data']['data'];
    return Album.fromJson(decodedAlbum);
  }

  Future<List<Album>> getAlbumByArtist(String artistId, int page,
      {int perPage, String sort, String sortKey}) async {
    perPage ??= 10;
    sort ??= 'ASC';
    sortKey ??= 'title';
    http.Response albums = await dataProvider.getAlbumsByArtist(artistId, page,
        perPage: perPage, sortKey: sortKey, sort: sort);
    var decodedAlbum = jsonDecode(albums.body)['data']['data'] as List;
    return decodedAlbum.map((album) => Album.fromJson(album)).toList();
  }
}
