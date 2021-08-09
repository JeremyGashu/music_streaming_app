import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/new_release_dataprovider.dart';
import 'package:streaming_mobile/data/models/new_release.dart';
import 'package:streaming_mobile/data/models/track.dart';

class NewReleaseRepository {
  final NewReleaseDataProvider dataProvider;
  NewReleaseRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<NewReleaseResponse> getNewReleases({int page}) async {
    http.Response newReleases = await dataProvider.getNewRelease(page: page);
    print('new releases loaded = > ${newReleases.body}');
    var decodedNewReleases = jsonDecode(newReleases.body);
    print(
        'decoded new releases => ${TracksResponse.fromJson(decodedNewReleases)}');
    return NewReleaseResponse.fromJson(decodedNewReleases);
  }
}
