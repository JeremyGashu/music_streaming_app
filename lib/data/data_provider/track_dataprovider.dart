import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

//"track_url": "http://138.68.163.236:8787/track/1",

class TrackDataProvider {
  final http.Client client;

  TrackDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getTracks() async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    http.Response response = await client.get(
      Uri.parse(SONG_URL),
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
}
