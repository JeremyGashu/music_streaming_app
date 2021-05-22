import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/album_dataprovider.dart';
import 'package:streaming_mobile/data/models/album.dart';

String defaultAlbumString = '''
{
    "success": true,
    "data": {
        "meta_data": {
            "page": 1,
            "per_page": 10,
            "page_count": 1,
            "total_count": 0,
            "links": [
            ]
        },
        "data": []
    }
}
''';

class AlbumRepository {
  final AlbumDataProvider dataProvider;
  http.Response albums;
  List decodeAlbums;
  AlbumRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<List<Album>> getAllAlbums(
      {int page, int perPage, String sort, String sortKey}) async {
    page ??= 0;
    perPage ??= 10;
    sort ??= 'ASC';
    sortKey ??= 'title';

    var albumBox = await Hive.openBox('albums');
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      albums = await dataProvider.getAllAlbums(
          page: page, perPage: perPage, sort: sort, sortKey: sortKey);

      print('getAlbums: online and saving data ' + albums.body);
      print('CLEARING DATA BEFORE WRITING: ');
      await albumBox.clear();
      print('WRITING DATA: ');
      await albumBox.add(albums.body);
      decodeAlbums = jsonDecode(albums.body)['data']['data'] as List;
    } else {
      String albumCache = albumBox.get(0, defaultValue: defaultAlbumString);
      print('getAlbums: offline and retrieving data... ' + albumCache);

      decodeAlbums = jsonDecode(albumCache)['data']['data'] as List;
    }

    return decodeAlbums.map((album) => Album.fromJson(album)).toList();
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
