import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';

class ParseHls {
  final httpClient = new HttpClient();

  Future<HlsPlaylist> parseHLS(String m3u8String) async {
    try {
      final String fileData = await rootBundle.loadString(m3u8String);
      Uri playlistUri;
      var playlist;
      playlist =
          await HlsPlaylistParser.create().parseString(playlistUri, fileData);
      return playlist;
    } catch (e) {
      throw Exception();
    }
  }

  /// Download .m3u8 file from given url and reads it
  /// and saves it to local directory
  Future<bool> writeLocalM3u8File(String url, String fileId) async {
    try {
      String dir = (Platform.isAndroid
              ? await getExternalStorageDirectory()
              : await getApplicationDocumentsDirectory())
          .path;
      String filePath = dir + '/' + fileId;
      String filename = '/main.m3u8';

      // create the dir to save the file
      await createDir('$dir/$fileId');

      // download the file to the created folder
      await downloadFile(url, filePath, filename);
      print('////////////////////////// Download finished');

      // read m3u8 as string
      String m3u8String = await m3u8StringLoader('$dir/$fileId/$filename');

      /// TODO: write [m3u8String] to local path

      return true;
    } on Exception {
      throw Exception();
    }
  }

  Future<bool> downloadFile(String url, String dir, String filename) async {
    print('/////////////////// DOWNLOAD STARTED from $url. . .');
    try {
      /// Send request to [url]
      /// Write byte stream on [bytes]
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      /// Write [bytes] to [file]
      /// on local storage 'dir/filename'
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      print('/////////////////// DOWNLOAD FINISHED!');

      return true;
    } on Exception {
      throw Exception();
    }
  }

  /// This method returns the entire String of m3u8 file
  /// It takes the a String of path to the file as an argument
  Future<String> m3u8StringLoader(String filePath) async {
    String m3u8Text = '';
    await File(filePath)
        .openRead()
        .map(utf8.decode)
        .transform(new LineSplitter())
        .forEach((line) {
      if (line.startsWith('http')) {
        m3u8Text += (line.split('/').last + '\n');
      } else {
        m3u8Text += (line + '\n');
      }
    });

    int start = m3u8Text.indexOf('URI');
    int end = m3u8Text.indexOf('IV');

    m3u8Text.replaceRange(start, end, '''URI="enc.key",''');

    return m3u8Text;
  }

  /// This method creates a directory if it does not exist
  /// It takes the path of the directory as an argument
  Future<void> createDir(String dir) async {
    final Directory _createDirFolder = Directory('$dir');
    if (!_createDirFolder.existsSync()) {
      await _createDirFolder.create(recursive: true);
    }
  }
}
