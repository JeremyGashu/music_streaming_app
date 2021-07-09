import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/data/data_provider/search_data_provider.dart';

class SearchRepository {
  final SearchDataProvider dataProvider;
  SearchRepository({@required this.dataProvider})
      : assert(dataProvider != null);

  Future<dynamic> search(
      {String searchBy,
      String searchKey,
      SearchIn searchIn = SearchIn.SONGS}) async {
    http.Response searchResult = await dataProvider.search(
        searchBy: searchBy, searchIn: searchIn, searchKey: searchKey);
    print('search loaded = > ${searchResult.body}');
    var decodedSearchResult = jsonDecode(searchResult.body);
    return decodedSearchResult;
  }
}
