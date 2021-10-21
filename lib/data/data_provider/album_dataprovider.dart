import 'dart:async';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class AlbumDataProvider {
  final http.Client client;

  AlbumDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getAllAlbums({int page}) async {
    page ??= 1;
    String url = '$BASE_ALBUM_URL?page=$page&per_page=20&sort=ASC';

    print('album endpoint $url');

    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    //todo use the correct page, perPage sort and sort key once the backend is finished
    http.Response response = await client.get(Uri.parse(url), headers: headers);

    return response;
  }

  Future<http.Response> getAlbumByArtistId({String artistId}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    http.Response response = await client.get(
      Uri.parse(ALBUM_BY_ARTIST + artistId),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> getAlbumById(String albumId) async {
    String url = '$BASE_URL/artist/albums/${albumId}';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> deleteAlbum(String albumId) async {
    String url = '$BASE_URL/artists/${albumId}';
    http.Response response = await client.get(Uri.parse(url));
    return response;
  }
}
