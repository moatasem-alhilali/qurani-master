import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_labels.dart';
import 'package:quran_app/l10n/l10n.dart';

// This class manages notification settings and applies changes to the advanced notification scheduler
class NotificationDataConst {
  /// Example: Map key to notification channel
  static NotificationChannel resolveChannel(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return NotificationChannel.morning;
      case NotificationKeys.isNotificationThikrNight:
        return NotificationChannel.night;
      case NotificationKeys.isNotificationMiddleNight:
        return NotificationChannel.middleNight;
      case NotificationKeys.isNotificationMohammed:
        return NotificationChannel.mohammed;
      case NotificationKeys.isNotificationRandomThikr:
      case NotificationKeys.isNotificationFloatingAdhkar:
        return NotificationChannel.randomThikr;
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
      case NotificationKeys.isNotificationReadSurah:
      case NotificationKeys.isNotificationReadSurahAlkahf:
      case NotificationKeys.isNotificationDailyWirdSummary:
      case NotificationKeys.isNotificationYoungMuslimResume:
      case NotificationKeys.isNotificationQuranPlan:
      case NotificationKeys.isNotificationFirebaseGeneral:
      case NotificationKeys.isNotificationAstgferAllh:
      case NotificationKeys.isNotificationHasbnaAllh:
      case NotificationKeys.isNotificationLahawlaWlaquoah:
      case NotificationKeys.isNotificationSubhanAllh:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationWridSleep:
      case NotificationKeys.isNotificationDailyWirdNight:
        return NotificationChannel.sleep;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationChannel.getUp;
      case NotificationKeys.isNotificationDailyWirdMorning:
        return NotificationChannel.morning;
      case NotificationKeys.isNotificationDailyWirdEvening:
        return NotificationChannel.night;
      case NotificationKeys.isNotificationFasting:
      case NotificationKeys.isNotificationFastingMonday:
      case NotificationKeys.isNotificationFastingThursday:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
      case NotificationKeys.isNotificationAllAthan:
        return NotificationChannel.athan;
      default:
        return NotificationChannel.defaultChannel;
    }
  }

  /// Unified notification ID management using NotificationIdManager
  /// This replaces the hardcoded IDs with a unified system for better management
  static int resolveNotificationId(String key) {
    // Use the unified ID manager to generate consistent IDs based on keys
    return NotificationIdManager.generateNotificationId(key);
  }

  /// Some notifications (like random thikr) might schedule multiple notifications, so you may want to cancel a range
  static int? resolveIdRange(NotificationSettingModel setting) {
    switch (setting.key) {
      case NotificationKeys.isNotificationRandomThikr:
      case NotificationKeys.isNotificationFloatingAdhkar:
        // Allow up to 100 random thikr notifications per day
        return 100;
      case NotificationKeys.isNotificationMohammed:
        // Allow up to 24 hourly notifications per day
        return 24;
      case NotificationKeys.isNotificationAllAthan:
        // Allow up to 5 athan notifications per day
        return 5;
      case NotificationKeys.isNotificationThikrMorning:
      case NotificationKeys.isNotificationThikrNight:
      case NotificationKeys.isNotificationMiddleNight:
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
      case NotificationKeys.isNotificationWridSleep:
      case NotificationKeys.isNotificationWridGetup:
      case NotificationKeys.isNotificationReadSurah:
      case NotificationKeys.isNotificationReadSurahAlkahf:
      case NotificationKeys.isNotificationFasting:
      case NotificationKeys.isNotificationFastingMonday:
      case NotificationKeys.isNotificationFastingThursday:
      case NotificationKeys.isNotificationDailyWirdMorning:
      case NotificationKeys.isNotificationDailyWirdEvening:
      case NotificationKeys.isNotificationDailyWirdNight:
      case NotificationKeys.isNotificationDailyWirdSummary:
      case NotificationKeys.isNotificationYoungMuslimResume:
      case NotificationKeys.isNotificationQuranPlan:
      case NotificationKeys.isNotificationFirebaseGeneral:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        // Single notification per day
        return 1;
      default:
        return null;
    }
  }

  /// جلب عنوان الإشعار الافتراضي حسب المفتاح (لو ما كان معرف)
  ///
  /// يُترجم بلغة التطبيق المحفوظة، فيُستدعى بلا `BuildContext`.
  static String resolveTitle(String key) {
    final l10n = L10nService.current;
    switch (key) {
      case NotificationKeys.isNotificationRandomThikr:
        return l10n.notifSettingsTitleRandomThikr;
      case NotificationKeys.isNotificationFloatingAdhkar:
        return l10n.notifSettingsTitleFloatingAdhkar;
      case NotificationKeys.isNotificationAllAthan:
        return l10n.notifSettingsTitlePrayerAthan;
      default:
        return NotificationLabels.labelFor(l10n, key) ?? key;
    }
  }

  /// You can customize notification body per key
  ///
  /// نصوص التذكير تُترجم؛ أمّا الأذكار المقتبسة (استغفر الله، لا حول ولا قوة
  /// إلا بالله، سبحان الله…) فتبقى عربية كما هي.
  static String resolveNotificationBody(String key) {
    final l10n = L10nService.current;
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return l10n.notifSettingsBodyThikrMorning;
      case NotificationKeys.isNotificationThikrNight:
        return l10n.notifSettingsBodyThikrEvening;
      case NotificationKeys.isNotificationMiddleNight:
        return l10n.notifSettingsBodyMiddleNight;
      case NotificationKeys.isNotificationMohammed:
        return l10n.notifSettingsBodySalawat;
      case NotificationKeys.isNotificationRandomThikr:
      case NotificationKeys.isNotificationFloatingAdhkar:
        return l10n.notifSettingsBodyRememberAllah;
      case NotificationKeys.isNotificationReadQuran:
        return l10n.notifSettingsBodyReadQuran;
      case NotificationKeys.isNotificationReadSurahMulk:
        return l10n.notifSettingsBodyReadSurahMulk;
      case NotificationKeys.isNotificationWridSleep:
        return l10n.notifSettingsBodyThikrSleep;
      case NotificationKeys.isNotificationWridGetup:
        return l10n.notifSettingsBodyThikrWakeUp;
      case NotificationKeys.isNotificationReadSurah:
        return l10n.notifSettingsBodyReadSurah;
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return l10n.notifSettingsBodyReadSurahKahf;
      case NotificationKeys.isNotificationFasting:
        return l10n.notifSettingsBodyFasting;
      case NotificationKeys.isNotificationFastingMonday:
        return l10n.notifSettingsBodyFastingMonday;
      case NotificationKeys.isNotificationFastingThursday:
        return l10n.notifSettingsBodyFastingThursday;
      case NotificationKeys.isNotificationAllAthan:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        return l10n.notifSettingsBodyAthanTime;
      // نصوص أذكار: تبقى عربية.
      case NotificationKeys.isNotificationAstgferAllh:
        return 'استغفر الله';
      case NotificationKeys.isNotificationHasbnaAllh:
        return l10n.notifSettingsLabelBestDua;
      case NotificationKeys.isNotificationLahawlaWlaquoah:
        return 'لا حول ولا قوة الا بالله العلي العظيم';
      case NotificationKeys.isNotificationSubhanAllh:
        return 'سبحان الله والحمدلله ولا اله الا الله والله اكبر';
      case NotificationKeys.isNotificationAthanSunrise:
        return l10n.notifSettingsAthanOf(l10n.prayerSunrise);
      case NotificationKeys.isNotificationDailyWirdMorning:
        return l10n.notifSettingsBodyWirdMorning;
      case NotificationKeys.isNotificationDailyWirdEvening:
        return l10n.notifSettingsBodyWirdEvening;
      case NotificationKeys.isNotificationDailyWirdNight:
        return l10n.notifSettingsBodyWirdNight;
      case NotificationKeys.isNotificationDailyWirdSummary:
        return l10n.notifSettingsBodyWirdSummary;
      case NotificationKeys.isNotificationYoungMuslimResume:
        return l10n.notifSettingsBodyYoungMuslim;
      case NotificationKeys.isNotificationQuranPlan:
        return l10n.notifSettingsBodyQuranPlan;
      case NotificationKeys.isNotificationFirebaseGeneral:
        return l10n.notifSettingsBodyGeneral;
      default:
        return key; // fallback
    }
  }
}

