import 'dart:io';

import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/firebase_notification.dart';
import 'package:quran_app/core/services/service_locator.dart';

/// تهيئة الإشعارات عند الإقلاع — **بلا طلب إذن**.
///
/// الإذن يُطلب مرّة واحدة في شاشات البداية (`PermissionsOnboardingScreen`)،
/// ثم بضغطة من تنبيه الرئيسية إن رُفض. كان هذا يطلبه عند كل إقلاع.
class NotificationPermissionService {
  static Future<void> handelNotification() async {
    if (Platform.isIOS) {
      await FirebaseNotificationService.instance.initialize(
        requestPermission: false,
      );
    }
    await sl<NotificationService>().setupNotificationActions();
  }
}
