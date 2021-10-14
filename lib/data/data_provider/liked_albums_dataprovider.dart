import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class LikedAlbumsDataprovider {
  final http.Client client;

  LikedAlbumsDataprovider({this.client}) : assert(client != null);

  Future<http.Response> getLikedAlbums({int page}) async {
    page ??= 1;
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    String url = '$LIKES_URL/album?page=${page}&per_page=10';

    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    return response;
  }
}