// =====================================================================
// Legacy NotificationIds class - kept for backward compatibility
// New implementations should use NotificationIdManager.generateNotificationId(key)
// =====================================================================

class NotificationIds {
  // Legacy ID constants - these are now managed by NotificationIdManager
  // but kept for any existing code that might reference them directly

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationMiddleNight") instead',
  )
  static const int middleNight = 101;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationThikrMorning") instead',
  )
  static const int thikrMorning = 102;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationThikrNight") instead',
  )
  static const int thikrNight = 103;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationReadQuran") instead',
  )
  static const int readQuran = 104;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationReadSurahMulk") instead',
  )
  static const int readSurahMulk = 105;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationWridSleep") instead',
  )
  static const int thikrSleep = 106;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationWridGetup") instead',
  )
  static const int thikrGetup = 107;

  // Prayer Athan notification IDs
  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanFagr") instead',
  )
  static const int athanFajr = 200;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("athanSunrise") instead',
  )
  static const int athanSunrise = 201;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanDuhr") instead',
  )
  static const int athanDhuhr = 202;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanAsr") instead',
  )
  static const int athanAsr = 203;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanMagrib") instead',
  )
  static const int athanMaghrib = 204;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanIsha") instead',
  )
  static const int athanIsha = 205;

  @Deprecated('Use NotificationIdManager with individual athan keys instead')
  static const List<int> athanIds = [
    athanFajr,
    athanSunrise,
    athanDhuhr,
    athanAsr,
    athanMaghrib,
    athanIsha,
  ];

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationMohammed") instead',
  )
  static const int mohammedPrayer = 3000;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationRandomThikr") instead',
  )
  static const int randomThikr = 4000;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId with specific keys instead',
  )
  static const int userScheduledThikr = 5000;
}

