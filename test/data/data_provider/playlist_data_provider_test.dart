import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:streaming_mobile/data/data_provider/playlist_dataprovider.dart';

import '../../fixtures/fixture_reader.dart';

class MockPlaylistDataProvider extends Mock implements PlaylistDataProvider {}

void main() {
  final playlistDataProvider = MockPlaylistDataProvider();
  when(playlistDataProvider.getPlaylists()).thenAnswer((value) async {
    // print()
    return await http.Response(fixture('playlist_list.json'), 200);
  });

  group("Testing playlist fetching", () {
    test("Test successful playlist fetching from server", () async {
      http.Response playlistResponse =
          await playlistDataProvider.getPlaylists(); //add params for later use
      expect(playlistResponse.statusCode, 200);
    });
  });
}
