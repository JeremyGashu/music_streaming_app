import  'dart:async';
import 'dart:convert';

import 'package:streaming_mobile/data/data_provider/genre_dataprovider.dart';
import 'package:streaming_mobile/data/models/genre.dart';
import 'package:flutter/foundation.dart';

class GenreRepository{
  final GenreDataProvider genreDataProvider;
  GenreRepository({@required this.genreDataProvider});

  Future<List<Genre>> fetchGenres() async {
    var response = await genreDataProvider.fetchGenres();
    if(response.statusCode == 200){
      var rawResp = jsonDecode(response.body);
      if(rawResp['success'] == true){
        List<Genre> genres = [];
        (rawResp['data'] as List<dynamic>).forEach((element) {
          genres.add(Genre.fromJson(element));
        });
        return genres;
      }else{
        throw Exception("Something went wrong, while fetching genres");
      }
    }else{
      throw Exception("Something went wrong, while fetching genres");
    }
  }
}