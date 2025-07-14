import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quran_app/main.dart';

class DirectoryService {
  static Future<String?> getExternalStoragePath() async {
    try {
      // For Android 11+ (API 30+), use app-specific external storage
      // This doesn't require MANAGE_EXTERNAL_STORAGE permission
      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        // Create Downloads subfolder in app-specific storage
        final downloadsDir = Directory('${directory.path}/Downloads');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        logger.i('Using app-specific storage: ${downloadsDir.path}');
        return downloadsDir.path;
      }

      // Fallback to application documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${documentsDir.path}/Downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      logger.i('Fallback to documents storage: ${downloadsDir.path}');
      return downloadsDir.path;
    } catch (err) {
      logger.e('Cannot get download folder path: $err');
      return null;
    }
  }

  /// Get public downloads directory (requires MANAGE_EXTERNAL_STORAGE on API 30+)
  static Future<String?> getPublicDownloadsPath() async {
    try {
      // This requires MANAGE_EXTERNAL_STORAGE permission on Android 11+
      final directory = Directory('/storage/emulated/0/Download');

      if (await directory.exists()) {
        logger.i('Using public downloads: ${directory.path}');
        return directory.path;
      }

      return null;
    } catch (err) {
      logger.e('Cannot access public downloads folder: $err');
      return null;
    }
  }
}
