import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/firebase_notification.dart';
import 'package:quran_app/core/services/service_locator.dart';

class NotificationPermissionService {
  static Future<void> handelNotification() async {
    if (Platform.isIOS) {
      await FirebaseNotificationService.instance.initialize();
      await sl<NotificationService>().setupNotificationActions();
      return;
    }

    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied) {
      await Permission.notification.request();
    }
    await sl<NotificationService>().setupNotificationActions();
  }
}
