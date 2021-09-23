import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';


class PlaylistDataProvider {
  final http.Client client;

  PlaylistDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getPlaylists({int page}) async {
    page ??= 1;

    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    String url =
        '$BASE_URL/playlists?page=${page}&per_page=20';
    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> createPlaylist({String title}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    String url = '$BASE_URL/playlists';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('user_id');

    http.Response response = await http.post(Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'created_by': userId,
          'type': 'private',
        }));

    return response;
  }

  Future<http.Response> getPrivatePlaylists({int page}) async {
    page ??= 1;

    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString('user_id');

    print('private playlist id => ${userId}');

    // String testId = '326a36ce-d250-40de-b9bc-feadff479f02';

    


    String url =
        '$BASE_URL/playlists?page=${page}&per_page=20&search_by=user_id&search_key=${userId}';
        print('private url => $url');
        print('private playlist url => ${userId}');
    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> addMusicToPrivatePlaylist(
      {String playlistId, String songId}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json',
    };

    http.Response response = await client.post(
      Uri.parse(POST_PLAYLIST_URL),
      headers: headers,
      body: jsonEncode({
        'playlist_id': playlistId,
        'song_id': songId,
      }),
    );
    return response;
  }
}
