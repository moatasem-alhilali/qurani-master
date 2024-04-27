//
import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/model/time_prayer_model.dart';

List<TimePrayerModel> prayerData = [
  TimePrayerModel(
    id: 200,
    image: AssetsManager.subuh,
    color: Colors.white,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[0].time12Hour,
    title: "الفجر",
    content: '''
 صلاة الفجر خيرٌ من الدنيا وما فيها
لقول النبي صلى الله عليه وسلم: «ركعتا الفجر خير من الدنيا وما فيها ” ركعتا الفجر خير من الدنيا وما فيها…. لهما أحب إلي من الدنيا جميعا»[3]ولذا لم يكن عليه الصلاة والسلام يدعها لا في الحضر ولا في السفر، ولا ريب أن أجر فريضة صلاة الفجر نفسها سيكون أعظم من سنيتها.
''',
  ),
  TimePrayerModel(
    id: 201,
    color: Colors.white,
    image: AssetsManager.sunset,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[1].time12Hour,
    title: "الشروق",
    content: '''
من صلى صلاة الشروق في وقتها بعد شروق الشمس فله مثل ثواب الحاج والمُعتمر. 
''',
  ),
  TimePrayerModel(
    id: 202,
    color: Colors.grey,
    image: AssetsManager.zhur,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[2].time12Hour,
    title: "الظهر",
    content: '''
من صلى الظهر تحرم عليه نفحات يوم القيامة

''',
  ),
  TimePrayerModel(
    id: 203,
    color: const Color.fromARGB(201, 221, 199, 3),
    image: AssetsManager.asr,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[3].time12Hour,
    title: "العصر",
    content: '''
من ترك صلاة العصر حبط عمله، وقال ﷺ: من فاتته صلاة العصر فكأنما وتر أهله وماله يعني: سلب أهله وماله
''',
  ),
  TimePrayerModel(
    id: 204,
    color: const Color.fromARGB(255, 233, 78, 12),
    image: AssetsManager.magrib,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[4].time12Hour,
    title: "المغرب",
    content: '''
من يُصلي المغرب حاضرًا لن يدخل النار. 
''',
  ),
  TimePrayerModel(
    id: 205,
    color: const Color.fromARGB(255, 3, 81, 144),
    image: AssetsManager.isyah,
    time: sl.get<PrayerTimesProvider>().prayerTimeList[5].time12Hour,
    title: "العشاء",
    content: '''
نورٌ للمسلم يوم القيامة، إضافةً إلى أنّها نورٌ له في حياته الدنيا. 
''',
  ),
];
