import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/data_provider/search_data_provider.dart';
import 'package:streaming_mobile/data/models/album.dart';
import 'package:streaming_mobile/data/models/artist.dart';
import 'package:streaming_mobile/data/models/playlist.dart';
import 'package:streaming_mobile/data/models/track.dart';

class SearchRepository {
  final SearchDataProvider dataProvider;
  SearchRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<ArtistsResponse> searchArtists({@required String searchKey}) async {
    http.Response searchResult = await dataProvider.search(
        searchIn: SearchIn.ARTISTS, searchKey: searchKey);
    print('searched artists = > ${searchResult.body}');
    var decodedSearchResult = jsonDecode(searchResult.body);
    return ArtistsResponse.fromJson(decodedSearchResult);
  }

  Future<TracksResponse> searchSongs({@required String searchKey}) async {
    http.Response searchResult = await dataProvider.search(
        searchIn: SearchIn.SONGS, searchKey: searchKey);
    print('searched songs = > ${searchResult.body}');
    var decodedSearchResult = jsonDecode(searchResult.body);
    return TracksResponse.fromJson(decodedSearchResult);
  }

  Future<PlaylistsResponse> searchPlaylists(
      {@required String searchKey}) async {
    http.Response searchResult = await dataProvider.search(
        searchIn: SearchIn.PLAYLISTS, searchKey: searchKey);
    print('searched playlists = > ${searchResult.body}');
    var decodedSearchResult = jsonDecode(searchResult.body);
    return PlaylistsResponse.fromJson(decodedSearchResult);
  }

  Future<AlbumsResponse> searchAlbums({@required String searchKey}) async {
    http.Response searchResult = await dataProvider.search(
        searchIn: SearchIn.ALBUMS, searchKey: searchKey);
    print('searched albums = > ${searchResult.body}');
    var decodedSearchResult = jsonDecode(searchResult.body);
    return AlbumsResponse.fromJson(decodedSearchResult);
  }
}
