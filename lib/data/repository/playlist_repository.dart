import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

class PlaylistRepository {
  final PlaylistDataProvider dataProvider;
  PlaylistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<Playlist> getPlaylists() async {
    http.Response playlists = await dataProvider.getPlaylists();
    var decodedPlaylists = jsonDecode(playlists.body);
    return Playlist.fromJson(decodedPlaylists);
  }
}
