import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/liked_albums_dataprovider.dart';
import 'package:streaming_mobile/data/models/album.dart';

class LikedAlbumsRepository {
  final LikedAlbumsDataprovider dataProvider;
  LikedAlbumsRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<AlbumsResponse> getLikedAlbums({int page}) async {
    page ??= 1;
    http.Response response = await dataProvider.getLikedAlbums(page: page);
    print('liked songs loaded = > ${response.body}');
    var decodedTracks = jsonDecode(response.body);
    return AlbumsResponse.fromJson(decodedTracks);
  }
}
