import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:streaming_mobile/data/models/analytics.dart';

class AnalyticsDataProvider {
  final http.Client client;
  AnalyticsDataProvider({@required this.client}) : assert(client != null);

  Future<http.Response> sendAnalyticsData({List<Analytics> analytics}) async {

    var json = {'analytics' : analytics.map((analyticsData) => analyticsData.toJson()).toList()};
    http.Response response = await http.post(Uri.parse(ANALYTICS_URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(json));
    return response;
  }
}
