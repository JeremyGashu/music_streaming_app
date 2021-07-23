import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

//"track_url": "http://138.68.163.236:8787/track/1",
var testData = '''
{
  "data": {
    "id": "id",
    "likes": 123,
    "title": "title",
    "release_date": "2012-02-27 13:27:00,123456789z",
    "artist_id": "artist_id",
    "album_id": "album_id",
    "cover_img_url": "https://images.template.net/wp-content/uploads/2016/05/17050744/DJ-Album-Cover-Template-Sample.jpg?width=100",
    "track_url": "https://138.68.163.236:8787/track/1",    
    "views": 123,
    "duration": 300000,
    "lyrics_url": "lyrics_url",
    "created_by": "created_by" 
  },
  "success": true,
  "status": 200
}
''';

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
}
