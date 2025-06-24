import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/data/notification_data_const.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';

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
        return NotificationChannel.randomThikr;
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
      case NotificationKeys.isNotificationReadSurah:
      case NotificationKeys.isNotificationReadSurahAlkahf:
      case NotificationKeys.isNotificationAstgferAllh:
      case NotificationKeys.isNotificationHasbnaAllh:
      case NotificationKeys.isNotificationLahawlaWlaquoah:
      case NotificationKeys.isNotificationSubhanAllh:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationWridSleep:
        return NotificationChannel.sleep;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationChannel.getUp;
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
  static String resolveTitle(String key) {
    final seeder = NotificationDataConstSeed();
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return seeder.thikrMorning.title;
      case NotificationKeys.isNotificationThikrNight:
        return seeder.thikrNight.title;
      case NotificationKeys.isNotificationMohammed:
        return seeder.notificationMohummed.title;
      case NotificationKeys.isNotificationRandomThikr:
        return 'ذكر عشوائي';
      case NotificationKeys.isNotificationReadQuran:
        return seeder.readQuran.title;
      case NotificationKeys.isNotificationReadSurahMulk:
        return seeder.readSurahMulk.title;
      case NotificationKeys.isNotificationMiddleNight:
        return seeder.middleNight.title;
      case NotificationKeys.isNotificationWridSleep:
        return seeder.thikrSleep.title;
      case NotificationKeys.isNotificationWridGetup:
        return seeder.thikrGetup.title;
      case NotificationKeys.isNotificationAllAthan:
        return 'أذان الصلاة';
      case NotificationKeys.isNotificationAthanFagr:
        return 'أذان الفجر';
      case NotificationKeys.isNotificationAthanDuhr:
        return 'أذان الظهر';
      case NotificationKeys.isNotificationAthanAsr:
        return 'أذان ا لعصر';
      case NotificationKeys.isNotificationAthanMagrib:
        return 'أذان المغرب';
      case NotificationKeys.isNotificationAthanIsha:
        return 'أذان العشاء';
      case NotificationKeys.isNotificationAthanSunrise:
        return 'أذان الشروق';

      default:
        return key;
    }
  }

  /// You can customize notification body per key
  static String resolveNotificationBody(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return 'لا تنس أذكار الصباح!';
      case NotificationKeys.isNotificationThikrNight:
        return 'لا تنس أذكار المساء!';
      case NotificationKeys.isNotificationMiddleNight:
        return 'حان وقت قيام الليل، استغل الثلث الأخير من الليل.';
      case NotificationKeys.isNotificationMohammed:
        return 'صلِّ على النبي ﷺ تسعد في يومك.';
      case NotificationKeys.isNotificationRandomThikr:
        return 'اذكر الله يذكرك!';
      case NotificationKeys.isNotificationReadQuran:
        return 'خصص وقتًا لوردك القرآني اليومي.';
      case NotificationKeys.isNotificationReadSurahMulk:
        return 'لا تنس قراءة سورة الملك الليلة.';
      case NotificationKeys.isNotificationWridSleep:
        return 'اذكار النوم قبل أن تغفو.';
      case NotificationKeys.isNotificationWridGetup:
        return 'ابدأ يومك بذكر الله بعد الاستيقاظ.';
      case NotificationKeys.isNotificationReadSurah:
        return 'لا تنس قراءة السورة التي اخترتها اليوم.';
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return 'لا تنس قراءة سورة الكهف في يوم الجمعة.';
      case NotificationKeys.isNotificationFasting:
        return 'تذكير بصيام التطوع.';
      case NotificationKeys.isNotificationFastingMonday:
        return 'تذكير بصيام يوم الاثنين.';
      case NotificationKeys.isNotificationFastingThursday:
        return 'تذكير بصيام يوم الخميس.';
      case NotificationKeys.isNotificationAllAthan:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        return 'حان الآن موعد الأذان.';
      case NotificationKeys.isNotificationAstgferAllh:
        return 'استغفر الله';
      case NotificationKeys.isNotificationHasbnaAllh:
        return 'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم';
      case NotificationKeys.isNotificationLahawlaWlaquoah:
        return 'لا حول ولا قوة الا بالله العلي العظيم';
      case NotificationKeys.isNotificationSubhanAllh:
        return 'سبحان الله والحمدلله ولا اله الا الله والله اكبر';
      case NotificationKeys.isNotificationAthanSunrise:
        return 'أذان الشروق';
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
}
