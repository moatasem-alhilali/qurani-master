import 'package:permission_handler/permission_handler.dart';

class StoragePermissionService {
  static Future<void> handleStorage() async {
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
    final storage = await Permission.storage.status;
    if (storage.isDenied) {
      await Permission.storage.request();
    }
    final manageExternalStorage = await Permission.manageExternalStorage.status;
    if (manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }
}
