import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:streaming_mobile/data/models/playlist.dart';

import '../../fixtures/fixture_reader.dart';

main() {
  final tPlaylistData = Data(
    id: "id",
    title: "title",
    createdAt: "created_at",
    createdBy: "created_by",
    coverImg: "cover_img",
    likes: 123,
    description: "description",
    type: "type",
    views: 123,
    trackCount: 12,
  );
  final List<Links> tLinks = [
    Links(
        self: "/songs?page=5&per_page=20",
        first: "/songs?page=0&per_page=20",
        previous: "/songs?page=4&per_page=20",
        next: "/songs?page=6&per_page=20",
        last: "/songs?page=26&per_page=20")
  ];
  final Metadata tMetaData = Metadata(
    page: 5,
    perPage: 20,
    pageCount: 20,
    totalCount: 521,
    links: tLinks,
  );
  final tPlaylist = Playlist(
      mMetadata: tMetaData, data: tPlaylistData, success: true, status: 200);

  group('playlist from json and to json', () {
    test('from Json', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('playlist.json'));
      // act
      final result = Playlist.fromJson(jsonMap);
      print('result ${result.mMetadata.page}');
      // assert
      expect(result, tPlaylist);
    });

    test('to Json', () async {
      // arrange
      final expectedMap = {
        "_metadata": {
          "page": 5,
          "per_page": 20,
          "page_count": 20,
          "total_count": 521,
          "Links": [
            {
              "self": "/songs?page=5&per_page=20",
              "first": "/songs?page=0&per_page=20",
              "previous": "/songs?page=4&per_page=20",
              "next": "/songs?page=6&per_page=20",
              "last": "/songs?page=26&per_page=20"
            }
          ]
        },
        "data": {
          "id": "id",
          "title": "title",
          "description": "description",
          "created_by": "created_by",
          "created_at": "created_at",
          "cover_img": "cover_img",
          "views": 123,
          "track_count": 12,
          "type": "type",
          "likes": 123
        },
        "success": true,
        "status": 200
      };
      // act
      final result = tPlaylist.toJson();
      // assert
      expect(result, expectedMap);
    });
  });
}
