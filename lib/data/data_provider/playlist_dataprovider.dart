import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

final String testUserId = '326a36ce-d250-40de-b9bc-feadff479f02';
final String testPlaylistId = '56d65801-1557-4440-b647-06f431d331e1';
final String testSongId = '661f44e0-11e5-4631-a15c-3a17560c0519';

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
        '$BASE_URL/playlists?page=${page}&per_page=10';
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

    http.Response response = await http.post(Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'created_by': testUserId,
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

    String url =
        '$BASE_URL/playlists?page=${page}&per_page=10&search_by=user_id&search_key=${authData.userId}';
        print('private playlist url => ${authData.userId}');
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
        'playlist_id': testPlaylistId,
        'song_id': songId,
      }),
    );
    return response;
  }
}
