import 'package:http/http.dart' as http;

var testData = '''
{
  "_metadata": {
    "page": 5,
    "per_page": 20,
    "page_count": 20,
    "total_count": 521,
    "Links": [
      {
        "self": "/songs?page=5&per_page=20",
        "first": "/songs?page=0&per_page=20",
        "previous": "/songs?page=4&per_page=20",
        "next": "/songs?page=6&per_page=20",
        "last": "/songs?page=26&per_page=20"
      }
    ]
  },
  "data": {
    "id": "id",
    "title": "title",
    "description": "description",
    "created_by": "created_by",
    "created_at": "created_at",
    "cover_img": "cover_img",
    "views": 123,
    "track_count": 12,
    "type": "type",
    "likes": 123
  },
  "success": true,
  "status": 200
}
''';

class PlaylistDataProvider {
  final http.Client client;

  PlaylistDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getPlaylists() async {
    // http.Response response = await client.get(Uri.parse(
    //     'https://endpoint/playlist/popular?x&page=0&per_page=10&sort=asc'));

    return http.Response(testData, 200);
  }
}
