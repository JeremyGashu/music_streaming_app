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
            "total_count": 1,
            "links": [
                {
                    "self": "/v1/albums/?page=1&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "first": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "previous": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "next": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "last": "/v1/albums/?page=1&per_page=10&sort=ASC&sort_key=title"
                }
            ]
        },
        "data": []
    }
}
''';

class AlbumRepository {
  final AlbumDataProvider dataProvider;
  http.Response albums;
  var decodeAlbums;
  AlbumRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<AlbumsResponse> getAllAlbums({int page}) async {
    page ??= 1;

    var albumBox = await Hive.openBox('albums');
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      albums = await dataProvider.getAllAlbums(page: page);

      var decoded = jsonDecode(albums.body);
      if (decoded['success']) {
        print('getAlbums: online and saving data ' + albums.body);
        print('getAlbums: CLEARING DATA BEFORE WRITING');
        await albumBox.clear();
        print('getAlbums: WRITING DATA: ');
        await albumBox.add(albums.body);
        decodeAlbums = jsonDecode(albums.body);
      } else {
        print(
            'getAlbums: but can\'t save the data as it have errors in loading so I am returning the old valid cache' +
                albums.body);
        String albumCache = albumBox.get(0, defaultValue: defaultAlbumString);
        print('getAlbums: offline and retrieving data... ' + albumCache);

        decodeAlbums = jsonDecode(albumCache);
      }
    } else {
      String albumCache = albumBox.get(0, defaultValue: defaultAlbumString);
      decodeAlbums = jsonDecode(albumCache);
    }

    return AlbumsResponse.fromJson(decodeAlbums);
  }

  Future<AlbumsResponse> getAlbumsByArtistId({String artistId}) async {
    http.Response albums =
        await dataProvider.getAlbumByArtistId(artistId: artistId);
    print('albums loaded by artist= > ${albums.body}');
    var decodedAlbums = jsonDecode(albums.body);
    print('decoded albums => ${decodedAlbums}');
    return AlbumsResponse.fromJson(decodedAlbums);
  }
}
