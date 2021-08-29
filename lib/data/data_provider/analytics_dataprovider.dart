
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';

class AnalyticsDataProvider {
  final http.Client client;
  AnalyticsDataProvider({@required this.client}) : assert(client != null);

  Future<http.Response> sendAnalyticsData({String analytics}) async {

    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
      'Content-Type': 'application/json'
    };

    http.Response response = await http.post(Uri.parse(ANALYTICS_URL),
        headers: headers,
        body: analytics);
        print('analytics => to be sent $analytics');
        //  analytics = analytics.replaceAll('\\"', "");
         print('analytics => after being parser $analytics');
        print('analytics => response ${response.body} ${response.statusCode}');
    return response;
  }
}
