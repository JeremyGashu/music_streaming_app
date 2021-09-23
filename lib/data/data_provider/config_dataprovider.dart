import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class ConfigDataProvider {
  final http.Client client;

  ConfigDataProvider({this.client}) : assert(client != null);

  Future<http.Response> getConfigDataReal() async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    String url = '$BASE_URL/appconfigs?page=0&per_page=20';

    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> getConfigData() async {
    String testJson = '''
    {
      "success" : true,
      "data" : {"version" : "1.0.0", "force_update" : true}
    }
    ''';
    return http.Response(testJson, 200);
  }
}
