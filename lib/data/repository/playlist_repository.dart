import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

class PlaylistRepository {
  final PlaylistDataProvider dataProvider;
  PlaylistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<List<Playlist>> getPlaylists() async {
    http.Response playlists = await dataProvider.getPlaylists();
    var decodedPlaylists = jsonDecode(playlists.body)['data']['data'] as List;

    print("loaded playlists: " + decodedPlaylists.toString());

    return decodedPlaylists
        .map((playlist) => Playlist.fromJson(playlist))
        .toList();
  }
}
