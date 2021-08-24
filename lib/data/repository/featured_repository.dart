import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/featured_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';

class FeaturedRepository {
  final FeaturedDataProvider dataProvider;
  FeaturedRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<TracksResponse> getFeaturedAlbums({int page}) async {
    http.Response featuredAlbums =
        await dataProvider.getFeaturedAlbums(page: page);
    print('featuredAlbums loaded = > ${featuredAlbums.body}');
    var decodedPlaylists = jsonDecode(featuredAlbums.body);
    print(
        'decoded featuredAlbums => ${TracksResponse.fromJson(decodedPlaylists)}');
    return TracksResponse.fromJson(decodedPlaylists);
  }
}
