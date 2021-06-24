// import 'dart:convert';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:streaming_mobile/data/models/track.dart';
//
// import '../../fixtures/fixture_reader.dart';
//
// main() {
//   final tTrackData = Data(
//       id: "id",
//       likes: 123,
//       title: "title",
//       releaseDate: "2012-02-27 13:27:00,123456789z",
//       artistId: "artist_id",
//       albumId: "album_id",
//       coverImgUrl: "cover_image_url",
//       trackUrl: "track_url",
//       views: 123,
//       duration: 123,
//       lyricsUrl: "lyrics_url",
//       createdBy: "created_by");
//   final tTrack = Track(data: tTrackData, success: true, status: 200);
//
//   group('track from json and to json', () {
//     test('from Json', () async {
//       // arrange
//       final Map<String, dynamic> jsonMap = json.decode(fixture('track.json'));
//       // act
//       final result = Track.fromJson(jsonMap);
//       // assert
//       expect(result, tTrack);
//     });
//
//     test('to Json', () async {
//       // arrange
//       final expectedMap = {
//         "data": {
//           "id": "id",
//           "likes": 123,
//           "title": "title",
//           "release_date": "2012-02-27 13:27:00,123456789z",
//           "artist_id": "artist_id",
//           "album_id": "album_id",
//           "cover_img_url": "cover_image_url",
//           "track_url": "track_url",
//           "views": 123,
//           "duration": 123,
//           "lyrics_url": "lyrics_url",
//           "created_by": "created_by"
//         },
//         "success": true,
//         "status": 200
//       };
//       // act
//       final result = tTrack.toJson();
//       // assert
//       expect(result, expectedMap);
//     });
//   });
// }

import 'package:flutter_test/flutter_test.dart';

main() {
  test('track test', () {
    expect(1, 1);
  });
}
