import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/config_dataprovider.dart';
import 'package:streaming_mobile/data/models/config.dart';

class ConfigRepository {
  final ConfigDataProvider configDataProvider;
  ConfigRepository({@required this.configDataProvider});

  Future<ConfigData> getConfigData() async {
    try {
      http.Response response = await configDataProvider.getConfigData();
      var decodedResponse = jsonDecode(response.body);
      print('decoded config data $decodedResponse');
      return ConfigData.fromJson(decodedResponse['data']);
    } catch (e) {
      throw Exception("Error fetching ConfigData!");
    }
  }
}
