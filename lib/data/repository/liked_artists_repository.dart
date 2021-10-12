import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/liked_artists_dataprovider.dart';
import 'package:streaming_mobile/data/models/artist.dart';

class LikedArtistsRepository {
  final LikedArtistsDataProvider dataProvider;
  LikedArtistsRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<ArtistsResponse> getLikedArtists({int page}) async {
    page ??= 1;
    http.Response response = await dataProvider.getLikedArtists(page: page);
    print('liked songs loaded = > ${response.body}');
    var decodedTracks = jsonDecode(response.body);
    return ArtistsResponse.fromJson(decodedTracks);
  }
}
