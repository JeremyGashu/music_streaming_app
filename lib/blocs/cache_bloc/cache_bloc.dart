import 'dart:io';

import 'package:streaming_mobile/blocs/cache_bloc/cache_event.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_state.dart' as cs;
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/imports.dart';

class CacheBloc extends Bloc<CacheEvent, cs.CacheState> {
  CacheBloc() : super(cs.InitialState());

  @override
  Stream<cs.CacheState> mapEventToState(CacheEvent event) async* {
    if (event is ClearCache) {
      yield cs.LoadingState();
      try {
        Box<LocalDownloadTask> userDownloads =
            await Hive.openBox<LocalDownloadTask>('user_downloads');
        List<String> ids = userDownloads.values.map((e) => e.songId).toList();
        String dir = await LocalHelper.getLocalFilePath();
        Directory localDownloadDir = Directory(dir);
        if (localDownloadDir.listSync().length == 0) {
          yield cs.SuccessfulState(message: 'Your cache is already clean!');
          return;
        }
        int counter = 0;
        localDownloadDir.listSync().forEach((folder) {
          String id = folder.path.split('/').last;

          if (!ids.contains(id)) {
            folder.deleteSync(recursive: true);
            counter++;
          }
        });
        if (counter > 0) {
          yield cs.SuccessfulState(message: '$counter items cleared!');
        } else {
          yield cs.SuccessfulState(message: 'No cache to delete!');
        }
      } catch (e) {
        yield cs.ErrorState(message: 'Error deleting your cache!');
      }
    }
  }
}
