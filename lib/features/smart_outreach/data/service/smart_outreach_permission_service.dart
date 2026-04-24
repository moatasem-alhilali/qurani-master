import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class SmartOutreachPermissionSnapshot {
  const SmartOutreachPermissionSnapshot({
    required this.phone,
    required this.contacts,
    required this.notifications,
  });

  final PermissionStatus phone;
  final PermissionStatus contacts;
  final PermissionStatus notifications;

  bool get allGranted =>
      phone.isGranted &&
      contacts.isGranted &&
      (notifications.isGranted ||
          notifications.isLimited ||
          !_usesRuntimeNotificationPermission);

  bool get hasPermanentlyDenied =>
      phone.isPermanentlyDenied ||
      contacts.isPermanentlyDenied ||
      notifications.isPermanentlyDenied;

  List<String> get missingPermissionLabels {
    final labels = <String>[];

    if (!phone.isGranted) {
      labels.add('الاتصال');
    }
    if (!contacts.isGranted) {
      labels.add('جهات الاتصال');
    }
    if (_usesRuntimeNotificationPermission &&
        !notifications.isGranted &&
        !notifications.isLimited) {
      labels.add('الإشعارات');
    }

    return labels;
  }

  static bool get _usesRuntimeNotificationPermission =>
      Platform.isAndroid || Platform.isIOS;
}

class SmartOutreachPermissionService {
  Future<SmartOutreachPermissionSnapshot> getCurrentStatus() async {
    return SmartOutreachPermissionSnapshot(
      phone: await Permission.phone.status,
      contacts: await Permission.contacts.status,
      notifications: await Permission.notification.status,
    );
  }

  Future<SmartOutreachPermissionSnapshot> requestRequiredPermissions() async {
    await <Permission>[
      Permission.phone,
      Permission.contacts,
      Permission.notification,
    ].request();

    return getCurrentStatus();
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
