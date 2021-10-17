import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/models/track.dart';

class TrackDataProvider {
  final http.Client client;

  TrackDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getTracks({int page}) async {
    page ??= 1;
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    String url = '$BASE_URL/songs?page=${page}&per_page=10&single=true';

    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> getTracksByArtisId({String artistId}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    http.Response response = await client.get(
      Uri.parse(SONG_BY_ARTIST + artistId),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> getTracksByGenre({String genreId, int page}) async {
    page ??= 1;
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    final String url = '$BASE_URL/songs?page=$page&per_page=10&search_by=genre_id&search_key=$genreId';
    print('load tracks by genre url => $url');
    http.Response response = await client.get(
      Uri.parse(url,),
      headers: headers,
    );
    return response;
  }

  Future<Track> getTrackById({String id}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    final String url = '$BASE_URL/songs/$id';
    print('load tracks by genre url => $url');
    http.Response response = await client.get(
      Uri.parse(url,),
      headers: headers,
    );
    print('current status code => ${response.statusCode}');
    if(response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print('track body => $body');
      
      Track track = Track.fromJson(body['data']);

      print('track parsed => $track');
      
      return track;
    }
    return null;
  }
}
