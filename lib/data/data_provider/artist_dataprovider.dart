import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

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

  Future<http.Response> likeArtist({String artistId}) async {
    String url =
        '$BASE_URL/like/artist';
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    http.Response response = await client.post(Uri.parse(url), headers: headers, body: jsonEncode({'artist_id' : artistId}));
    print('like status => ${response.statusCode}');
    return response;
  }

  Future<http.Response> getArtistById(String artistId) async {
    String url = '$BASE_URL/artists/${artistId}';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }
}
