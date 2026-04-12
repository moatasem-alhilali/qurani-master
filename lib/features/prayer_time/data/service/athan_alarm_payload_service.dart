import 'dart:convert';

import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';

class AthanAlarmPayloadData {
  const AthanAlarmPayloadData({
    required this.key,
    required this.prayerName,
    this.prayerTimeLabel,
  });

  final String key;
  final String prayerName;
  final String? prayerTimeLabel;
}

class AthanAlarmPayloadService {
  static const String payloadType = 'athan_alarm';

  String buildPayload({
    required String key,
    required String prayerName,
    String? prayerTimeLabel,
  }) {
    return jsonEncode(<String, dynamic>{
      'type': payloadType,
      'key': key,
      'prayerName': prayerName,
      'prayerTime': prayerTimeLabel,
    });
  }

  AthanAlarmPayloadData? parsePayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      if ((decoded['type'] as String?)?.trim() != payloadType) {
        return null;
      }

      final key = (decoded['key'] as String?)?.trim();
      final prayerName = (decoded['prayerName'] as String?)?.trim();
      if (key == null ||
          key.isEmpty ||
          prayerName == null ||
          prayerName.isEmpty) {
        return null;
      }

      final prayerTimeLabel = (decoded['prayerTime'] as String?)?.trim();

      return AthanAlarmPayloadData(
        key: key,
        prayerName: prayerName,
        prayerTimeLabel: prayerTimeLabel,
      );
    } catch (_) {
      return null;
    }
  }

  bool isAthanKey(String key) {
    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        return true;
      default:
        return false;
    }
  }

  String prayerNameFromKey(String key) {
    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
        return 'الفجر';
      case NotificationKeys.isNotificationAthanDuhr:
        return 'الظهر';
      case NotificationKeys.isNotificationAthanAsr:
        return 'العصر';
      case NotificationKeys.isNotificationAthanMagrib:
        return 'المغرب';
      case NotificationKeys.isNotificationAthanIsha:
        return 'العشاء';
      default:
        return 'الصلاة';
    }
  }

  String buildAthanTitle({
    required String prayerName,
    String? prayerTimeLabel,
  }) {
    final cleanPrayerName = prayerName.trim();
    final cleanTime = _normalizeTimeLabel(prayerTimeLabel);
    if (cleanTime == null) {
      return 'أذان $cleanPrayerName';
    }
    return 'أذان $cleanPrayerName • $cleanTime';
  }

  String buildAthanBody({
    required String prayerName,
    String? prayerTimeLabel,
  }) {
    final cleanTime = _normalizeTimeLabel(prayerTimeLabel);
    final intro = cleanTime == null
        ? 'حان الآن وقت صلاة ${prayerName.trim()}.'
        : 'حان الآن وقت صلاة ${prayerName.trim()} عند $cleanTime.';

    switch (prayerName.trim()) {
      case 'الفجر':
        return '$intro حي على الصلاة • ابدأ يومك بنور الفجر.';
      case 'الظهر':
        return '$intro اجعلها استراحة قلب.';
      case 'العصر':
        return '$intro جدد حضورك مع الله.';
      case 'المغرب':
        return '$intro اختم يومك بطاعة وسكينة.';
      case 'العشاء':
        return '$intro لا تفوت ختام الصلوات.';
      default:
        return '$intro تقبل الله طاعتك.';
    }
  }

  String buildAthanExpandedBody({
    required String prayerName,
    String? prayerTimeLabel,
  }) {
    final cleanTime = _normalizeTimeLabel(prayerTimeLabel);
    final timeLine = cleanTime == null ? '' : 'موعد الصلاة: $cleanTime.\n';
    return '$timeLine${buildAthanBody(prayerName: prayerName, prayerTimeLabel: prayerTimeLabel)}\nاضغط لفتح تنبيه الصلاة والتفاصيل.';
  }

  String buildAthanSubText({
    required String prayerName,
    String? prayerTimeLabel,
  }) {
    final cleanTime = _normalizeTimeLabel(prayerTimeLabel);
    if (cleanTime != null) {
      return 'وقت $prayerName: $cleanTime';
    }
    return 'حان وقت صلاة $prayerName';
  }

  String? _normalizeTimeLabel(String? prayerTimeLabel) {
    final trimmed = prayerTimeLabel?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
