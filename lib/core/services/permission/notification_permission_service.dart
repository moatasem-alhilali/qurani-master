import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
 

  static Future<void> handelNotification() async {
    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied) {
      await Permission.notification.request();
    }
  }
}
