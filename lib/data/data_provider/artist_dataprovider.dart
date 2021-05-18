import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';

var testData = '''
{
  "_metadata": {
    "page": 5,
    "per_page": 20,
    "page_count": 20,
    "total_count": 521,
    "Links": [
      {
        "self": "/songs?page=5&per_page=20",
        "first": "/songs?page=0&per_page=20",
        "previous": "/songs?page=4&per_page=20",
        "next": "/songs?page=6&per_page=20",
        "last": "/songs?page=26&per_page=20"
      }
    ]
  },
  "data": {
    "id": "id",
    "title": "title",
    "description": "description",
    "created_by": "created_by",
    "created_at": "created_at",
    "cover_img": "cover_img",
    "views": 123,
    "track_count": 12,
    "type": "type",
    "likes": 123
  },
  "success": true,
  "status": 200
}
''';

class ArtistDataProvider {
  final http.Client client;

  ArtistDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getAllArtists(
      {int page, int perPage, String sort, String sortKey}) async {
    page ??= 0;
    perPage ??= 10;
    sort ??= 'ASC';
    sortKey ??= 'first_name';
    String url =
        '$BASE_URL/albums?page=${page}&per_page=${perPage}&sort=${sort}&sort_key=${sortKey}';
    print('URL: ' + url);
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getArtistById(String artistId) async {
    String url = '$BASE_URL/artists/${artistId}';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }
}
