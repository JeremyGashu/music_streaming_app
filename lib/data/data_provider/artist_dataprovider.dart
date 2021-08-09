import 'dart:async';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

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

  Future<http.Response> getAllArtists({int page}) async {
    page ??= 1;
    String url =
        '$BASE_URL/artists?page=${page}&per_page=10&sort=ASC&sort_key=first_name';
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    http.Response response = await client.get(Uri.parse(url), headers: headers);
    return response;
  }

  Future<http.Response> getArtistById(String artistId) async {
    String url = '$BASE_URL/artists/${artistId}';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }
}
