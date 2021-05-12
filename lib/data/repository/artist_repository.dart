import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/artist_dataprovider.dart';
import 'package:streaming_mobile/data/models/artist.dart';

class ArtistRepository {
  final ArtistDataProvider dataProvider;

  ArtistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<List<Artist>> getAllArtists(
      {int page, int perPage, String sort, String sortKey}) async {
    page ??= 0;
    perPage ??= 10;
    sort ??= 'ASC';
    sortKey ??= 'first_name';
    http.Response artists = await dataProvider.getAllArtists(
        page: page, perPage: perPage, sort: sort, sortKey: sortKey);
    var decodedArtists = jsonDecode(artists.body)['data']['data'] as List;
    return decodedArtists.map((artist) => Artist.fromJson(artist)).toList();
  }
}
