import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/blocs/local_database/local_database_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';

final getIt = GetIt.instance;

setupLocator() async {
  var userDownloadBox = await Hive.openBox<LocalDownloadTask>('user_downloads');
  var segmentBox = await Hive.openBox('download_segments');
  var downloadedMediaBox = await Hive.openBox('downloadedMedias');
  // var downloadQueue = await Hive.openBox("downloadQueue");
  getIt.registerSingleton(UserDownloadManager(
      userDownloadBox: userDownloadBox,
      segmentsBox: segmentBox,
      downloadedMediaBox: downloadedMediaBox));
  getIt.registerSingleton<MediaDownloaderBloc>(MediaDownloaderBloc());
  getIt.registerSingleton<LocalDatabaseBloc>(
      LocalDatabaseBloc(mediaDownloaderBloc: getIt()));
}
