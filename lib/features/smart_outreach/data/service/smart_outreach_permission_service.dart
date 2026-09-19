import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/l10n/l10n.dart';

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
      (!_requiresPhonePermission || phone.isGranted) &&
      contacts.isGranted &&
      (notifications.isGranted ||
          notifications.isLimited ||
          !_usesRuntimeNotificationPermission);

  bool get hasPermanentlyDenied =>
      (_requiresPhonePermission && phone.isPermanentlyDenied) ||
      contacts.isPermanentlyDenied ||
      notifications.isPermanentlyDenied;

  List<String> get missingPermissionLabels {
    final l10n = L10nService.current;
    final labels = <String>[];

    if (_requiresPhonePermission && !phone.isGranted) {
      labels.add(l10n.outreachPermissionPhone);
    }
    if (!contacts.isGranted) {
      labels.add(l10n.outreachPermissionContacts);
    }
    if (_usesRuntimeNotificationPermission &&
        !notifications.isGranted &&
        !notifications.isLimited) {
      labels.add(l10n.outreachPermissionNotifications);
    }

    return labels;
  }

  static bool get _usesRuntimeNotificationPermission =>
      Platform.isAndroid || Platform.isIOS;

  static bool get _requiresPhonePermission => Platform.isAndroid;
}

class SmartOutreachPermissionService {
  Future<SmartOutreachPermissionSnapshot> getCurrentStatus() async {
    return SmartOutreachPermissionSnapshot(
      phone: Platform.isAndroid
          ? await Permission.phone.status
          : PermissionStatus.granted,
      contacts: await Permission.contacts.status,
      notifications: await Permission.notification.status,
    );
  }

  Future<SmartOutreachPermissionSnapshot> requestRequiredPermissions() async {
    final permissions = <Permission>[
      Permission.contacts,
      Permission.notification,
    ];

    if (Platform.isAndroid) {
      permissions.insert(0, Permission.phone);
    }

    await permissions.request();

    return getCurrentStatus();
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
