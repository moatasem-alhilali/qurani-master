import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();
  static final DeviceInfoService _instance = DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Returns a unified device payload, same structure for iOS/Android.
  Future<Map<String, dynamic>> getUnifiedDevicePayload() async {
    // 1. app info
    final packageInfo = await PackageInfo.fromPlatform();

    // 2. prepare variables for all fields (same keys for both platforms)
    final platform = Platform.isAndroid ? 'android' : 'ios';
    String? deviceId;
    String? model;
    String? manufacturer;
    String? osVersion;
    bool? isPhysicalDevice;
    String? systemName;
    String? deviceToken;

    // 3. Device info
    if (Platform.isAndroid) {
      final android = await _deviceInfoPlugin.androidInfo;
      deviceId = android.serialNumber;
      model = android.model;
      manufacturer = android.manufacturer;
      osVersion = android.version.release;
      isPhysicalDevice = android.isPhysicalDevice;
      systemName = 'Android';
    } else if (Platform.isIOS) {
      final ios = await _deviceInfoPlugin.iosInfo;
      deviceId = ios.identifierForVendor;
      model = ios.model;
      manufacturer = 'Apple';
      osVersion = ios.systemVersion;
      isPhysicalDevice = ios.isPhysicalDevice;
      systemName = ios.systemName;
    }

    // 4. FCM token (optional)
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (_) {
      deviceToken = null;
    }

    // 5. Build unified payload
    final payload = <String, dynamic>{
      'os': platform,
      'device_id': deviceId ?? '',
      'device_token': deviceToken ?? '',
      'model': model ?? '',
      'manufacturer': manufacturer ?? '',
      'system_name': systemName ?? '',
      'os_version': osVersion ?? '',
      'is_physical_device': isPhysicalDevice ?? false,
      'app_name': packageInfo.appName,
      'package_name': packageInfo.packageName,
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
    };

    return payload;
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.id ?? '';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.identifierForVendor ?? '';
    } else {
      // فلاتر ويب أو منصات أخرى
      return '';
    }
  }
}
