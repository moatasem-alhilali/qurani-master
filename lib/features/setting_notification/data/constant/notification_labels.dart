import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/l10n/l10n.dart';

/// أسماء إعدادات الإشعارات بلغة الواجهة.
///
/// الإعدادات تُزرع في قاعدة البيانات بحقل `label` عربي ثابت، ولا يتغيّر
/// بتغيّر اللغة. لذلك يُشتق الاسم المعروض من المفتاح الثابت [NotificationKeys]
/// عبر `L10n`، ويبقى الاسم المخزّن احتياطًا للمفاتيح غير المعروفة.
///
/// الأذكار التي يكون اسمها هو نصّ الذكر نفسه (استغفر الله، لا حول ولا قوة
/// إلا بالله، سبحان الله…) نصّ ديني يبقى عربيًا، فلا مفتاح لها هنا.
abstract final class NotificationLabels {
  /// اسم الإعداد المترجم، أو `null` إن لم يكن للمفتاح ترجمة.
  static String? labelFor(L10n l10n, String key) {
    switch (key) {
      case NotificationKeys.isNotify:
        return l10n.notifSettingsLabelAppNotifications;
      case NotificationKeys.isNotificationAllAthan:
        return l10n.notifSettingsLabelAllAthan;
      case NotificationKeys.isNotificationAthanFagr:
        return l10n.notifSettingsAthanOf(l10n.prayerFajr);
      case NotificationKeys.isNotificationAthanSunrise:
        return l10n.notifSettingsAthanOf(l10n.prayerSunrise);
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
      case NotificationKeys.isNotificationWridGetup:
        return l10n.notifSettingsLabelThikrWakeUp;
      case NotificationKeys.isNotificationWridSleep:
        return l10n.notifSettingsLabelThikrSleep;
      case NotificationKeys.isNotificationMohammed:
        return l10n.notifSettingsLabelSalawat;
      case NotificationKeys.isNotificationRandomThikr:
        return l10n.notifSettingsLabelRandomAudioThikr;
      case NotificationKeys.isNotificationFloatingAdhkar:
        return l10n.notifSettingsLabelFloatingAdhkar;
      case NotificationKeys.isNotificationReadQuran:
        return l10n.notifSettingsLabelDailyQuranWird;
      case NotificationKeys.isNotificationReadSurahMulk:
        return l10n.notifSettingsLabelReadSurahMulk;
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
      case NotificationKeys.isNotificationHasbnaAllh:
        return l10n.notifSettingsLabelBestDua;
      case NotificationKeys.isNotificationDailyWirdMorning:
        return l10n.notifSettingsLabelWirdMorning;
      case NotificationKeys.isNotificationDailyWirdEvening:
        return l10n.notifSettingsLabelWirdEvening;
      case NotificationKeys.isNotificationDailyWirdNight:
        return l10n.notifSettingsLabelWirdNight;
      case NotificationKeys.isNotificationDailyWirdSummary:
        return l10n.notifSettingsLabelWirdSummary;
      case NotificationKeys.isNotificationYoungMuslimResume:
        return l10n.notifSettingsLabelYoungMuslim;
      case NotificationKeys.isNotificationQuranPlan:
        return l10n.notifSettingsLabelQuranPlan;
      case NotificationKeys.isNotificationFirebaseGeneral:
        return l10n.notifSettingsLabelGeneral;
      default:
        return null;
    }
  }

  /// اسم الإعداد المعروض: المترجم إن وُجد، وإلا [fallback] (الاسم المخزّن).
  static String resolve(String key, {required String fallback, L10n? l10n}) {
    return labelFor(l10n ?? L10nService.current, key) ?? fallback;
  }
}
