import 'dart:convert';

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

    String url = '$BASE_URL/android/version';

    http.Response response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> getConfigData() async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };

    final String url = '$BASE_URL/android/version';

    http.Response response = await client.get(
      Uri.parse(url,),
      headers: headers,
    );
    print('current status code => ${response.statusCode}');
      var body = jsonDecode(response.body);
      print('config body => $body');

      
      return response;

  }
}
