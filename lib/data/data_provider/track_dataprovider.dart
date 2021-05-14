import 'package:http/http.dart' as http;

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
    "track_url": "http://demo.unified-streaming.com/video/tears-of-steel/tears-of-steel.ism/.m3u8/tears-of-steel-audio_eng=64008.m3u8",
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
    // http.Response response = await client.get(Uri.parse(
    //     'https://endpoint/playlist/popular?x&page=0&per_page=10&sort=asc'));

    return http.Response(testData, 200);
  }
}
