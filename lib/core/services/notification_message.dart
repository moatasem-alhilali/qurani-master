// import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:quran_app/features/notification/controller/manage_notification_controller.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';

//model of data Notification
class TimeNoti {
  final int minute;
  final int hour;
  final String title;
  final String body;
  final String sound;
  final int id;
  TimeNoti({
    required this.hour,
    required this.minute,
    required this.body,
    required this.title,
    required this.id,
    required this.sound,
  });
}

//
class RandomThikrNotification {
  final String title;
  final String body;
  final String channelId;
  final String channelName;
  final int id;
  RandomThikrNotification({
    required this.channelId,
    required this.channelName,
    required this.body,
    required this.title,
    required this.id,
  });
}

//!-------------------------النوافل------------------------

TimeNoti timesPrayMiddleNightNotification = TimeNoti(
  id: 2,
  hour: int.parse(
      ManageNotificationController.timeRememberPrayerMiddleNight.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberPrayerMiddleNight.split(':')[1]),
  title: 'اشعارات النوافل',
  body: 'حان وقت الصلاة قيام اليل! قم وناجى الرحمن',
  sound: 'middlenight',
);

//!-------------------------الورد الصباحي------------------------
TimeNoti timesThikrMorningNotification = TimeNoti(
  id: 3,
  hour: int.parse(
      ManageNotificationController.timeRememberThikrMorning.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberThikrMorning.split(':')[1]),
  title: 'حان الوقت',
  body: 'حان موعد اذكار الصباح',
  sound: 'morning',
);

//!------------------------الورد المسائي------------------------
TimeNoti timesThikrNightNotification = TimeNoti(
  id: 4,
  hour: int.parse(
      ManageNotificationController.timeRememberThikrNight.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberThikrNight.split(':')[1]),
  title: 'حان الوقت',
  body: 'حان موعد اذكار المساء',
  sound: 'night',
);

//------------------------الورد القرأني ------------------------
TimeNoti timesReadQuranRoutineNotification = TimeNoti(
  id: 8,
  hour: int.parse(
      ManageNotificationController.timeRememberReadQuranRoutine.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberReadQuranRoutine.split(':')[1]),
  title: 'الورد القرآن',
  body: 'لاتنسى قراءة القرآن',
  sound: '',
);
//------------------------ سورة الملك------------------------
TimeNoti timesReadSurahAlMulkNotification = TimeNoti(
  id: 9,
  hour: int.parse(
      ManageNotificationController.timeRememberReadSurhAlMulk.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberReadSurhAlMulk.split(':')[1]),
  title: 'قراة سورة الملك',
  body: 'لا تنسى قراءة سورة الملك',
  sound: '',
);
//------------------------  أذكار النوم------------------------
TimeNoti timesThikrSleepNotification = TimeNoti(
  id: 10,
  hour: int.parse(
      ManageNotificationController.timeRememberThikrSleep.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberThikrSleep.split(':')[1]),
  title: 'أذكار النوم',
  body: '',
  sound: '',
);
//------------------------  أذكار الاستيقاض------------------------
TimeNoti timesThikrGetUpNotification = TimeNoti(
  id: 11,
  hour: int.parse(
      ManageNotificationController.timeRememberThikrGetUp.split(':')[0]),
  minute: int.parse(
      ManageNotificationController.timeRememberThikrGetUp.split(':')[1]),
  title: 'اذكار الاستيقاض',
  body: 'لا تنسى أذكار الاستيقاض',
  sound: '',
);
//------------------------اذان الفجر ------------------------
TimeNoti timesAthanAlfagarNotification = TimeNoti(
  id: 12,
  hour: int.parse(PrayerTime24Hour.prayFajr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayFajr.split(":")[1]),
  title: 'أذان الفجر',
  body: fagr_data.content,
  sound: 'athan',
);
//------------------------أذان الظهر ------------------------
TimeNoti timesAthanDuhrNotification = TimeNoti(
  id: 13,
  hour: int.parse(PrayerTime24Hour.prayDuhr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayDuhr.split(":")[1]),
  title: 'أذان الظهر',
  body: zhur_data.content,
  sound: 'athan',
);
//------------------------اذان العصر ------------------------
TimeNoti timesAthanAsrNotification = TimeNoti(
  id: 14,
  hour: int.parse(PrayerTime24Hour.prayAsr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayAsr.split(":")[1]),
  title: 'أذان العصر',
  body: asr_data.content,
  sound: 'athan',
);
//------------------------ اذان المغرب ------------------------
TimeNoti timesAthanMugribNotification = TimeNoti(
  id: 15,
  hour: int.parse(PrayerTime24Hour.prayMagrib.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayMagrib.split(":")[1]),
  title: ' أذان المغرب',
  body: magrib_data.content,
  sound: 'athan',
);
//------------------------ اذان العشاء ------------------------
TimeNoti timesAthanIshaNotification = TimeNoti(
  id: 16,
  hour: int.parse(PrayerTime24Hour.prayIsha.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayIsha.split(":")[1]),
  title: 'أذان العشاء',
  body: iysh_data.content,
  sound: 'athan',
);

