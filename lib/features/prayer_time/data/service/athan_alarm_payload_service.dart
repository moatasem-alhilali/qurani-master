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

  /// عنوان الإشعار: اسم الصلاة ووقتها.
  ///
  /// هذا هو الموضع **الوحيد** الذي يُذكر فيه الوقت. كان يتكرّر ثلاث مرّات —
  /// هنا، وفي النصّ المصاحب، وداخل المتن — فيقرأ المستخدم «11:48» ثلاثًا
  /// و«الظهر» ثلاثًا في إشعار من ثلاثة أسطر.
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

  /// النصّ المصاحب في رأس الإشعار: **مكان** الحساب.
  ///
  /// يشغل الموضع الذي كان يكرّر الوقت، فيضيف معلومة جديدة بدل إعادة القديمة:
  /// المستخدم يعرف على أيّ مدينة حُسبت المواقيت دون فتح التطبيق — وهذا يهمّ
  /// المسافر ومن ثبّت موقعه يدويًا.
  ///
  /// يعود بـ `null` إذا لم يكن هناك موقع محفوظ، فلا يُعرض سطر فارغ.
  String? buildAthanSubText({String? locationLabel}) {
    final trimmed = locationLabel?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  /// متن الإشعار: كلمة واحدة تخصّ الصلاة، بلا إعادة اسمها ولا وقتها.
  ///
  /// العنوان فوقه يقول «أذان الظهر • 11:48» بالفعل، فإعادتها هنا حشو.
  String buildAthanBody({required String prayerName}) {
    switch (prayerName.trim()) {
      case 'الفجر':
        return 'حيّ على الصلاة — ابدأ يومك بنور الفجر.';
      case 'الظهر':
        return 'اجعلها استراحة قلب.';
      case 'العصر':
        return 'جدّد حضورك مع الله.';
      case 'المغرب':
        return 'اختم يومك بطاعة وسكينة.';
      case 'العشاء':
        return 'لا تفوّت ختام الصلوات.';
      default:
        return 'تقبّل الله طاعتك.';
    }
  }

  /// المتن الموسّع عند سحب الإشعار.
  ///
  /// لا يعيد المكان: النصّ المصاحب يظلّ ظاهرًا في الرأس عند التوسيع.
  String buildAthanExpandedBody({required String prayerName}) {
    return '${buildAthanBody(prayerName: prayerName)}\n'
        'اضغط لفتح تنبيه الصلاة والتفاصيل.';
  }

  String? _normalizeTimeLabel(String? prayerTimeLabel) {
    final trimmed = prayerTimeLabel?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
