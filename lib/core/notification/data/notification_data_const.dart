import 'package:adhan/adhan.dart';
import 'package:quran_app/core/notification/base_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/time_notification_data_model.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';

/// ✅ Singleton + Seeder for notification data
/// Updated to work with the new unified notification system
class NotificationDataConstSeed {
  factory NotificationDataConstSeed() => _instance;
  NotificationDataConstSeed._internal();

  static final NotificationDataConstSeed _instance =
      NotificationDataConstSeed._internal();

  /// Middle night prayer notification data
  TimeNotificationDataModel get middleNight => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationMiddleNight,
        ),
        hour: _h('22:00'),
        minute: _m('22:00'),
        title: 'اشعارات النوافل',
        body: 'حان وقت الصلاة قيام اليل! قم وناجى الرحمن',
        sound: 'middlenight',
      );

  /// Morning thikr notification data
  TimeNotificationDataModel get thikrMorning => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationThikrMorning,
        ),
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار الصباح',
        sound: 'morning',
      );

  /// Night thikr notification data
  TimeNotificationDataModel get thikrNight => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationThikrNight,
        ),
        hour: _h('18:00'),
        minute: _m('18:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار المساء',
        sound: 'night',
      );

  /// Daily Quran reading notification data
  TimeNotificationDataModel get readQuran => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationReadQuran,
        ),
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'الورد القرآن',
        body: 'لاتنسى قراءة القرآن',
        sound: '',
      );

  /// Surah Al-Mulk reading notification data
  TimeNotificationDataModel get readSurahMulk => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationReadSurahMulk,
        ),
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'قراة سورة الملك',
        body: 'لا تنسى قراءة سورة الملك',
        sound: '',
      );

  /// Sleep thikr notification data
  TimeNotificationDataModel get thikrSleep => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationWridSleep,
        ),
        hour: _h('20:00'),
        minute: _m('20:00'),
        title: 'أذكار النوم',
        body: 'لا تنسى أذكار النوم قبل أن تغفو',
        sound: '',
      );

  /// Wake up thikr notification data
  TimeNotificationDataModel get thikrGetup => TimeNotificationDataModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationWridGetup,
        ),
        hour: _h('7:30'),
        minute: _m('7:30'),
        title: 'اذكار الاستيقاض',
        body: 'لا تنسى أذكار الاستيقاض',
        sound: '',
      );

  /// Prophet Mohammed prayer notification data
  RandomThikrMohammedNotificationModel get notificationMohummed =>
      const RandomThikrMohammedNotificationModel(
        title: 'الصلاة على النبي',
        body:
            'عن أنس بن مالك رضي الله عنه، قال: قال رسول الله صلى الله عليه وسلم: «من صلى عليّ صلاة واحدة صلى الله عليه بها عشرًا»',
        channel: NotificationChannel.mohammed,
      );

  /// Random thikr notifications with updated ID management
  List<RandomThikrNotificationModel> getRandomThikrNotifications() {
    return [
      RandomThikrNotificationModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAstgferAllh,
        ),
        channelId: 'astgfer_allh_id',
        channelName: 'astgfer allh name',
        title: 'استغفر الله',
        body:
            'استغفار الله يُذهب الهم والحزن وضيق الصدر ويدخل الفرح والسرور إلى القلب الناتج عن القرب من الله',
      ),
      RandomThikrNotificationModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationHasbnaAllh,
        ),
        channelId: 'hasbna_allh_id',
        channelName: 'hasbna allh name',
        title: 'حسبنا الله ونعم الوكيل',
        body: 'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم',
      ),
      RandomThikrNotificationModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationLahawlaWlaquoah,
        ),
        channelId: 'lahawla_wlaquoah_id',
        channelName: 'lahawla wlaquoah name',
        title: 'لا حول ولا قوة الا بالله العلي العظيم',
        body: 'كنز من كنوز الجنة',
      ),
      RandomThikrNotificationModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationSubhanAllh,
        ),
        channelId: 'subhan_allh_id',
        channelName: 'subhan allh name',
        title: 'سبحان الله والحمدلله ولا اله الا الله والله اكبر',
        body:
            'من قال حين يصبح وحين يمسي سبحان الله وبحمده مئة مرةٍ غفرت خطاياه وإن كانت مثل زبد البحر ',
      ),
    ];
  }

  /// Prayer info list with updated ID management using unified system
  List<PrayerInfoModel> prayerInfoListSeed(PrayerTimes times) {
    return [
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanFagr,
        ),
        type: Prayer.fajr,
        name: 'الفجر',
        description: 'اذان الفجر',
        time: times.fajr,
      ),
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanSunrise,
        ),
        type: Prayer.sunrise,
        name: 'الشروق',
        description: 'اذان الشروق',
        time: times.sunrise,
      ),
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanDuhr,
        ),
        type: Prayer.dhuhr,
        name: 'الظهر',
        description: 'اذان الظهر',
        time: times.dhuhr,
      ),
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanAsr,
        ),
        type: Prayer.asr,
        name: 'العصر',
        description: 'اذان العصر',
        time: times.asr,
      ),
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanMagrib,
        ),
        type: Prayer.maghrib,
        name: 'المغرب',
        description: 'اذان المغرب',
        time: times.maghrib,
      ),
      PrayerInfoModel(
        id: NotificationIdManager.generateNotificationId(
          NotificationKeys.isNotificationAthanIsha,
        ),
        type: Prayer.isha,
        name: 'العشاء',
        description: 'اذان العشاء',
        time: times.isha,
      ),
    ];
  }

  // 🧩 Helper methods for time parsing
  int _h(String time) => int.tryParse(time.split(':')[0]) ?? 0;
  int _m(String time) => int.tryParse(time.split(':')[1]) ?? 0;
}

// =====================================================================
// Legacy constants - deprecated in favor of new unified notification system
// These are kept for backward compatibility but should not be used in new code
// =====================================================================

@Deprecated(
  'Use NotificationDataConstSeed with unified NotificationIdManager instead',
)
class LegacyNotificationIds {
  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationMiddleNight")',
  )
  static const int middleNight = 101;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationThikrMorning")',
  )
  static const int thikrMorning = 102;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationThikrNight")',
  )
  static const int thikrNight = 103;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationReadQuran")',
  )
  static const int readQuran = 104;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationReadSurahMulk")',
  )
  static const int readSurahMulk = 105;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationWridSleep")',
  )
  static const int thikrSleep = 106;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationWridGetup")',
  )
  static const int thikrGetup = 107;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanFagr")',
  )
  static const int athanFajr = 200;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("athanSunrise")',
  )
  static const int athanSunrise = 201;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanDuhr")',
  )
  static const int athanDhuhr = 202;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanAsr")',
  )
  static const int athanAsr = 203;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanMagrib")',
  )
  static const int athanMaghrib = 204;

  @Deprecated(
    'Use NotificationIdManager.generateNotificationId("isNotificationAthanIsha")',
  )
  static const int athanIsha = 205;
}