//------------------------صلاة الفجر ------------------------
TimeNoti timesPrayFagrNotification = TimeNoti(
  id: 17,
  hour: int.parse(PrayerTime24Hour.prayFajr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayFajr.split(":")[1]) - 5,
  title: 'اقترب موعد صلاة الفجر',
  body: fagr_data.content,
  sound: '',
);
//------------------------ صلاة الظهر ------------------------
TimeNoti timesPrayDohurNotification = TimeNoti(
  id: 18,
  hour: int.parse(PrayerTime24Hour.prayDuhr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayDuhr.split(":")[1]) - 5,
  title: 'اقترب موعد صلاة الظهر ',
  body: zhur_data.content,
  sound: '',
);
//------------------------صلاة العصر ------------------------
TimeNoti timesPrayAsrNotification = TimeNoti(
  id: 19,
  hour: int.parse(PrayerTime24Hour.prayAsr.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayAsr.split(":")[1]) - 5,
  title: 'اقترب موعد صلاة العصر',
  body: asr_data.content,
  sound: '',
);
//------------------------  صلاة المغرب------------------------
TimeNoti timesPrayMagribNotification = TimeNoti(
  id: 20,
  hour: int.parse(PrayerTime24Hour.prayMagrib.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayMagrib.split(":")[1]) - 5,
  title: 'اقترب موعد صلاة المغرب',
  body: magrib_data.content,
  sound: '',
);

//------------------------ صلاة العشاء ------------------------
TimeNoti timesPrayIshaNotification = TimeNoti(
  id: 21,
  hour: int.parse(PrayerTime24Hour.prayIsha.split(":")[0]),
  minute: int.parse(PrayerTime24Hour.prayIsha.split(":")[1]) - 5,
  title: 'اقترب موعد صلاة العشاء',
  body: iysh_data.content,
  sound: '',
);

//

List<RandomThikrNotification> randomThikrNotification = [
  //استغفر الله

  RandomThikrNotification(
    channelId: 'astgfer_allh_id',
    channelName: 'astgfer allh name',
    body:
        "استغفار الله يُذهب الهم والحزن وضيق الصدر ويدخل الفرح والسرور إلى القلب الناتج عن القرب من الله",
    title: "استغفر الله",
    id: 23,
  ),
//حسبنا الله ونعم الوكيل

  RandomThikrNotification(
    channelId: 'hasbna_allh id',
    channelName: 'hasbna allh name',
    title: "حسبنا الله ونعم الوكيل",
    body: "أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم",
    id: 22,
  ),

//لا حول ولا قوة الا بالله

  RandomThikrNotification(
    channelId: 'lahawla_wlaquoah_id',
    channelName: 'lahawla wlaquoah name',
    title: "لا حول ولا قوة الا بالله العلي العظيم",
    body: "كنز من كنوز الجنة",
    id: 21,
  ),
//سبحان الله

  RandomThikrNotification(
    channelId: 'subhan_allh_id',
    channelName: 'subhan allh name',
    title: "سبحان الله والحمدلله ولا اله الا الله والله اكبر",
    body:
        "من قال حين يصبح وحين يمسي سبحان الله وبحمده مئة مرةٍ غفرت خطاياه وإن كانت مثل زبد البحر ",
    id: 20,
  ),
];
