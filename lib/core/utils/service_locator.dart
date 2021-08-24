import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/core/services/user_download_manager.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';

final getIt = GetIt.instance;

setupLocator() async {
  var userDownloadBox = await Hive.openBox<LocalDownloadTask>('user_downloads');
  var segmentBox = await Hive.openBox('download_segments');
  var downloadedMediaBox = await Hive.openBox('downloadedMedias');
  getIt.registerSingleton(UserDownloadManager(
      userDownloadBox: userDownloadBox, segmentsBox: segmentBox, downloadedMediaBox: downloadedMediaBox));
}
