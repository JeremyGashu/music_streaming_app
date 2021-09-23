import 'package:http/http.dart' as http;
import 'package:streaming_mobile/data/data_provider/like_dataprovider.dart';

class LikeRepository {
  final LikeDataProvider likeDataProvider;

  LikeRepository({this.likeDataProvider}) : assert(likeDataProvider != null);

  Future<bool> likeArtist(String id) async {
    try {
      http.Response response = await likeDataProvider.likeArtist(id);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> likeAlbum(String id) async {
    try {
      http.Response response = await likeDataProvider.likeAlbum(id);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> likePlaylist(String id) async {
    try {
      http.Response response = await likeDataProvider.likePlaylist(id);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> likeSong(String id) async {
    try {
      http.Response response = await likeDataProvider.likeSong(id);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }
}
