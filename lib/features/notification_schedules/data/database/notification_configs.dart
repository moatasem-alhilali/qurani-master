import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/l10n/l10n.dart';

/// إعداد إشعار لمفتاح واحد. العنوان والنص يُترجمان بلغة التطبيق المحفوظة
/// لحظة القراءة، لأنهما يُمرَّران إلى الإشعارات المجدولة (بلا `BuildContext`).
class NotificationConfig {
  const NotificationConfig({
    required this.key,
    required this.channel,
  });
  final String key;
  final NotificationChannel channel;

  String get title => _title(L10nService.current);
  String get body => _body(L10nService.current);

  String _title(L10n l10n) {
    switch (key) {
      case NotificationKeys.isNotificationAllAthan:
        return l10n.notifSettingsLabelAllAthan;
      case NotificationKeys.isNotificationAthanFagr:
        return l10n.notifSettingsAthanOf(l10n.prayerFajr);
      case NotificationKeys.isNotificationAthanDuhr:
        return l10n.notifSettingsAthanOf(l10n.prayerDhuhr);
      case NotificationKeys.isNotificationAthanAsr:
        return l10n.notifSettingsAthanOf(l10n.prayerAsr);
      case NotificationKeys.isNotificationAthanMagrib:
        return l10n.notifSettingsAthanOf(l10n.prayerMaghrib);
      case NotificationKeys.isNotificationAthanIsha:
        return l10n.notifSettingsAthanOf(l10n.prayerIsha);
      case NotificationKeys.isNotificationMiddleNight:
        return l10n.notifSettingsLabelMiddleNight;
      case NotificationKeys.isNotificationThikrMorning:
        return l10n.notifSettingsLabelThikrMorning;
      case NotificationKeys.isNotificationThikrNight:
        return l10n.notifSettingsLabelThikrEvening;
      case NotificationKeys.isNotificationMohammed:
        return l10n.notifSettingsLabelSalawat;
      case NotificationKeys.isNotificationRandomThikr:
        return l10n.notifScheduleTitleRandomThikr;
      case NotificationKeys.isNotificationReadQuran:
        return l10n.notifSettingsLabelDailyQuranWird;
      case NotificationKeys.isNotificationReadSurahMulk:
        return l10n.notifSettingsLabelReadSurahMulk;
      case NotificationKeys.isNotificationWridSleep:
        return l10n.notifSettingsLabelThikrSleep;
      case NotificationKeys.isNotificationWridGetup:
        return l10n.notifSettingsLabelThikrWakeUp;
      case NotificationKeys.isNotificationReadSurah:
        return l10n.notifSettingsLabelReadSpecificSurah;
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return l10n.notifSettingsLabelReadSurahKahf;
      case NotificationKeys.isNotificationFasting:
        return l10n.notifSettingsLabelFasting;
      case NotificationKeys.isNotificationFastingMonday:
        return l10n.notifSettingsLabelFastingMonday;
      case NotificationKeys.isNotificationFastingThursday:
        return l10n.notifSettingsLabelFastingThursday;
      default:
        return key;
    }
  }

  String _body(L10n l10n) {
    switch (key) {
      case NotificationKeys.isNotificationAllAthan:
        return l10n.notifScheduleBodyAllAthan;
      case NotificationKeys.isNotificationAthanFagr:
        return l10n.notifScheduleBodyAthanFajr;
      case NotificationKeys.isNotificationAthanDuhr:
        return l10n.notifScheduleBodyAthanDhuhr;
      case NotificationKeys.isNotificationAthanAsr:
        return l10n.notifScheduleBodyAthanAsr;
      case NotificationKeys.isNotificationAthanMagrib:
        return l10n.notifScheduleBodyAthanMaghrib;
      case NotificationKeys.isNotificationAthanIsha:
        return l10n.notifScheduleBodyAthanIsha;
      case NotificationKeys.isNotificationMiddleNight:
        return l10n.notifScheduleBodyMiddleNight;
      case NotificationKeys.isNotificationThikrMorning:
        return l10n.notifScheduleBodyThikrMorning;
      case NotificationKeys.isNotificationThikrNight:
        return l10n.notifScheduleBodyThikrEvening;
      case NotificationKeys.isNotificationMohammed:
        return l10n.notifScheduleBodySalawat;
      case NotificationKeys.isNotificationRandomThikr:
        return l10n.notifSettingsBodyRememberAllah;
      case NotificationKeys.isNotificationReadQuran:
        return l10n.notifScheduleBodyReadQuran;
      case NotificationKeys.isNotificationReadSurahMulk:
        return l10n.notifScheduleBodyReadSurahMulk;
      case NotificationKeys.isNotificationWridSleep:
        return l10n.notifScheduleBodyThikrSleep;
      case NotificationKeys.isNotificationWridGetup:
        return l10n.notifScheduleBodyThikrWakeUp;
      case NotificationKeys.isNotificationReadSurah:
        return l10n.notifScheduleBodyReadSurah;
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return l10n.notifScheduleBodyReadSurahKahf;
      case NotificationKeys.isNotificationFasting:
        return l10n.notifScheduleBodyFasting;
      case NotificationKeys.isNotificationFastingMonday:
        return l10n.notifSettingsBodyFastingMonday;
      case NotificationKeys.isNotificationFastingThursday:
        return l10n.notifSettingsBodyFastingThursday;
      default:
        return key;
    }
  }
}

class NotificationConfigs {
  static const List<NotificationConfig> _all = [
    NotificationConfig(
      key: NotificationKeys.isNotificationAllAthan,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanFagr,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanDuhr,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanAsr,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanMagrib,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanIsha,
      channel: NotificationChannel.athan,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationMiddleNight,
      channel: NotificationChannel.middleNight,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationThikrMorning,
      channel: NotificationChannel.morning,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationThikrNight,
      channel: NotificationChannel.night,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationMohammed,
      channel: NotificationChannel.mohammed,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationRandomThikr,
      channel: NotificationChannel.randomThikr,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadQuran,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurahMulk,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationWridSleep,
      channel: NotificationChannel.sleep,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationWridGetup,
      channel: NotificationChannel.getUp,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurah,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurahAlkahf,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFasting,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFastingMonday,
      channel: NotificationChannel.defaultChannel,
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFastingThursday,
      channel: NotificationChannel.defaultChannel,
    ),
    // يمكن إضافة المزيد هنا...
  ];

  static NotificationConfig of(String key) => _all.firstWhere(
        (c) => c.key == key,
        orElse: () => throw Exception('NotificationConfig not found for $key'),
      );

  // إذا احتجت كل الكونفيجات دفعة واحدة
  static List<NotificationConfig> get all => _all;
}
