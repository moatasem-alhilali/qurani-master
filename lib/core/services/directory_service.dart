import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryService {
  static Future<String?> getExternalStoragePath() async {
    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');

      if (!directory.existsSync()) {
        directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print('Cannot get download folder path');
    }
    return directory?.path;
  }
}
