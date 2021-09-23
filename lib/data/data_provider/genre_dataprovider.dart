import 'dart:async';

import 'package:hive/hive.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'base_dataprovider.dart';
import 'package:streaming_mobile/core/app/urls.dart';
import 'package:http/http.dart' as http;


class GenreDataProvider extends BaseDataProvider {
  final http.Client client;
  GenreDataProvider({this.client}):super(client: client);

  Future<http.Response> fetchGenres() async {
    var authBox = await Hive.openBox<AuthData>('auth_box');
    var authData = authBox.get('auth_data');
    var headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    return await client.get(Uri.parse(BASE_URL+"/genres"), headers: headers);
  }
}