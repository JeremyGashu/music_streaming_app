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
  var decodedPlaylists;
  PlaylistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<PlaylistsResponse> getPlaylists({int page}) async {
    page ??= 1;
    var playlistBox = await Hive.openBox('playlists');

    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      playlists = await dataProvider.getPlaylists(page: page);
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

      decodedPlaylists = jsonDecode(playlistCache);
    }
    return PlaylistsResponse.fromJson(decodedPlaylists);
  }

  ///Adds music to previoisly created playlist
  Future<bool> addMusicToPrivatePlaylist(
      {String playlistId, String songId}) async {
    http.Response response = await dataProvider.addMusicToPrivatePlaylist(
      playlistId: playlistId,
      songId: songId,
    );

    Map<String, dynamic> decodedResponse = jsonDecode(response.body) as Map;
    return decodedResponse['success'];
  }

  ///Creates Playlist, with the title provided.
  Future<bool> createPlaylist({String title}) async {
    http.Response response = await dataProvider.createPlaylist(
      title: title,
    );

    Map<String, dynamic> decodedResponse = jsonDecode(response.body) as Map;
    return decodedResponse['success'];
  }

  ///Gets private playlists a specific user has created
  Future<PlaylistsResponse> getPrivatePlaylists({int page}) async {
    http.Response playlistResponse =
        await dataProvider.getPrivatePlaylists(page: page);
    print('private playlist loaded = > ${playlistResponse.body}');
    var decodedPlaylists = jsonDecode(playlistResponse.body);
    print('decoded private playlists => $decodedPlaylists');
    return PlaylistsResponse.fromJson(decodedPlaylists);
  }
}
