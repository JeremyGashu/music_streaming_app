import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/liked_songs_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';

class LikedSongsRepository {
  final LikedSongsDataProvider dataProvider;
  LikedSongsRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<TracksResponse> getLikedSongs({int page}) async {
    page ??= 1;
    http.Response response = await dataProvider.getLikedSongs(page: page);
    print('liked songs loaded = > ${response.body}');
    var decodedTracks = jsonDecode(response.body);
    return TracksResponse.fromJson(decodedTracks);
  }
}
