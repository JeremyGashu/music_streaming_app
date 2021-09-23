import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_mobile/blocs/like/like_event.dart';
import 'package:streaming_mobile/blocs/like/like_state.dart';
import 'package:streaming_mobile/data/repository/like_repository.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository likeRepository;
  LikeBloc({this.likeRepository}) : super(InitialState());

  static Future<bool> checkLikedStatus({String boxName, String id}) async {
    Box box = await Hive.openBox(boxName);
    return box.keys.contains(id);
  }

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if (event is LikeAlbum) {

      yield LoadingState();
      try {
        bool status = await likeRepository.likeAlbum(event.id);
        yield SuccessState(status: status);
        Box box = await Hive.openBox('liked_albums');
        if(status) {
          await box.put(event.id, true);
        }
        else{
          await box.delete(event.id);
        }
      } catch (e) {
        yield ErrorState(message: 'Error Liking Album!');
      }
    } else if (event is LikeArtist) {
      yield LoadingState();

      try {
        bool status = await likeRepository.likeArtist(event.id);
        yield SuccessState(status: status);
        Box box = await Hive.openBox('liked_artists');
        if(status) {
          await box.put(event.id, true);
        }
        else{
          await box.delete(event.id);
        }
      } catch (e) {
        yield ErrorState(message: 'Error Liking Artist!');
      }
    } else if (event is LikePlaylist) {
      yield LoadingState();

      try {
        bool status = await likeRepository.likePlaylist(event.id);
        yield SuccessState(status: status);
        Box box = await Hive.openBox('liked_playlists');
        if(status) {
          await box.put(event.id, true);
        }
        else{
          await box.delete(event.id);
        }
      } catch (e) {
        yield ErrorState(message: 'Error Liking Playlist!');
      }
    } else if (event is LikeSong) {
      yield LoadingState();

      try {
        bool status = await likeRepository.likeSong(event.id);
        yield SuccessState(status: status);
        Box box = await Hive.openBox('liked_songs');
        if(status) {
          await box.put(event.id, true);
        }
        else{
          await box.delete(event.id);
        }
      } catch (e) {
        yield ErrorState(message: 'Error Liking Song!');
      }
    }
  }
}
