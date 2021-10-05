import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streaming_mobile/blocs/local_database/local_database_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_bloc.dart';
import 'package:streaming_mobile/blocs/single_media_downloader/media_downloader_event.dart';
import 'package:streaming_mobile/core/utils/m3u8_parser.dart';
import 'package:streaming_mobile/data/models/download_task.dart' as mdm;

class LocalHelper {
  static final httpClient = new HttpClient();

  static Future<String> getFilePath(context) async {
    return (Theme.of(context).platform == TargetPlatform.android
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory())
        .path;
  }

  static Future<String> getLocalFilePath() async {
    return (Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory())
        .path;
  }

  static Future<bool> allSegmentsDownloaded({String id}) async {
    String dir = await LocalHelper.getLocalFilePath();
    String path = '${await getLocalFilePath()}/$id/main.m3u8';
    ParseHls parseHLS = ParseHls();

    File m3u8File = File(path);
    HlsMediaPlaylist hlsPlayList;
    if (m3u8File.existsSync()) {
      hlsPlayList = await parseHLS.parseHLS(m3u8File.readAsStringSync());
      int segmenetLength = hlsPlayList.segments.length;
      int fileCounter = 0;
      Directory directory = Directory('$dir/$id');
      List<FileSystemEntity> files = directory.listSync(recursive: true);

     files.forEach((file) => {
       if(file.path.split('.').last.endsWith('ts')) {
         fileCounter++
       }
     });
     return segmenetLength == fileCounter;
    } else {
      return false;
    }
  }

  static Future<bool> isFileDownloaded(String fileId) async {
    var box = await Hive.openBox("downloadedMedias");
    var trackDownloaded = await box.get(fileId);
    print("Box Length ${box.length}");
    await box.values.forEach((element) {
      print(element);
    });
    return trackDownloaded != null;
  }

  static Future<void> downloadMedia(String trackUrl, String fileId) async {
    try {
      await Hive.initFlutter();
      await Hive.openBox("downloadedMedias");
      await FlutterDownloader.initialize(debug: true);
      print(
          "LocalHelper:[downloadMedia]: trackUrl: $trackUrl, fileId: ${fileId}");
      ParseHls parseHLS = ParseHls();
      var dir = await LocalHelper.getLocalFilePath();
      bool isFileDownloaded = await LocalHelper.isFileDownloaded(fileId);
      if (!isFileDownloaded) {
        // HlsMediaPlaylist hlsPlayList = await parseHLS.parseHLS(File(
        //     await parseHLS.downloadFile(trackUrl,
        //         '$dir/${fileId}', "main.m3u8"))
        //     .readAsStringSync());

        File m3u8File = File("$dir/$fileId/main.m3u8");
        HlsMediaPlaylist hlsPlayList;
        if (m3u8File.existsSync()) {
          hlsPlayList = await parseHLS.parseHLS(m3u8File.readAsStringSync());
        } else {
          hlsPlayList = await parseHLS.parseHLS(
              File(await downloadFile(trackUrl, '$dir/$fileId', "main.m3u8"))
                  .readAsStringSync());
        }

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
        LocalDatabaseBloc(mediaDownloaderBloc: mediaDownloaderBloc);
      }
    } catch (error, stacktrace) {
      print("LocalHelper:[downloadMedia]: error: $error");
      print(stacktrace);
    }
  }

  static Future<LocationData> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  static Future<String> m3u8StringLoader(String filePath) async {
    String m3u8Text = '';
    int segmentIndex = 0;
    await File(filePath)
        .openRead()
        .map(utf8.decode)
        .transform(new LineSplitter())
        .forEach((line) {
      if (line.startsWith('http')) {
        /// Replace the remote url with a local path
        /// Increment segment id
        m3u8Text += 'main${segmentIndex}.ts' + '\n';
        segmentIndex++;
      } else {
        m3u8Text += (line + '\n');
      }
    });

    // print(m3u8Text);
    /// Replace the key url to local path
    // int start = m3u8Text.indexOf('URI');
    // int end = m3u8Text.indexOf('IV');
    // print(m3u8Text.substring(start, end));
    // m3u8Text.replaceRange(start, end, '''URI="enc.key",''');

    return m3u8Text;
  }

