import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class SearchDataProvider {
  final http.Client client;

  SearchDataProvider({this.client}) : assert(client != null);

  Future<http.Response> search(
      {@required String searchKey, @required SearchIn searchIn}) async {
    String url;
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    switch (searchIn) {
      case SearchIn.ARTISTS:
        url = ARTIST_URL + '&search_by=first_name&&search_key=$searchKey';
        break;
      case SearchIn.SONGS:
        url = SONG_URL + '&search_by=title&&search_key=$searchKey';
        break;
      case SearchIn.ALBUMS:
        url = ALBUM_URL + '&search_by=title&&search_key=$searchKey';
        break;
      case SearchIn.PLAYLISTS:
        url = PLAYLIST_URL + '&search_by=title&&search_key=$searchKey';
        break;
    }

    http.Response response = await client.get(Uri.parse(url), headers: headers);
    return response;
  }
}
