import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';

class TrackRepository {
  final TrackDataProvider dataProvider;
  TrackRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<TracksResponse> getTracks() async {
    http.Response playlists = await dataProvider.getTracks();
    print('tracks loaded = > ${playlists.body}');
    var decodedPlaylists = jsonDecode(playlists.body);
    print('decoded track => ${decodedPlaylists}');
    return TracksResponse.fromJson(decodedPlaylists);
  }

  Future<TracksResponse> getTracksByArtisId({String artistId}) async {
    http.Response songs =
        await dataProvider.getTracksByArtisId(artistId: artistId);
    print('songs loaded by artist= > ${songs.body}');
    var decodedSongs = jsonDecode(songs.body);
    print('decoded songs => ${decodedSongs}');
    return TracksResponse.fromJson(decodedSongs);
  }
}
