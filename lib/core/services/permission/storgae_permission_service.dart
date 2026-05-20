import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class StoragePermissionService {
  static Future<void> handleStorage() async {
    if (!Platform.isAndroid) {
      return;
    }

    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        // await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {}
  }

  static Future<void> manageExternalStorage() async {
    if (!Platform.isAndroid) {
      return;
    }

    final storage = await Permission.storage.status;
    if (storage.isDenied) {
      await Permission.storage.request();
    }
  }
}
