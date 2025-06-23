import 'package:adhan/adhan.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/time_notification_data_model.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';

/// ✅ Singleton + Seeder
class NotificationDataConstSeed {
  factory NotificationDataConstSeed() => _instance;
  NotificationDataConstSeed._internal();

  static final NotificationDataConstSeed _instance =
      NotificationDataConstSeed._internal();

  //
  TimeNotificationDataModel get middleNight => TimeNotificationDataModel(
        id: 101,
        hour: _h('22:00'),
        minute: _m('22:00'),
        title: 'اشعارات النوافل',
        body: 'حان وقت الصلاة قيام اليل! قم وناجى الرحمن',
        sound: 'middlenight',
      );

  TimeNotificationDataModel get thikrMorning => TimeNotificationDataModel(
        id: 102,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار الصباح',
        sound: 'morning',
      );

  TimeNotificationDataModel get thikrNight => TimeNotificationDataModel(
        id: 103,
        hour: _h('18:00'),
        minute: _m('18:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار المساء',
        sound: 'night',
      );

  TimeNotificationDataModel get readQuran => TimeNotificationDataModel(
        id: 104,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'الورد القرآن',
        body: 'لاتنسى قراءة القرآن',
        sound: '',
      );

  TimeNotificationDataModel get readSurahMulk => TimeNotificationDataModel(
        id: 105,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'قراة سورة الملك',
        body: 'لا تنسى قراءة سورة الملك',
        sound: '',
      );

  TimeNotificationDataModel get thikrSleep => TimeNotificationDataModel(
        id: 106,
        hour: _h('20:00'),
        minute: _m('20:00'),
        title: 'أذكار النوم',
        body: '',
        sound: '',
      );

  TimeNotificationDataModel get thikrGetup => TimeNotificationDataModel(
        id: 107,
        hour: _h('7:30'),
        minute: _m('7:30'),
        title: 'اذكار الاستيقاض',
        body: 'لا تنسى أذكار الاستيقاض',
        sound: '',
      );

  //
  RandomThikrMohammedNotificationModel get notificationMohummed =>
      const RandomThikrMohammedNotificationModel(
        title: 'الصلاة على النبي',
        body:
            'عن أنس بن مالك رضي الله عنه، قال: قال رسول الله صلى الله عليه وسلم: «من صلى عليّ صلاة واحدة صلى الله عليه بها عشرًا»',
        channel: NotificationChannel.mohammed,
      );

  // 🟢 إشعارات الذكر العشوائي
  List<RandomThikrNotificationModel> getRandomThikrNotifications() {
    return const [
      RandomThikrNotificationModel(
        id: 108,
        channelId: 'astgfer_allh_id',
        channelName: 'astgfer allh name',
        title: 'استغفر الله',
        body:
            'استغفار الله يُذهب الهم والحزن وضيق الصدر ويدخل الفرح والسرور إلى القلب الناتج عن القرب من الله',
      ),
      RandomThikrNotificationModel(
        id: 109,
        channelId: 'hasbna_allh id',
        channelName: 'hasbna allh name',
        title: 'حسبنا الله ونعم الوكيل',
        body: 'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم',
      ),
      RandomThikrNotificationModel(
        id: 1010,
        channelId: 'lahawla_wlaquoah_id',
        channelName: 'lahawla wlaquoah name',
        title: 'لا حول ولا قوة الا بالله العلي العظيم',
        body: 'كنز من كنوز الجنة',
      ),
      RandomThikrNotificationModel(
        id: 1011,
        channelId: 'subhan_allh_id',
        channelName: 'subhan allh name',
        title: 'سبحان الله والحمدلله ولا اله الا الله والله اكبر',
        body:
            'من قال حين يصبح وحين يمسي سبحان الله وبحمده مئة مرةٍ غفرت خطاياه وإن كانت مثل زبد البحر ',
      ),
    ];
  }

  List<PrayerInfoModel> prayerInfoListSeed(PrayerTimes times) {
    return [
      PrayerInfoModel(
        id: 200,
        type: Prayer.fajr,
        name: 'الفجر',
        description: 'اذان الفجر',
        time: times.fajr,
      ),
      PrayerInfoModel(
        id: 201,
        type: Prayer.sunrise,
        name: 'الشروق',
        description: 'اذان الشروق',
        time: times.sunrise,
      ),
      PrayerInfoModel(
        id: 202,
        type: Prayer.dhuhr,
        name: 'الظهر',
        description: 'اذان الظهر',
        time: times.dhuhr,
      ),
      PrayerInfoModel(
        id: 203,
        type: Prayer.asr,
        name: 'العصر',
        description: 'اذان العصر',
        time: times.asr,
      ),
      PrayerInfoModel(
        id: 204,
        type: Prayer.maghrib,
        name: 'المغرب',
        description: 'اذان المغرب',
        time: times.maghrib,
      ),
      PrayerInfoModel(
        id: 205,
        type: Prayer.isha,
        name: 'العشاء',
        description: 'اذان العشاء',
        time: times.isha,
      ),
    ];
  }

  // 🧩 Helpers
  int _h(String time) => int.tryParse(time.split(':')[0]) ?? 0;
  int _m(String time) => int.tryParse(time.split(':')[1]) ?? 0;
}
