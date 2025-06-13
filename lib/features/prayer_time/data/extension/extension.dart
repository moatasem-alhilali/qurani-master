import 'package:adhan/adhan.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';

extension PrayerExtensions on Prayer {
  String get description {
    switch (this) {
      case Prayer.fajr:
        return 'صلاة الفجر خيرٌ من الدنيا وما فيها...';
      case Prayer.sunrise:
        return 'من صلى الشروق له أجر الحاج والمعتمر...';
      case Prayer.dhuhr:
        return 'من صلى الظهر تحرم عليه نفحات يوم القيامة...';
      case Prayer.asr:
        return 'من ترك صلاة العصر حبط عمله...';
      case Prayer.maghrib:
        return 'من يصلي المغرب حاضرًا لن يدخل النار...';
      case Prayer.isha:
        return 'العشاء نور في الدنيا ونور في الآخرة...';
      default:
        return '';
    }
  }

  String get imageAsset {
    switch (this) {
      case Prayer.fajr:
        return AssetsManager.subuh;
      case Prayer.sunrise:
        return AssetsManager.sunset;
      case Prayer.dhuhr:
        return AssetsManager.zhur;
      case Prayer.asr:
        return AssetsManager.asr;
      case Prayer.maghrib:
        return AssetsManager.magrib;
      case Prayer.isha:
        return AssetsManager.isyah;
      default:
        return '';
    }
  }
}
