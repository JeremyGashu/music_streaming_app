import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/data/data_provider/track_dataprovider.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/data/models/track.dart';
import 'package:streaming_mobile/imports.dart';

class UserDownloadManager {
  final Box<LocalDownloadTask> userDownloadBox;
  final Box segmentsBox;
  final Box downloadedMediaBox;
  UserDownloadManager(
      {@required this.userDownloadBox,
      @required this.segmentsBox,
      @required this.downloadedMediaBox}) {}

  Future<List<LocalDownloadTask>> downloadTaskStream() async {
    List<LocalDownloadTask> downloadTasks = [];
    userDownloadBox.values.forEach((element) async {
      LocalDownloadTask task = await processLocalDownloadTask(element);
      if (task.progress != 100.0) {
        downloadTasks.add(task);
      }
    });
    return downloadTasks;
  }

  Future<void> addToDownload({String id, Track track}) async {
    var task = await getTaskById(id);
    if (task == null) {
      userDownloadBox.put(
          track.songId,
          LocalDownloadTask(
            songId: track.songId,
            title: track.title,
            coverImageUrl: track.coverImageUrl,
            songUrl: track.songUrl,
            artistFirstName: track.artist.firstName,
            artistLastName: track.artist.lastName,
            duration: track.duration,
            failed: false,
            genre: track.genre.name,
          ));
    }
  }

  static Future<Track> getTrackByIdFromRemote(String id) async {
    TrackDataProvider trackDataProvider = sl<TrackDataProvider>();
    Track track = await trackDataProvider.getTrackById(id: id);
    return track;
  }

  Future<LocalDownloadTask> getTaskById(String id) async {
    return userDownloadBox.get(id);
  }

  Future<void> deleteTask(String id) async {
    userDownloadBox.delete(id);
  }

  Future<List<LocalDownloadTask>> downloadedTasks() async {
    List<LocalDownloadTask> downloadTasks = [];
    userDownloadBox.values.forEach((element) async {
      if (downloadedMediaBox.get(element.songId) != null) {
        downloadTasks.add(element);
      }
    });
    return downloadTasks;
  }

  Future<LocalDownloadTask> processLocalDownloadTask(
      LocalDownloadTask downloadTask) async {
    double progress = 0.0;
    if (downloadedMediaBox.get(downloadTask.songId, defaultValue: null) !=
        null) {
      progress = 100.0;
    } else {
      List<String> segmentsList = this.segmentsBox.get(downloadTask.songId);
      var downloadTasks = await FlutterDownloader.loadTasks();
      downloadTasks.forEach((element) {
        if (segmentsList.indexOf(element.url) != -1) {
          if (element.status == DownloadTaskStatus.complete) {
            progress = progress + ((1 / segmentsList.length) * 100);
          }
        }
      });
    }
    downloadTask.progress = progress;

    return downloadTask;
  }
}
