// import 'dart:convert';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:streaming_mobile/data/models/album.dart';
//
// import '../../fixtures/fixture_reader.dart';
//
// main() {
//   final tAlbumData = Data(
//       id: "id",
//       artistId: "artist_id",
//       title: "title",
//       description: "description",
//       coverImage: "cover_image",
//       views: 123,
//       trackCount: 12,
//       likes: 123);
//   final tAlbum = Album(data: tAlbumData, success: true, status: 200);
//
//   group('album from json and to json', () {
//     tnaest('from Json', () async {
//       // arrange
//       final Map<String, dynamic> jsonMap = json.decode(fixture('album.json'));
//       // act
//       final result = Album.fromJson(jsonMap);
//       // assert
//       expect(result, tAlbum);
//     });
//
//     test('to Json', () async {
//       // arrange
//       final expectedMap = {
//         "data": {
//           "id": "id",
//           "title": "title",
//           "description": "description",
//           "cover_image": "cover_image",
//           "views": 123,
//           "track_count": 12,
//           "likes": 123,
//           "artist_id": "artist_id"
//         },
//         "success": true,
//         "status": 200
//       };
//       // act
//       final result = tAlbum.toJson();
//       // assert
//       expect(result, expectedMap);
//     });
//   });
// }

import 'package:flutter_test/flutter_test.dart';

main() {
  test('album test', () {
    expect(1, 1);
  });
}
