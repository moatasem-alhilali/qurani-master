//
import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/features/prayer_time/controllers/prayer_time_controller.dart';
import 'package:quran_app/features/prayer_time/model/time_prayer_model.dart';

List<TimePrayerModel> prayerData = [
  TimePrayerModel(
    id: 0,
    image: AssetsManager.subuh,
    color: Colors.white,
    time: fajr,
    title: "الفجر",
    content: '''
 صلاة الفجر خيرٌ من الدنيا وما فيها
لقول النبي صلى الله عليه وسلم: «ركعتا الفجر خير من الدنيا وما فيها ” ركعتا الفجر خير من الدنيا وما فيها…. لهما أحب إلي من الدنيا جميعا»[3]ولذا لم يكن عليه الصلاة والسلام يدعها لا في الحضر ولا في السفر، ولا ريب أن أجر فريضة صلاة الفجر نفسها سيكون أعظم من سنيتها.
''',
  ),
  TimePrayerModel(
    id: 1,
    color: Colors.white,
    image: AssetsManager.sunset,
    time: sunrise,
    title: "الشروق",
    content: '''
من صلى صلاة الشروق في وقتها بعد شروق الشمس فله مثل ثواب الحاج والمُعتمر. 
''',
  ),
  TimePrayerModel(
    id: 2,
    color: Colors.grey,
    image: AssetsManager.zhur,
    time: dhuhr,
    title: "الظهر",
    content: '''
من صلى الظهر تحرم عليه نفحات يوم القيامة

''',
  ),
  TimePrayerModel(
    id: 3,
    color: Color.fromARGB(201, 221, 199, 3),
    image: AssetsManager.asr,
    time: asr,
    title: "العصر",
    content: '''
من ترك صلاة العصر حبط عمله، وقال ﷺ: من فاتته صلاة العصر فكأنما وتر أهله وماله يعني: سلب أهله وماله
''',
  ),
  TimePrayerModel(
    id: 4,
    color: Color.fromARGB(255, 233, 78, 12),
    image: AssetsManager.magrib,
    time: maghrib,
    title: "المغرب",
    content: '''
من يُصلي المغرب حاضرًا لن يدخل النار. 
''',
  ),
  TimePrayerModel(
    id: 5,
    color: Color.fromARGB(255, 3, 81, 144),
    image: AssetsManager.isyah,
    time: isha,
    title: "العشاء",
    content: '''
نورٌ للمسلم يوم القيامة، إضافةً إلى أنّها نورٌ له في حياته الدنيا. 
''',
  ),
];
TimePrayerModel fagr_data = TimePrayerModel(
  id: 0,
  color: Colors.white,
  image: AssetsManager.subuh,
  time: fajr,
  title: "الفجر",
  content: '''
 صلاة الفجر خيرٌ من الدنيا وما فيها
لقول النبي صلى الله عليه وسلم: «ركعتا الفجر خير من الدنيا وما فيها ” ركعتا الفجر خير من الدنيا وما فيها…. لهما أحب إلي من الدنيا جميعا»[3]ولذا لم يكن عليه الصلاة والسلام يدعها لا في الحضر ولا في السفر، ولا ريب أن أجر فريضة صلاة الفجر نفسها سيكون أعظم من سنيتها.
''',
);
var zhur_data = TimePrayerModel(
  id: 1,
  color: Colors.grey,
  image: AssetsManager.zhur,
  time: dhuhr,
  title: "الظهر",
  content: '''
من صلى الظهر تحرم عليه نفحات يوم القيامة

''',
);
var asr_data = TimePrayerModel(
  id: 2,
  color: Colors.white,
  image: AssetsManager.asr,
  time: asr,
  title: "العصر",
  content: '''
من ترك صلاة العصر حبط عمله، وقال ﷺ: من فاتته صلاة العصر فكأنما وتر أهله وماله يعني: سلب أهله وماله
''',
);

var magrib_data = TimePrayerModel(
  id: 3,
  color: Colors.white,
  image: AssetsManager.magrib,
  time: maghrib,
  title: "المغرب",
  content: '''
من يُصلي المغرب حاضرًا لن يدخل النار. 
''',
);
var iysh_data = TimePrayerModel(
  id: 4,
  color: Colors.white,
  image: AssetsManager.isyah,
  time: isha,
  title: "العشاء",
  content: '''
نورٌ للمسلم يوم القيامة، إضافةً إلى أنّها نورٌ له في حياته الدنيا. 
''',
);
var sunset_data = TimePrayerModel(
  id: 5,
  color: Colors.white,
  image: AssetsManager.sunset,
  time: sunset,
  title: "الشروق",
  content: '''
من صلى صلاة الشروق في وقتها بعد شروق الشمس فله مثل ثواب الحاج والمُعتمر. 
''',
);
