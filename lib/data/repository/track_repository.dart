import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';

class TrackRepository {
  final TrackDataProvider dataProvider;
  TrackRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<TracksResponse> getTracks({int page}) async {
    page ??= 1;
    http.Response response = await dataProvider.getTracks(page: page);
    print('tracks loaded = > ${response.body}');
    var decodedTracks = jsonDecode(response.body);
    return TracksResponse.fromJson(decodedTracks);
  }

  Future<TracksResponse> getTracksByArtisId({String artistId}) async {
    http.Response songs =
        await dataProvider.getTracksByArtisId(artistId: artistId);
    print('songs loaded by artist= > ${songs.body}');
    var decodedSongs = jsonDecode(songs.body);
    print('decoded songs => ${decodedSongs}');
    return TracksResponse.fromJson(decodedSongs);
  }

    Future<TracksResponse> getTracksByGenre({String genreId, int page}) async {
    page ??= 1;
    
    http.Response response = await dataProvider.getTracksByGenre(genreId: genreId, page: page);
    print('tracks loaded = > ${response.body}');
    var decodedTracks = jsonDecode(response.body);
    return TracksResponse.fromJson(decodedTracks);
  }
}
