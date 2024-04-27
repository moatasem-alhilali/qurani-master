// import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/setting/logic/manage_notification_controller.dart';
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
  id: 101,
  hour:
      int.parse(ManageNotification.timeRememberPrayerMiddleNight.split(':')[0]),
  minute:
      int.parse(ManageNotification.timeRememberPrayerMiddleNight.split(':')[1]),
  title: 'اشعارات النوافل',
  body: 'حان وقت الصلاة قيام اليل! قم وناجى الرحمن',
  sound: 'middlenight',
);

//!-------------------------الورد الصباحي------------------------
TimeNoti timesThikrMorningNotification = TimeNoti(
  id: 102,
  hour: int.parse(ManageNotification.timeRememberThikrMorning.split(':')[0]),
  minute: int.parse(ManageNotification.timeRememberThikrMorning.split(':')[1]),
  title: 'حان الوقت',
  body: 'حان موعد اذكار الصباح',
  sound: 'morning',
);

//!------------------------الورد المسائي------------------------
TimeNoti timesThikrNightNotification = TimeNoti(
  id: 103,
  hour: int.parse(ManageNotification.timeRememberThikrNight.split(':')[0]),
  minute: int.parse(ManageNotification.timeRememberThikrNight.split(':')[1]),
  title: 'حان الوقت',
  body: 'حان موعد اذكار المساء',
  sound: 'night',
);

//------------------------الورد القرأني ------------------------
TimeNoti timesReadQuranRoutineNotification = TimeNoti(
  id: 104,
  hour:
      int.parse(ManageNotification.timeRememberReadQuranRoutine.split(':')[0]),
  minute:
      int.parse(ManageNotification.timeRememberReadQuranRoutine.split(':')[1]),
  title: 'الورد القرآن',
  body: 'لاتنسى قراءة القرآن',
  sound: '',
);
//------------------------ سورة الملك------------------------
TimeNoti timesReadSurahAlMulkNotification = TimeNoti(
  id: 105,
  hour: int.parse(ManageNotification.timeRememberReadSurhAlMulk.split(':')[0]),
  minute:
      int.parse(ManageNotification.timeRememberReadSurhAlMulk.split(':')[1]),
  title: 'قراة سورة الملك',
  body: 'لا تنسى قراءة سورة الملك',
  sound: '',
);
//------------------------  أذكار النوم------------------------
TimeNoti timesThikrSleepNotification = TimeNoti(
  id: 106,
  hour: int.parse(ManageNotification.timeRememberThikrSleep.split(':')[0]),
  minute: int.parse(ManageNotification.timeRememberThikrSleep.split(':')[1]),
  title: 'أذكار النوم',
  body: '',
  sound: '',
);
//------------------------  أذكار الاستيقاض------------------------
TimeNoti timesThikrGetUpNotification = TimeNoti(
  id: 107,
  hour: int.parse(ManageNotification.timeRememberThikrGetUp.split(':')[0]),
  minute: int.parse(ManageNotification.timeRememberThikrGetUp.split(':')[1]),
  title: 'اذكار الاستيقاض',
  body: 'لا تنسى أذكار الاستيقاض',
  sound: '',
);


List<RandomThikrNotification> randomThikrNotification = [
  //استغفر الله

  RandomThikrNotification(
    channelId: 'astgfer_allh_id',
    channelName: 'astgfer allh name',
    body:
        "استغفار الله يُذهب الهم والحزن وضيق الصدر ويدخل الفرح والسرور إلى القلب الناتج عن القرب من الله",
    title: "استغفر الله",
    id: 108,
  ),
//حسبنا الله ونعم الوكيل

  RandomThikrNotification(
    channelId: 'hasbna_allh id',
    channelName: 'hasbna allh name',
    title: "حسبنا الله ونعم الوكيل",
    body: "أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم",
    id: 109,
  ),

//لا حول ولا قوة الا بالله

  RandomThikrNotification(
    channelId: 'lahawla_wlaquoah_id',
    channelName: 'lahawla wlaquoah name',
    title: "لا حول ولا قوة الا بالله العلي العظيم",
    body: "كنز من كنوز الجنة",
    id: 1010,
  ),
//سبحان الله

  RandomThikrNotification(
    channelId: 'subhan_allh_id',
    channelName: 'subhan allh name',
    title: "سبحان الله والحمدلله ولا اله الا الله والله اكبر",
    body:
        "من قال حين يصبح وحين يمسي سبحان الله وبحمده مئة مرةٍ غفرت خطاياه وإن كانت مثل زبد البحر ",
    id: 1011,
  ),
];
