import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceInstallationPayload {
  const DeviceInstallationPayload({
    required this.deviceUniqueId,
    required this.installationId,
    required this.platform,
    required this.deviceName,
    required this.model,
    required this.manufacturer,
    required this.brand,
    required this.systemName,
    required this.osVersion,
    required this.sdkInt,
    required this.isPhysicalDevice,
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.buildNumber,
    required this.localeTag,
    required this.timezoneName,
    required this.timezoneOffsetMinutes,
    required this.notificationPermissionStatus,
    required this.firstOpenedAt,
    this.fcmToken,
  });

  final String deviceUniqueId;
  final String installationId;
  final String platform;
  final String deviceName;
  final String model;
  final String manufacturer;
  final String brand;
  final String systemName;
  final String osVersion;
  final int? sdkInt;
  final bool isPhysicalDevice;
  final String appName;
  final String packageName;
  final String appVersion;
  final String buildNumber;
  final String localeTag;
  final String timezoneName;
  final int timezoneOffsetMinutes;
  final String notificationPermissionStatus;
  final DateTime firstOpenedAt;
  final String? fcmToken;

  Map<String, dynamic> toFirestoreData({
    required int pendingLaunches,
    required String syncReason,
  }) {
    final data = <String, dynamic>{
      'deviceUniqueId': deviceUniqueId,
      'installationId': installationId,
      'platform': platform,
      'device': {
        'name': deviceName,
        'model': model,
        'manufacturer': manufacturer,
        'brand': brand,
        'systemName': systemName,
        'osVersion': osVersion,
        'sdkInt': sdkInt,
        'isPhysicalDevice': isPhysicalDevice,
      },
      'app': {
        'name': appName,
        'packageName': packageName,
        'version': appVersion,
        'buildNumber': buildNumber,
      },
      'userContext': {
        'locale': localeTag,
        'timezoneName': timezoneName,
        'timezoneOffsetMinutes': timezoneOffsetMinutes,
      },
      'notification': {
        'permissionStatus': notificationPermissionStatus,
        'fcmToken': fcmToken,
      },
      'usage': {
        'launchCount': FieldValue.increment(pendingLaunches),
        'firstOpenedAt': Timestamp.fromDate(firstOpenedAt),
      },
      'activity': {
        'lastSeenAt': FieldValue.serverTimestamp(),
        'lastSyncReason': syncReason,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final token = fcmToken?.trim();
    if (token != null && token.isNotEmpty) {
      final notificationData = Map<String, dynamic>.from(
        data['notification'] as Map<String, dynamic>,
      )..addAll({
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
          'tokenHistory': FieldValue.arrayUnion([token]),
        });
      data['notification'] = notificationData;
    }

    return data;
  }
}
