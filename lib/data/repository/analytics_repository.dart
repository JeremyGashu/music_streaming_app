import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/analytics_dataprovider.dart';
import 'package:streaming_mobile/data/models/analytics.dart';

class AnalyticsRepository {
  final AnalyticsDataProvider dataProvider;
  AnalyticsRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<bool> sendAnalyticsData({List<Analytics> analytics}) async {
    http.Response response =
        await dataProvider.sendAnalyticsData(analytics: analytics);
    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['success']) {
      return true;
    }
    return false;
  }
}
