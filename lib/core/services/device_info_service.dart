import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/device_sync/model/device_installation_payload.dart';
import 'package:quran_app/core/services/platform_device_id_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoService {
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  static const _fallbackDeviceIdKey = 'device_info_fallback_installation_id';
  static final DeviceInfoService _instance = DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final PlatformDeviceIdService _platformDeviceIdService =
      PlatformDeviceIdService();
  final Uuid _uuid = const Uuid();

  /// Returns a unified device payload, same structure for iOS/Android.
  Future<Map<String, dynamic>> getUnifiedDevicePayload() async {
    final installationId = await _getOrCreateFallbackInstallationId();
    final payload = await buildInstallationPayload(
      installationId: installationId,
      firstOpenedAt: DateTime.now().toUtc(),
    );
    return payload.toFirestoreData(
      pendingLaunches: 1,
      syncReason: 'legacy_payload',
    );
  }

  Future<DeviceInstallationPayload> buildInstallationPayload({
    required String installationId,
    required DateTime firstOpenedAt,
    String? cachedFcmToken,
  }) async {
    // 1. app info
    final packageInfo = await PackageInfo.fromPlatform();
    final timezoneName = await _safeTimezoneName();
    final localeTag = PlatformDispatcher.instance.locale.toLanguageTag();
    final notificationPermissionStatus =
        (await Permission.notification.status).name;

    // 2. prepare variables for all fields (same keys for both platforms)
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final platformDeviceId =
        await _platformDeviceIdService.getPlatformDeviceId();
    String? model;
    String? manufacturer;
    String? brand;
    String? osVersion;
    bool? isPhysicalDevice;
    String? systemName;
    String? deviceName;
    int? sdkInt;

    // 3. Device info
    if (Platform.isAndroid) {
      final android = await _deviceInfoPlugin.androidInfo;
      model = android.model;
      manufacturer = android.manufacturer;
      brand = android.brand;
      osVersion = android.version.release;
      sdkInt = android.version.sdkInt;
      isPhysicalDevice = android.isPhysicalDevice;
      systemName = 'Android';
      deviceName = android.name.isEmpty ? android.device : android.name;
    } else if (Platform.isIOS) {
      final ios = await _deviceInfoPlugin.iosInfo;
      model = ios.modelName;
      manufacturer = 'Apple';
      brand = ios.localizedModel;
      osVersion = ios.systemVersion;
      isPhysicalDevice = ios.isPhysicalDevice;
      systemName = ios.systemName;
      deviceName = ios.name;
    }

    // 4. FCM token (optional)
    final deviceToken = await _safeFcmToken() ?? cachedFcmToken;
    final deviceUniqueId = _normalizeDeviceId(
      rawId: platformDeviceId,
      platform: platform,
      installationId: installationId,
    );

    return DeviceInstallationPayload(
      deviceUniqueId: deviceUniqueId,
      installationId: installationId,
      platform: platform,
      deviceName: deviceName ?? '',
      model: model ?? '',
      manufacturer: manufacturer ?? '',
      brand: brand ?? '',
      systemName: systemName ?? '',
      osVersion: osVersion ?? '',
      sdkInt: sdkInt,
      isPhysicalDevice: isPhysicalDevice ?? false,
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      localeTag: localeTag,
      timezoneName: timezoneName,
      timezoneOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
      notificationPermissionStatus: notificationPermissionStatus,
      firstOpenedAt: firstOpenedAt,
      fcmToken: deviceToken,
    );
  }

  Future<String> getResolvedUniqueDeviceId({
    required String installationId,
  }) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final platformDeviceId =
        await _platformDeviceIdService.getPlatformDeviceId();
    return _normalizeDeviceId(
      rawId: platformDeviceId,
      platform: platform,
      installationId: installationId,
    );
  }

  Future<String> getDeviceId() async {
    final installationId = await _getOrCreateFallbackInstallationId();
    return getResolvedUniqueDeviceId(
      installationId: installationId,
    );
  }

  String _normalizeDeviceId({
    required String? rawId,
    required String platform,
    required String installationId,
  }) {
    final sanitized = rawId?.trim();
    if (sanitized == null || sanitized.isEmpty) {
      return '${platform}_$installationId';
    }
    return '${platform}_$sanitized';
  }

  Future<String?> _safeFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  Future<String> _safeTimezoneName() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return DateTime.now().timeZoneName;
    }
  }

  Future<String> _getOrCreateFallbackInstallationId() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_fallbackDeviceIdKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final fallbackId = _uuid.v4();
    await prefs.setString(_fallbackDeviceIdKey, fallbackId);
    return fallbackId;
  }
}
