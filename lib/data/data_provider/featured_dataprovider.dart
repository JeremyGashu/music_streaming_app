import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class FeaturedDataProvider {
  final http.Client client;

  FeaturedDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getFeaturedAlbums({int page}) async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    http.Response response = await client.get(
      Uri.parse(FEATURED_URL),
      headers: headers,
    );

    return response;
  }
}
