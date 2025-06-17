import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';

Future<List<TimePrayerModel>> buildPrayerData() async {
  final prayerService = AdhanPrayerTimeService();
  final prayerTimes = await prayerService.getTodayPrayerTimes();

  return [
    TimePrayerModel(
      id: 200,
      type: Prayer.fajr,
      image: AssetsManager.subuh,
      color: Colors.white,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.fajr).time12,
      title: 'الفجر',
      content: '''
صلاة الفجر خيرٌ من الدنيا وما فيها
لقول النبي صلى الله عليه وسلم: «ركعتا الفجر خير من الدنيا وما فيها ” ركعتا الفجر خير من الدنيا جميعا»[3]ولذا لم يكن عليه الصلاة والسلام يدعها لا في الحضر ولا في السفر، ولا ريب أن أجر فريضة صلاة الفجر نفسها سيكون أعظم من سنيتها.
''',
    ),
    TimePrayerModel(
      id: 201,
      type: Prayer.sunrise,
      color: Colors.white,
      image: AssetsManager.sunset,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.sunrise).time12,
      title: 'الشروق',
      content: '''
من صلى صلاة الشروق في وقتها بعد شروق الشمس فله مثل ثواب الحاج والمُعتمر. 
''',
    ),
    TimePrayerModel(
      id: 202,
      type: Prayer.dhuhr,
      color: Colors.grey,
      image: AssetsManager.zhur,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.dhuhr).time12,
      title: 'الظهر',
      content: '''
من صلى الظهر تحرم عليه نفحات يوم القيامة
''',
    ),
    TimePrayerModel(
      id: 203,
      type: Prayer.asr,
      color: const Color.fromARGB(201, 221, 199, 3),
      image: AssetsManager.asr,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.asr).time12,
      title: 'العصر',
      content: '''
من ترك صلاة العصر حبط عمله، وقال ﷺ: من فاتته صلاة العصر فكأنما وتر أهله وماله يعني: سلب أهله وماله
''',
    ),
    TimePrayerModel(
      id: 204,
      type: Prayer.maghrib,
      color: const Color.fromARGB(255, 233, 78, 12),
      image: AssetsManager.magrib,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.maghrib).time12,
      title: 'المغرب',
      content: '''
من يُصلي المغرب حاضرًا لن يدخل النار. 
''',
    ),
    TimePrayerModel(
      id: 205,
      type: Prayer.isha,
      color: const Color.fromARGB(255, 3, 81, 144),
      image: AssetsManager.isyah,
      time: prayerTimes.firstWhere((p) => p.type == Prayer.isha).time12,
      title: 'العشاء',
      content: '''
نورٌ للمسلم يوم القيامة، إضافةً إلى أنّها نورٌ له في حياته الدنيا. 
''',
    ),
  ];
}
