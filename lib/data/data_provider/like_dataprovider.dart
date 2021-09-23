import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class LikeDataProvider {
  final http.Client client;

  LikeDataProvider({this.client}) : assert(client != null);

  Future<http.Response> likeArtist(String id) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    String url = '$BASE_URL/like/artist';

    http.Response response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'artist_id': id}),
    );

    print('like response => ${response.body}');

    return response;
  }

  Future<http.Response> likeAlbum(String id) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    String url = '$BASE_URL/like/album';

    http.Response response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'album_id': id}),
    );

    return response;
  }

  Future<http.Response> likePlaylist(String id) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    String url = '$BASE_URL/like/playlist';

    http.Response response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'playlist_id': id}),
    );

    return response;
  }

  Future<http.Response> likeSong(String id) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    String url = '$BASE_URL/like/song';

    http.Response response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'song_id': id}),
    );
    print('like response => ${response.body}');

    return response;
  }
}
