import 'package:http/http.dart' as http;

var testData = '''
{
  "data": {
    "id": "id",
    "likes": 123,
    "title": "title",
    "release_date": "2012-02-27 13:27:00,123456789z",
    "artist_id": "artist_id",
    "album_id": "album_id",
    "cover_img_url": "cover_image_url",
    "track_url": "track_url",
    "views": 123,
    "duration": 123,
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
    // http.Response response = await client.get(Uri.parse(
    //     'https://endpoint/playlist/popular?x&page=0&per_page=10&sort=asc'));

    return http.Response(testData, 200);
  }
}
