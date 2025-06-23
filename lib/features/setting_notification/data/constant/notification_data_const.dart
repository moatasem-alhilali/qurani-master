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

  /// Example: Map key to notification ID (use NotificationIds class)
  static int resolveNotificationId(String key) {
    switch (key) {
   case NotificationKeys.isNotificationThikrMorning:
        return NotificationIds.thikrMorning;
      case NotificationKeys.isNotificationThikrNight:
        return NotificationIds.thikrNight;
      case NotificationKeys.isNotificationMiddleNight:
        return NotificationIds.middleNight;
      case NotificationKeys.isNotificationMohammed:
        return NotificationIds.mohammedPrayer;
      case NotificationKeys.isNotificationRandomThikr:
        return NotificationIds.randomThikr;
      case NotificationKeys.isNotificationReadQuran:
        return NotificationIds.readQuran;
      case NotificationKeys.isNotificationReadSurahMulk:
        return NotificationIds.readSurahMulk;
      case NotificationKeys.isNotificationWridSleep:
        return NotificationIds.thikrSleep;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationIds.thikrGetup;
      case NotificationKeys.isNotificationReadSurah:
        return NotificationIds.userScheduledThikr;
      case NotificationKeys.isNotificationReadSurahAlkahf:
        return NotificationIds.userScheduledThikr;
      case NotificationKeys.isNotificationFasting:
        return NotificationIds.userScheduledThikr;
      case NotificationKeys.isNotificationFastingMonday:
        return NotificationIds.userScheduledThikr;
      case NotificationKeys.isNotificationFastingThursday:
        return NotificationIds.userScheduledThikr;
      case NotificationKeys.isNotificationAthanFagr:
        return NotificationIds.athanFajr;
      case NotificationKeys.isNotificationAthanDuhr:
        return NotificationIds.athanDhuhr;
      case NotificationKeys.isNotificationAthanAsr:
        return NotificationIds.athanAsr;
      case NotificationKeys.isNotificationAthanMagrib:
        return NotificationIds.athanMaghrib;
      case NotificationKeys.isNotificationAthanIsha:
        return NotificationIds.athanIsha;
      case NotificationKeys.isNotificationAllAthan:
        return 210; // مجموعة الأذان (للجدولة/الحذف الجماعي فقط)
      default:
        return 99999;
    }
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
        return 'صلِّ على النبي ﷺ تسعد في يومك.';
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
      default:
        return key; // fallback
    }
  }
}

// This class provides centralized static notification IDs for all types of app notifications.
// It prevents accidental duplication and makes it easy to manage notification identifiers from a single place.

class NotificationIds {
  // Midnight prayer notification ID
  static const int middleNight = 101;

  // Morning Azkar notification ID
  static const int thikrMorning = 102;

  // Night Azkar notification ID
  static const int thikrNight = 103;

  // Daily Quran reading notification ID
  static const int readQuran = 104;

  // Surah Mulk reading notification ID
  static const int readSurahMulk = 105;

  // Sleep Azkar notification ID
  static const int thikrSleep = 106;

  // Wake-up Azkar notification ID
  static const int thikrGetup = 107;

  // Prayer Athan notification IDs (these match the order in your PrayerInfoModel list)
  static const int athanFajr = 200; // Fajr Athan
  static const int athanSunrise = 201; // Sunrise Athan
  static const int athanDhuhr = 202; // Dhuhr Athan
  static const int athanAsr = 203; // Asr Athan
  static const int athanMaghrib = 204; // Maghrib Athan
  static const int athanIsha = 205; // Isha Athan
  static const List<int> athanIds = [
    athanFajr,
    athanSunrise,
    athanDhuhr,
    athanAsr,
    athanMaghrib,
    athanIsha,
  ];
  // "Send Salawat on the Prophet" notification ID (recurring every hour in the day)
  // Usage: NotificationIds.mohammedPrayer(hour) -> 3001 = 1AM, 3023 = 11PM
  static const int mohammedPrayer = 3000;

  // Random Thikr notifications (used for repeated or user-scheduled Thikr)
  // Each scheduled random Thikr can use an index to avoid conflicts
  static const int randomThikr = 4000;

  // User-scheduled Thikr notifications, each gets its unique ID based on a user-controlled scheduleId
  static const int userScheduledThikr = 5000;

  // You can add more generators here for custom notifications as needed
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
}
