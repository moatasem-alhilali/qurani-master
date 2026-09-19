import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/services/service_locator.dart';

/// حالة صلاحية كما تهمّ الواجهة.
enum AppPermissionState {
  granted,

  /// لم يُسأل بعد، أو رفض مرّة ويمكن سؤاله ثانية (أندرويد).
  askable,

  /// النظام لن يعرض الطلب مجدّدًا: الحلّ الوحيد إعدادات الجهاز.
  blocked,
}

/// نقطة واحدة لفحص صلاحيات الإشعارات والموقع وطلبها.
///
/// كان الطلب مبعثرًا: الرئيسية تطلب الموقع والإشعارات عند كل إقلاع، ومستودع
/// المواقيت يطلب الموقع مرّة أخرى، وتهيئة Firebase تطلب الإشعارات على iOS. الآن
/// يُطلب كلٌّ منها **مرّة واحدة** في شاشات البداية، وبعدها لا يُطلب إلا بضغطة
/// صريحة من المستخدم (تنبيه الرئيسية أو زرّ الموقع في بطاقة المواقيت).
abstract final class AppPermissions {
  static Future<AppPermissionState> notifications() async {
    if (kIsWeb) return AppPermissionState.granted;
    final status = await Permission.notification.status;
    return _fromHandler(status);
  }

  static Future<AppPermissionState> requestNotifications() async {
    if (kIsWeb) return AppPermissionState.granted;
    final status = await Permission.notification.request();
    return _fromHandler(status);
  }

  static Future<AppPermissionState> location() async {
    if (kIsWeb) return AppPermissionState.granted;
    return _fromGeolocator(await Geolocator.checkPermission());
  }

  static Future<AppPermissionState> requestLocation() async {
    if (kIsWeb) return AppPermissionState.granted;
    return _fromGeolocator(await Geolocator.requestPermission());
  }

  /// أندرويد 12+: بدون «المنبّهات والتذكيرات» يُجدول الأذان تقريبيًا وقد
  /// يتأخّر دقائق. منذ أندرويد 14 تكون مرفوضة افتراضيًا للتثبيتات الجديدة.
  static Future<bool> exactAlarmsAllowed() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    return sl<NotificationPermissionsService>().hasExactAlarmPermission();
  }

  /// يفتح صفحة «المنبّهات والتذكيرات» للتطبيق في إعدادات أندرويد.
  static Future<bool> requestExactAlarms() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    return sl<NotificationPermissionsService>().requestExactAlarmPermission();
  }

  static Future<bool> openSettings() => openAppSettings();

  static AppPermissionState _fromHandler(PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return AppPermissionState.granted;
    }
    // iOS: بعد أوّل رفض يعيد permission_handler الحالة permanentlyDenied،
    // وقبل السؤال denied — وهذا بالضبط ما نحتاجه.
    if (status.isPermanentlyDenied || status.isRestricted) {
      return AppPermissionState.blocked;
    }
    return AppPermissionState.askable;
  }

  static AppPermissionState _fromGeolocator(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return AppPermissionState.granted;
      case LocationPermission.deniedForever:
        return AppPermissionState.blocked;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return AppPermissionState.askable;
    }
  }
}