  static Future<bool> updateLocalM3u8(String filePath) async {
    String m3u8Text = await m3u8StringLoader(filePath);
    if (m3u8Text.indexOf("EXT-X-KEY") == -1) {
      print("unencrypted m3u8");
      return false;
    }
    int start = m3u8Text.indexOf('URI');
    int end = m3u8Text.indexOf('IV');
    String keyUrl = m3u8Text.substring(start + 5, end - 2);
    print(keyUrl);
    print(m3u8Text.indexOf('''URI="/enc.key"'''));
    print(m3u8Text.indexOf("EXT-X-KEY"));

    var keyPath = filePath.substring(0, filePath.indexOf("/main.m3u8"));
    if (m3u8Text.indexOf('''URI="/enc.key"''') == -1) {
      File fileEnc = new File("${keyPath}/enc.key.aes");
      File fileOrig = new File("${keyPath}/enc.key");
      if (fileEnc.existsSync() && fileOrig.existsSync()) {
        fileOrig.deleteSync();
      } else if (fileEnc.existsSync() && !fileOrig.existsSync()) {
        /// check if only encrypted key exists
        m3u8Text = m3u8Text.replaceRange(start, end, '''URI="enc.key",''');
      } else if (!fileEnc.existsSync() && fileOrig.existsSync()) {
        await encryptFile("${keyPath}/enc.key");
      } else {
        await downloadFile(keyUrl, keyPath, 'enc.key');
        print('////////////////////////// Downloading key file finished');

        /// encrypt key
        await encryptFile("${keyPath}/enc.key");
        m3u8Text = m3u8Text.replaceRange(start, end, '''URI="enc.key",''');
      }
    } else {
      /// Todo: decrypt key before playing
      File file = new File("${keyPath}/enc.key.aes");
      File fileOrig = new File("${keyPath}/enc.key");
      if (file.existsSync() || fileOrig.existsSync()) {
        if (fileOrig.existsSync()) {
          await encryptFile("${keyPath}/enc.key");
        }
        m3u8Text = m3u8Text.replaceRange(start, end, '''URI="enc.key",''');
      } else {
        await downloadFile(keyUrl, keyPath, 'enc.key');
        print('////////////////////////// Downloading key file finished');
        m3u8Text = m3u8Text.replaceRange(start, end, '''URI="enc.key",''');
        await encryptFile("${keyPath}/enc.key");
      }
    }
    print(m3u8Text);
    await File(filePath).writeAsString(m3u8Text);
    return true;
  }

  static Future<String> downloadFile(
      String url, String dir, String filename) async {
    print('/////////////////// DOWNLOAD STARTED from url: $url');
    try {
      /// Send request to [url]
      /// Write byte stream on [bytes]
      httpClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      /// Write [bytes] to [file]
      /// on local storage 'dir/filename'

      File file = new File('$dir/$filename');
      if (!(await file.exists())) {
        await file.create(recursive: true);
        // await file.create(recursive: true);
      }
      await file.writeAsBytes(bytes);
      print('/////////////////// DOWNLOAD FINISHED!');
      return file.path;
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      // throw Exception();
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print('download callback');
    // final SendPort send =
    // IsolateNameServer.lookupPortByName('downloader_send_port');
    // send.send([id, status, progress]);
  }

  static Future<bool> encryptFile(String filePath) async {
    try {
      var crypt = AesCrypt('my cool password');
      crypt.setOverwriteMode(AesCryptOwMode.on);

      /// encrypt file
      await crypt.encryptFile(filePath);
      File file = new File(filePath);

      await file.delete();
      return true;
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      // throw Exception("encryption failed");
    }
  }

  static Future<bool> decryptFile(String filePath) async {
    try {
      File file = new File(filePath);
      if (!file.existsSync()) {
        print("downloading key since it is not available");
        int start = filePath.indexOf("enc.key.aes");
        print(filePath);
        print(start);
        print("enc.key.aes".length - 1);
        var m3u8FilePath =
            filePath.replaceRange(start, "enc.key.aes".length - 1, "main.m3u8");
        await updateLocalM3u8(m3u8FilePath);
      }
      var crypt = AesCrypt('my cool password');
      crypt.setOverwriteMode(AesCryptOwMode.on);
      await crypt.decryptFile(filePath);
      // File file = new File(filePath);
      // await file.delete();
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      int start = filePath.indexOf("enc.key.aes");
      print(filePath);
      print(start);
      print("enc.key.aes".length - 1);
      var decKeyPath =
          filePath.replaceRange(start, "enc.key.aes".length - 1, "enc.key");
      File file = new File(decKeyPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      // throw Exception("decryption failed");
    }
  }
}
