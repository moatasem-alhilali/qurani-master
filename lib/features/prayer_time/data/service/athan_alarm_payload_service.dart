import 'dart:convert';

import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/l10n/l10n.dart';

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

  /// اسم الصلاة كمعرّف ثابت (عربي) يُخزَّن في حمولة الإشعار.
  ///
  /// لا يُعرض كما هو: [displayPrayerName] يحوّله إلى لغة الواجهة.
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

  static const List<String> _prayerKeys = [
    'fajr',
    'sunrise',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
    'jumuah',
  ];

  /// مفاتيح الصلوات (`fajr`…) من أسمائها بكل اللغات المدعومة.
  ///
  /// اسم الصلاة الذي يصل هنا قد يكون عربيًا (حمولات قديمة و[prayerNameFromKey])
  /// أو بلغة الواجهة وقت الجدولة (`PrayerInfoModel.name`)، ثم قد تتغيّر لغة
  /// الواجهة بعد ذلك — فنطابقه مع أسماء كل اللغات لا العربية وحدها.
  static final Map<String, String> _prayerKeyByName = () {
    final map = <String, String>{
      for (final key in _prayerKeys) key: key,
    };
    for (final language in AppLanguage.values) {
      final strings = L10nService.forCode(language.code);
      for (final key in _prayerKeys) {
        map.putIfAbsent(strings.prayerName(key).trim(), () => key);
      }
    }
    return map;
  }();

  /// المعرّف العام حين لا تُعرف الصلاة (انظر [prayerNameFromKey]).
  static const String _genericPrayerName = 'الصلاة';

  /// مفتاح الصلاة (`fajr`, `dhuhr`…) من اسمها المخزّن بأي لغة، أو `null`.
  static String? prayerKeyOf(String prayerName) {
    final trimmed = prayerName.trim();
    return _prayerKeyByName[trimmed] ?? _prayerKeyByName[trimmed.toLowerCase()];
  }

  /// اسم الصلاة بلغة الواجهة المحفوظة (أو [l10n] إن مُرِّرت).
  static String displayPrayerName(String prayerName, [L10n? l10n]) {
    final strings = l10n ?? L10nService.current;
    final trimmed = prayerName.trim();
    final key = prayerKeyOf(trimmed);
    if (key != null) return strings.prayerName(key);
    if (trimmed == _genericPrayerName ||
        AppLanguage.values.any(
          (language) =>
              L10nService.forCode(language.code).prayerTimeGenericPrayer ==
              trimmed,
        )) {
      return strings.prayerTimeGenericPrayer;
    }
    return trimmed;
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
    final l10n = L10nService.current;
    final displayName = displayPrayerName(prayerName, l10n);
    final cleanTime = _normalizeTimeLabel(prayerTimeLabel);
    if (cleanTime == null) {
      return l10n.prayerTimeAthanTitle(displayName);
    }
    return l10n.prayerTimeAthanTitleWithTime(displayName, cleanTime);
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
    final l10n = L10nService.current;
    switch (prayerKeyOf(prayerName)) {
      case 'fajr':
        return l10n.prayerTimeAthanBodyFajr;
      case 'dhuhr':
        return l10n.prayerTimeAthanBodyDhuhr;
      case 'asr':
        return l10n.prayerTimeAthanBodyAsr;
      case 'maghrib':
        return l10n.prayerTimeAthanBodyMaghrib;
      case 'isha':
        return l10n.prayerTimeAthanBodyIsha;
      default:
        return l10n.prayerTimeAthanBodyDefault;
    }
  }

  /// المتن الموسّع عند سحب الإشعار.
  ///
  /// لا يعيد المكان: النصّ المصاحب يظلّ ظاهرًا في الرأس عند التوسيع.
  String buildAthanExpandedBody({required String prayerName}) {
    return '${buildAthanBody(prayerName: prayerName)}\n'
        '${L10nService.current.prayerTimeAthanExpandedHint}';
  }

  /// نصّ شريط الحالة (ticker) لإشعار الأذان: «حان الآن أذان الظهر».
  String buildAthanTicker({required String prayerName}) {
    final l10n = L10nService.current;
    return l10n.prayerTimeAthanTicker(displayPrayerName(prayerName, l10n));
  }

  String? _normalizeTimeLabel(String? prayerTimeLabel) {
    final trimmed = prayerTimeLabel?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
