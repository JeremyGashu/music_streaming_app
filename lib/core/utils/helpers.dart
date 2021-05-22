import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart' as mdm;
import 'package:hive_flutter/hive_flutter.dart';

class LocalHelper{
  static Future<String> getFilePath(context) async{
    return (Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory())
    .path;
  }

  static Future<String> getLocalFilePath() async{
    return (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory())
        .path;
  }

  static Future<bool> isFileDownloaded(String fileId)async{
    var box = Hive.lazyBox("downloadedMedias");
    var trackDownloaded = await box.get(fileId);
    return trackDownloaded != null;
  }

  static Future<void> downloadMedia(String trackUrl, String fileId) async {
    try{
      await Hive.initFlutter();
      await Hive.openLazyBox("downloadedMedias");
      await FlutterDownloader.initialize(
          debug: true
      );
      print("LocalHelper:[downloadMedia]: trackUrl: $trackUrl, fileId: ${fileId}");
      ParseHls parseHLS = ParseHls();
      var dir = await LocalHelper.getLocalFilePath();
      bool isFileDownloaded = await LocalHelper.isFileDownloaded(fileId);
      if(!isFileDownloaded){
        // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
        //     await parseHLS.downloadFile(trackUrl,
        //         '$dir/${fileId}', "main.m3u8"))
        //     .readAsStringSync());

        HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File("$dir/$fileId/main.m3u8").readAsStringSync());


        List<mdm.DownloadTask> downloadTasks = [];
        hlsPlayList.segments.forEach((segment) {
          var segmentIndex = hlsPlayList.segments.indexOf(segment);
          downloadTasks.add(mdm.DownloadTask(
              track_id: fileId,
              segment_number: segmentIndex,
              downloadType: mdm.DownloadType.media,
              downloaded: false,
              download_path: '$dir/${fileId}/',
              url: segment.url));
        });
        print(downloadTasks);
        MediaDownloaderBloc mediaDownloaderBloc = MediaDownloaderBloc();
        mediaDownloaderBloc.add(InitializeDownloader());
        mediaDownloaderBloc.add(AddDownload(downloadTasks: downloadTasks));
      }
    }catch(error, stacktrace){
      print("LocalHelper:[downloadMedia]: error: $error");
      print(stacktrace);
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print('download callback');
    // final SendPort send =
    // IsolateNameServer.lookupPortByName('downloader_send_port');
    // send.send([id, status, progress]);
  }

  static Future<bool> encryptFile(String filePath)async{
    // TODO: generate password on main and save it hive and read from hive
    var crypt = AesCrypt('my cool password');
    crypt.setOverwriteMode(AesCryptOwMode.on);
    /// encrypt file
    await crypt.encryptFile(filePath);
    File file = new File(filePath);
    await file.delete();
    return true;
  }

  static Future<bool> decryptFile(String filePath) async{
    try{
      var crypt = AesCrypt('my cool password');
      await crypt.decryptFile(filePath);
      // File file = new File(filePath);
      // await file.delete();
      return true;
    }catch(e, st){
      print(e);
      print(st);
      throw Exception("decryption failed");
    }
  }
}