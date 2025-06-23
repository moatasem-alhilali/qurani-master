import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/main.dart';

/// Service to handle notification permissions with proper error handling
class NotificationPermissionsService {
  NotificationPermissionsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Check if all notification permissions are granted
  Future<NotificationPermissionStatus> checkPermissions() async {
    try {
      if (Platform.isAndroid) {
        return await _checkAndroidPermissions();
      } else if (Platform.isIOS) {
        return await _checkIOSPermissions();
      }

      return NotificationPermissionStatus.granted;
    } catch (e) {
      logger.e('Error checking notification permissions: $e');
      return NotificationPermissionStatus.unknown;
    }
  }

  /// Request all necessary notification permissions
  Future<NotificationPermissionResult> requestPermissions({
    bool showRationale = true,
  }) async {
    try {
      if (Platform.isAndroid) {
        return await _requestAndroidPermissions(showRationale: showRationale);
      } else if (Platform.isIOS) {
        return await _requestIOSPermissions();
      }

      return NotificationPermissionResult.granted;
    } catch (e) {
      logger.e('Error requesting notification permissions: $e');
      return NotificationPermissionResult.error;
    }
  }

  /// Check if exact alarm permission is granted (Android 12+)
  Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // This will check if the permission is granted
      // If not granted, it will return false
      return await androidPlugin?.canScheduleExactNotifications() ?? false;
    } catch (e) {
      logger.e('Error checking exact alarm permission: $e');
      return false;
    }
  }

  /// Request exact alarm permission (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final result = await androidPlugin?.requestExactAlarmsPermission();
      logger.d('Exact alarm permission request result: $result');
      return result ?? false;
    } catch (e) {
      logger.e('Error requesting exact alarm permission: $e');
      return false;
    }
  }

  /// Show a user-friendly dialog explaining why permissions are needed
  Future<bool> showPermissionRationale(
    BuildContext context, {
    String? customMessage,
  }) async {
    final message = customMessage ??
        'يحتاج التطبيق إلى إذن الإشعارات لتذكيرك بأوقات الصلاة والأذكار.\n'
            'هذا يساعدك على البقاء على اتصال مع تعاليم الإسلام طوال اليوم.';

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('إذن الإشعارات'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('ليس الآن'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('السماح'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Show settings dialog when permissions are permanently denied
  Future<void> showSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إعدادات الإشعارات'),
          content: const Text(
            'تم رفض إذن الإشعارات بشكل دائم.\n'
            'يرجى الذهاب إلى الإعدادات وتفعيل الإشعارات يدوياً.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('فتح الإعدادات'),
            ),
          ],
        );
      },
    );
  }

  // ================== Private Methods ==================

  Future<NotificationPermissionStatus> _checkAndroidPermissions() async {
    // Check notification permission (Android 13+)
    final notificationStatus = await Permission.notification.status;

    // Check if notifications are enabled in app settings
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final areEnabled = await androidPlugin?.areNotificationsEnabled() ?? false;

    // Check exact alarm permission
    final hasExactAlarm = await hasExactAlarmPermission();

    if (notificationStatus.isGranted && areEnabled && hasExactAlarm) {
      return NotificationPermissionStatus.granted;
    } else if (notificationStatus.isDenied || !areEnabled) {
      return NotificationPermissionStatus.denied;
    } else if (notificationStatus.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    } else if (!hasExactAlarm) {
      return NotificationPermissionStatus.partiallyGranted;
    }

    return NotificationPermissionStatus.unknown;
  }

  Future<NotificationPermissionStatus> _checkIOSPermissions() async {
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final permissions = await iosPlugin?.checkPermissions();

    if (permissions == null) {
      return NotificationPermissionStatus.unknown;
    }

    if (permissions.isEnabled) {
      return NotificationPermissionStatus.granted;
    } else {
      return NotificationPermissionStatus.denied;
    }
  }

  Future<NotificationPermissionResult> _requestAndroidPermissions({
    required bool showRationale,
  }) async {
    // Request notification permission
    var notificationStatus = await Permission.notification.status;

    if (notificationStatus.isDenied) {
      if (showRationale) {
        // Show rationale before requesting
        logger.d('Requesting notification permission with rationale');
      }

      notificationStatus = await Permission.notification.request();
    }

    if (notificationStatus.isPermanentlyDenied) {
      return NotificationPermissionResult.permanentlyDenied;
    }

    if (notificationStatus.isGranted) {
      // Also request exact alarm permission
      final exactAlarmGranted = await requestExactAlarmPermission();

      if (exactAlarmGranted) {
        return NotificationPermissionResult.granted;
      } else {
        return NotificationPermissionResult.partiallyGranted;
      }
    }

    return NotificationPermissionResult.denied;
  }

  Future<NotificationPermissionResult> _requestIOSPermissions() async {
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final result = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (result == true) {
      return NotificationPermissionResult.granted;
    } else {
      return NotificationPermissionResult.denied;
    }
  }
}

// ================== Enums ==================

enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  partiallyGranted, // Some permissions granted, others not
  unknown,
}

enum NotificationPermissionResult {
  granted,
  denied,
  permanentlyDenied,
  partiallyGranted,
  error,
}

// ================== Extensions ==================

extension NotificationPermissionStatusExtension
    on NotificationPermissionStatus {
  bool get isGranted => this == NotificationPermissionStatus.granted;
  bool get isDenied => this == NotificationPermissionStatus.denied;
  bool get isPermanentlyDenied =>
      this == NotificationPermissionStatus.permanentlyDenied;
  bool get isPartiallyGranted =>
      this == NotificationPermissionStatus.partiallyGranted;
  bool get isUnknown => this == NotificationPermissionStatus.unknown;

  String get description {
    switch (this) {
      case NotificationPermissionStatus.granted:
        return 'تم منح جميع الأذونات';
      case NotificationPermissionStatus.denied:
        return 'تم رفض أذونات الإشعارات';
      case NotificationPermissionStatus.permanentlyDenied:
        return 'تم رفض الأذونات بشكل دائم';
      case NotificationPermissionStatus.partiallyGranted:
        return 'تم منح بعض الأذونات فقط';
      case NotificationPermissionStatus.unknown:
        return 'حالة الأذونات غير معروفة';
    }
  }
}

extension NotificationPermissionResultExtension
    on NotificationPermissionResult {
  bool get isGranted => this == NotificationPermissionResult.granted;
  bool get isDenied => this == NotificationPermissionResult.denied;
  bool get isPermanentlyDenied =>
      this == NotificationPermissionResult.permanentlyDenied;
  bool get isPartiallyGranted =>
      this == NotificationPermissionResult.partiallyGranted;
  bool get isError => this == NotificationPermissionResult.error;

  String get description {
    switch (this) {
      case NotificationPermissionResult.granted:
        return 'تم منح جميع الأذونات بنجاح';
      case NotificationPermissionResult.denied:
        return 'تم رفض طلب الأذونات';
      case NotificationPermissionResult.permanentlyDenied:
        return 'تم رفض الأذونات بشكل دائم - يرجى الذهاب إلى الإعدادات';
      case NotificationPermissionResult.partiallyGranted:
        return 'تم منح بعض الأذونات - قد تحتاج لأذونات إضافية';
      case NotificationPermissionResult.error:
        return 'حدث خطأ أثناء طلب الأذونات';
    }
  }
}
