import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalHelper{
  static Future<String> getFilePath(context) async{
    return (Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory())
    .path;
  }
}