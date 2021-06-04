import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

String defaultPlaylistStringValue = '''
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

class PlaylistRepository {
  final PlaylistDataProvider dataProvider;
  http.Response playlists;
  List decodedPlaylists;
  PlaylistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<List<Playlist>> getPlaylists() async {
    var playlistBox = await Hive.openBox('playlists');

    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      playlists = await dataProvider.getPlaylists();
      var decoded = jsonDecode(playlists.body);
      if (decoded['success']) {
        print('getPlaylists: online and saving data ' + playlists.body);
        print('getPlaylists: CLEARING DATA BEFORE WRITING: ');
        await playlistBox.clear();
        print('getPlaylists: WRITING DATA: ');
        await playlistBox.add(playlists.body);
        decodedPlaylists = jsonDecode(playlists.body)['data']['data'] as List;
      } else {
        print(
            'getPlaylists: but can\'t save the data as it have errors in loading so I am returning the old valid cache ' +
                playlists.body);
        String playlistCache =
            playlistBox.get(0, defaultValue: defaultPlaylistStringValue);

        decodedPlaylists = jsonDecode(playlistCache)['data']['data'] as List;
      }
    } else {
      String playlistCache =
          playlistBox.get(0, defaultValue: defaultPlaylistStringValue);
      print('getPlaylists: offline and retrieving data... ' + playlistCache);

      decodedPlaylists = jsonDecode(playlistCache)['data']['data'] as List;
    }
    return decodedPlaylists
        .map((playlist) => Playlist.fromJson(playlist))
        .toList();
  }
}