class NotificationKeys {
  static const athanKeys = [
    NotificationKeys.isNotificationAthanFagr,
    NotificationKeys.isNotificationAthanDuhr,
    NotificationKeys.isNotificationAthanAsr,
    NotificationKeys.isNotificationAthanMagrib,
    NotificationKeys.isNotificationAthanIsha,
  ];

  /// تفعيل جميع الإشعارات
  static const isNotify = 'ISNOTIFY';

  /// إشعارات الأذان
  static const isNotificationAllAthan = 'isNotificationAllAthan';

  /// إشعارات الأذان الفجر
  static const isNotificationAthanFagr = 'isNotificationAthanFagr';

  /// إشعارات الأذان الشروق
  static const isNotificationAthanSunrise = 'isNotificationAthanSunrise';

  /// إشعارات الأذان الظهر
  static const isNotificationAthanDuhr = 'isNotificationAthanDuhr';

  /// إشعارات الأذان العصر
  static const isNotificationAthanAsr = 'isNotificationAthanAsr';

  /// إشعارات الأذان المغرب
  static const isNotificationAthanMagrib = 'isNotificationAthanMagrib';

  /// إشعارات الأذان العشاء
  static const isNotificationAthanIsha = 'isNotificationAthanIsha';

  /// إشعارات الأذان المنتصف الليل
  static const isNotificationMiddleNight = 'isNotificationMiddleNight';

  /// إشعارات الأذكار الصباح
  static const isNotificationThikrMorning = 'isNotificationThikrMorning';

  /// إشعارات الأذكار الليل
  static const isNotificationThikrNight = 'isNotificationThikrNight';

  /// إشعارات الصلاة على محمد ﷺ
  static const isNotificationMohammed = 'isNotificationMohammed';

  /// إشعارات الأذكار العشوائية
  static const isNotificationRandomThikr = 'isNotificationRandomThikr';

  static const isNotificationFloatingAdhkar = 'isNotificationFloatingAdhkar';

  /// إشعارات القراءة القرآنية اليومية
  static const isNotificationReadQuran = 'isNotificationReadQuran';

  /// إشعارات قراءة سورة الملك
  static const isNotificationReadSurahMulk = 'isNotificationReadSurahMulk';

  /// إشعارات النوم
  static const isNotificationWridSleep = 'isNotificationWridSleep';

  /// إشعارات القراءة القرآنية اليومية
  static const isNotificationWridGetup = 'isNotificationWridGetup';

  /// إشعارات قراءة سورة الملك
  static const isNotificationReadSurah = 'isNotificationReadSurah';

  /// إشعارات قراءة سورة الكهف
  static const isNotificationReadSurahAlkahf = 'isNotificationReadSurahAlkahf';

  /// إشعارات الصوم
  static const isNotificationFasting = 'isNotificationFasting';

  /// إشعارات الصوم الاثنين
  static const isNotificationFastingMonday = 'isNotificationFastingMonday';

  /// إشعارات الصوم الخميس
  static const isNotificationFastingThursday = 'isNotificationFastingThursday';

  /// إشعارات الأذكار العشوائية
  static const isNotificationAstgferAllh = 'isNotificationAstgferAllh';

  /// إشعارات الأذكار العشوائية
  static const isNotificationHasbnaAllh = 'isNotificationHasbnaAllh';

  /// إشعارات الأذكار العشوائية
  static const isNotificationLahawlaWlaquoah = 'isNotificationLahawlaWlaquoah';

  /// إشعارات الأذكار العشوائية
  static const isNotificationSubhanAllh = 'isNotificationSubhanAllh';

  static const isNotificationDailyWirdMorning =
      'isNotificationDailyWirdMorning';
  static const isNotificationDailyWirdEvening =
      'isNotificationDailyWirdEvening';
  static const isNotificationDailyWirdNight = 'isNotificationDailyWirdNight';
  static const isNotificationDailyWirdSummary =
      'isNotificationDailyWirdSummary';
  static const isNotificationYoungMuslimResume =
      'isNotificationYoungMuslimResume';
  static const isNotificationQuranPlan = 'isNotificationQuranPlan';
  static const isNotificationFirebaseGeneral = 'isNotificationFirebaseGeneral';
}
