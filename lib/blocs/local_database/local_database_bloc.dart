import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/blocs/local_database/local_database_event.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_state.dart';
import 'package:streaming_mobile/data/models/download_task.dart';

import 'local_database_state.dart';

class LocalDatabaseBloc extends Bloc<LocalDatabaseEvent, LocalDatabaseState> {
  final MediaDownloaderBloc mediaDownloaderBloc;
  StreamSubscription downloaderSub;
  LocalDatabaseBloc({@required this.mediaDownloaderBloc}):assert(mediaDownloaderBloc!=null),super(LocalDBIdle()) {
    print("LocalDatabaseBloc: constructor");
    /// Subscribe to [ MediaDownloaderBloc ] and listen to [DownloadState]
    downloaderSub = mediaDownloaderBloc.stream.listen((downloadState) {
      // if(downloadState is DownloadCompleted){
      //   add(WriteToLocalDB(boxName: 'downloadTasks', key: "${
      //     downloadState.downloadedTask.track_id
      //   }/${downloadState.downloadedTask.segment_number}", value: downloadState.downloadedTask));
      // }
      /// save only when download is done
      if (downloadState is DownloadDone){
        print("MediaDownloaderBloc: Download Finished");
        add(WriteToLocalDB(boxName: 'downloadedMedias', key: "${downloadState.downloadedTask.track_id}", value: "downloaded"));
      }
    });
    // Initialize local database
    // add(InitLocalDB());
  }

  @override
  Future<void> close() {
    // cancel stream subscription when bloc closes
    downloaderSub?.cancel();
    return super.close();
  }

  @override
  Stream<LocalDatabaseState> mapEventToState(LocalDatabaseEvent event) async*{
    try{
      LazyBox box;
      yield LocalDBBusy();
      if(event is InitLocalDB){
        print("Initializing localDb");
        Hive.registerAdapter(DownloadTaskAdapter());
        await Hive.openLazyBox<DownloadTask>('downloadTasks');
        await Hive.openLazyBox('downloadedMedias');
      }else if(event is ReadLocalDB){
         box = Hive.lazyBox(event.boxName);
         yield LocalDBSuccess(data: await box.get(event.key));
      }else if(event is WriteToLocalDB){
        box = Hive.lazyBox(event.boxName);
        box.put(event.key, event.value);
        yield LocalDBSuccess(data: null);
      }else if(event is UpdateFromLocalDB){
        box = Hive.lazyBox(event.boxName);
        box.put(event.key, event.value);
        yield LocalDBSuccess(data: null);
      }else if(event is DeleteFromLocalDB){
        box = Hive.lazyBox(event.boxName);
        box.delete(event.key);
        yield LocalDBSuccess(data: null);
      }
    }catch(error){
      yield LocalDBFailed();
    }
  }

}