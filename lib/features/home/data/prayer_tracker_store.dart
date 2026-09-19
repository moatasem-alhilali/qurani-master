import 'package:adhan/adhan.dart';
import 'package:quran_app/core/cash/cache_service.dart';

/// الصلوات الخمس المفروضة بالترتيب. الشروق ليس منها فلا يُتتبَّع.
const kTrackedPrayers = <Prayer>[
  Prayer.fajr,
  Prayer.dhuhr,
  Prayer.asr,
  Prayer.maghrib,
  Prayer.isha,
];

/// تخزين «صليت / لم أصلِّ» ليوم واحد.
///
/// تُحفظ كخمسة أحرف `0`/`1` تحت مفتاح يحمل تاريخ اليوم، فلا حاجة لقاعدة
/// بيانات ولا لتهجير أي بيانات قديمة.
abstract final class PrayerTrackerStore {
  static const _prefix = 'prayer_tracker_';

  static String keyFor(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$_prefix${date.year}-$month-$day';
  }

  static bool isComplete(DateTime date) => read(date).every((done) => done);

  /// عدد الأيام المتتالية التي أُتمّت فيها الصلوات الخمس.
  ///
  /// إن لم يكتمل يوم اليوم بعدُ نبدأ العدّ من أمس، فاليوم الجاري لا يُسقط
  /// سلسلةً قائمة لمجرّد أن وقته لم ينتهِ.
  static int streak(DateTime today) {
    var cursor =
        isComplete(today) ? today : today.subtract(const Duration(days: 1));
    var count = 0;

    // سقف يحمي من حلقة لا تنتهي لو تلفت البيانات المخزّنة.
    while (count < 3650) {
      if (!isComplete(cursor)) break;
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  static List<bool> read(DateTime date) {
    final raw = CacheService().getString(keyFor(date)) ?? '';
    return List<bool>.generate(
      kTrackedPrayers.length,
      (index) => index < raw.length && raw[index] == '1',
    );
  }

  static Future<void> write(DateTime date, List<bool> value) {
    final raw = value.map((done) => done ? '1' : '0').join();
    return CacheService().setString(keyFor(date), raw);
  }
}
