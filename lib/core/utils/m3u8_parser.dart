import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';

class ParseHls {
  final httpClient = new HttpClient();

  Future<HlsPlaylist> parseHLS(String m3u8String) async {
    try {
      Uri playlistUri;
      var playlist;
      playlist =
          await HlsPlaylistParser.create().parseString(playlistUri, m3u8String);
          
      return playlist;
    } catch (e) {
      // throw Exception();
    }
  }

  /// Download .m3u8 file from given url and reads it
  /// and saves it to local directory
  Future<bool> writeLocalM3u8File(String path) async {
    try {
      // String dir = (Platform.isAndroid
      //         ? await getExternalStorageDirectory()
      //         : await getApplicationDocumentsDirectory())
      //     .path;
      // String filePath = dir + '/' + fileId;
      // String filenameTxt = '/main.txt';
      // String filename = '/main.m3u8';
      // String keyFileName = '/enc.key';

      // create the dir to save the file
      // await createDir('$dir/$fileId');

      // download the file to the created folder
      // await downloadFile(url, filePath, filenameTxt);
      // print('////////////////////////// Downloading m3u8File finished');

      // read m3u8 as string
      String m3u8String = await m3u8StringLoader(path);
      // int start = m3u8String.indexOf('URI');
      // int end = m3u8String.indexOf('IV');
      // String keyUrl = m3u8String.substring(start+5, end-2);
      // print(keyUrl);
      // await downloadFile(keyUrl, dir, keyFileName);
      // print('////////////////////////// Downloading key file finished');
      // m3u8String.replaceRange(start, end, '''URI="enc.key",''');
      /// write [m3u8String] to local path
      File file = File(path);
      file.writeAsString(m3u8String);
      // File keyFile = File('$dir/$fileId/$keyFileName');

      return true;
    } on Exception {
      // throw Exception();
    }
  }

  Future<String> downloadFile(String url, String dir, String filename) async {
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

  Future<bool> updateLocalM3u8(String filePath) async {
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

  Future<bool> encryptFile(String filePath) async {
    // TODO: generate password on main and save it hive and read from hive
    var crypt = AesCrypt('my cool password');
    crypt.setOverwriteMode(AesCryptOwMode.on);

    /// encrypt file
    await crypt.encryptFile(filePath);
    File file = new File(filePath);
    await file.delete();
    return true;
  }

  Future<bool> decryptFile(String filePath) async {
    try {
      var crypt = AesCrypt('my cool password');
      await crypt.decryptFile(filePath);
      // File file = new File(filePath);
      // await file.delete();
      return true;
    } catch (e, st) {
      print(e);
      print(st);
      throw Exception("decryption failed");
    }
  }

  /// This method returns the entire String of m3u8 file
  /// It takes the a String of path to the file as an argument
  Future<String> m3u8StringLoader(String filePath) async {
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

  Future<String> m3u8StringLoaderNew(String filePath) async {
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

    int start = m3u8Text.indexOf('URI');
    int end = m3u8Text.indexOf('IV');
    m3u8Text = m3u8Text.replaceRange(start, end, '''URI="enc.txt",''');
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
