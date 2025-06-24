import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';

class NotificationPermissionService {
  static Future<void> handelNotification() async {
    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied) {
      await Permission.notification.request();
    }
    await sl<NotificationPermissionsService>().requestExactAlarmPermission();
    await sl<NotificationService>().setupNotificationActions();
  }
}
