import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/artist_dataprovider.dart';
import 'package:streaming_mobile/data/models/artist.dart';

String defaultArtistsString = '''
{
    "success": true,
    "data": {
        "meta_data": {
            "page": 1,
            "per_page": 10,
            "page_count": 1,
            "total_count": 1,
            "links": [
                {
                    "self": "/v1/albums/?page=1&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "first": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "previous": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "next": "/v1/albums/?page=0&per_page=10&sort=ASC&sort_key=title"
                },
                {
                    "last": "/v1/albums/?page=1&per_page=10&sort=ASC&sort_key=title"
                }
            ]
        },
        "data": []
    }
}
''';

class ArtistRepository {
  final ArtistDataProvider dataProvider;
  http.Response artists;
  var decodedArtists;

  ArtistRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<ArtistsResponse> getAllArtists({int page}) async {
    page ??= 1;

    var artistsBox = await Hive.openBox('artists');
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      artists = await dataProvider.getAllArtists(page: page);

      var decoded = jsonDecode(artists.body);
      if (decoded['success']) {
        print('getArtists: online and saving data ' + artists.body);
        print('getArtists: CLEARING DATA BEFORE WRITING');
        await artistsBox.clear();
        print('getArtists: WRITING DATA: ');
        await artistsBox.add(artists.body);
        decodedArtists = jsonDecode(artists.body);
      } else {
        print(
            'getArtists: but can\'t save the data as it have errors in loading so I am returning the old valid cache' +
                artists.body);
        String artistCache =
            artistsBox.get(0, defaultValue: defaultArtistsString);
        print('getArtists: offline and retrieving data... ' + artistCache);

        decodedArtists = jsonDecode(artistCache);
      }
    } else {
      //TODO change default artist string
      //TODO: if there is no network and there is no data in the cache show error message in the UI
      String artistsCache =
          artistsBox.get(0, defaultValue: defaultArtistsString);
      decodedArtists = jsonDecode(artistsCache);
    }

    return ArtistsResponse.fromJson(decodedArtists);
  }
}
