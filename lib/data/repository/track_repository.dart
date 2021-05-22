import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/track.dart';

class TrackRepository {
  final TrackDataProvider dataProvider;
  TrackRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<Track> getTracks() async {
    http.Response playlists = await dataProvider.getTracks();
    var decodedPlaylists = jsonDecode(playlists.body);
    return Track.fromJson(decodedPlaylists);
  }


}
