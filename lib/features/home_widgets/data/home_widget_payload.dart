import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/util/hijri_date.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_ids.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';

/// آية مرشّحة لودجت «آية اليوم».
class WidgetVerse {
  const WidgetVerse({required this.text, required this.source});

  final String text;
  final String source;
}

/// يبني بيانات الودجات كاملة — دالّة نقيّة بلا قراءة ولا كتابة.
///
/// ## المبدأ
///
/// الودجت **لا تعتمد على تشغيل التطبيق**. iOS يسمح بنحو 40–70 تحديثًا يوميًا
/// وأندرويد لا يحدّث تلقائيًا أسرع من كل 30 دقيقة، فلو اعتمدت على Flutter لكل
/// تغيير لتأخّرت الصلاة القادمة ساعات. لذلك تُحسب هنا مواقيت
/// [HomeWidgetIds.daysAhead] يومًا مقدّمًا، والكود الأصلي يختار منها بنفسه ما
/// يناسب الساعة الآن.
///
/// ## الوقت
///
/// `PrayerTimes.utcOffset` يُرجع أوقاتًا «UTC مزيّفة»: الساعة المقروءة هي توقيت
/// المدينة، لكن اللحظة مزاحة بفرقها. فكل وقت يُخزَّن مرّتين:
/// - `at`: اللحظة الحقيقية بالميلي ثانية، للمقارنة والعدّ التنازلي.
/// - `time`: النصّ المعروض بساعة المدينة، مُنسَّق هنا حتى يطابق التطبيق حرفيًا.
///
/// والتاريخ `date` مفتاح بأرقام لاتينية ثابتة `yyyy-MM-dd` — الكود الأصلي
/// يقارنه، فلا يجوز أن تُحوّله لغة الجهاز إلى أرقام عربية.
abstract final class HomeWidgetPayloadBuilder {
  static Map<String, Object?> build({
    required DateTime now,
    required PrayerLocationSelection? location,
    required PrayerCalculationSettings? settings,
    required List<WidgetVerse> versePool,
    List<Map<String, Object?>> previousVerses = const [],
    int days = HomeWidgetIds.daysAhead,
  }) {
    final offsetMinutes =
        location?.utcOffsetMinutes ?? now.timeZoneOffset.inMinutes;
    final offset = Duration(minutes: offsetMinutes);
    final locationNow = now.toUtc().add(offset);
    final firstDate =
        DateTime(locationNow.year, locationNow.month, locationNow.day);
    final dates = [
      for (var i = 0; i < days; i++)
        DateTime(firstDate.year, firstDate.month, firstDate.day + i),
    ];

    return <String, Object?>{
      'version': HomeWidgetIds.payloadVersion,
      'generatedAt': now.millisecondsSinceEpoch,
      'utcOffsetMinutes': offsetMinutes,
      'location': location?.qualifiedLabel,
      'days': location == null || settings == null
          ? const <Object?>[]
          : [
              for (final date in dates)
                _buildDay(date, location, settings, offset),
            ],
      'verses': _buildVerses(dates, versePool, previousVerses),
    };
  }

  static Map<String, Object?> _buildDay(
    DateTime date,
    PrayerLocationSelection location,
    PrayerCalculationSettings settings,
    Duration offset,
  ) {
    final times = PrayerTimes.utcOffset(
      Coordinates(location.latitude, location.longitude),
      DateComponents.from(date),
      PrayerCalculationParams.build(date: date, settings: settings),
      offset,
    );

    Map<String, Object?> prayer(
      String key,
      String name,
      DateTime shifted, {
      bool isPrayer = true,
    }) {
      return <String, Object?>{
        'key': key,
        'name': name,
        'at': wallClockToEpochMillis(shifted, offset),
        'time': formatWallClock(shifted),
        'isPrayer': isPrayer,
      };
    }

    return <String, Object?>{
      'date': dateKey(date),
      'weekday': DateFormat('EEEE', 'ar').format(date),
      'gregorian': DateFormat('d MMMM', 'ar').format(date),
      'hijri': HijriDate.fromDate(date).formatArabic(),
      'prayers': [
        prayer('fajr', 'الفجر', times.fajr),
        prayer('sunrise', 'الشروق', times.sunrise, isPrayer: false),
        prayer('dhuhr', 'الظهر', times.dhuhr),
        prayer('asr', 'العصر', times.asr),
        prayer('maghrib', 'المغرب', times.maghrib),
        prayer('isha', 'العشاء', times.isha),
      ],
    };
  }

  /// آية لكل يوم، **ثابتة لليوم نفسه** مهما تكرّرت المزامنة.
  ///
  /// كانت الودجت القديمة تبدّل الآية كل 30 دقيقة؛ هنا يُختار الفهرس من تجزئة
  /// التاريخ، فتبقى آية الأربعاء هي نفسها طوال الأربعاء.
  ///
  /// إن تعذّر تحميل المصحف (في الخلفية مثلًا) تُبقى آيات المزامنة السابقة
  /// للأيام التي لم تمضِ، بدل أن تُمسح.
  static List<Map<String, Object?>> _buildVerses(
    List<DateTime> dates,
    List<WidgetVerse> pool,
    List<Map<String, Object?>> previous,
  ) {
    if (pool.isEmpty) {
      final today = dateKey(dates.first);
      return [
        for (final verse in previous)
          if ((verse['date'] as String? ?? '').compareTo(today) >= 0) verse,
      ];
    }

    return [
      for (final date in dates)
        () {
          final key = dateKey(date);
          final verse = pool[stableIndex(key, pool.length)];
          return <String, Object?>{
            'date': key,
            'text': verse.text,
            'source': verse.source,
          };
        }(),
    ];
  }

  /// لحظة حقيقية من وقت «UTC مزيّف» ساعته هي توقيت المدينة.
  static int wallClockToEpochMillis(DateTime shifted, Duration offset) {
    return DateTime.utc(
      shifted.year,
      shifted.month,
      shifted.day,
      shifted.hour,
      shifted.minute,
      shifted.second,
    ).subtract(offset).millisecondsSinceEpoch;
  }

  /// «7:38 م» بساعة المدينة — التنسيق نفسه المستعمل في التطبيق.
  static String formatWallClock(DateTime shifted) {
    return DateFormat.jm('ar').format(
      DateTime(
        shifted.year,
        shifted.month,
        shifted.day,
        shifted.hour,
        shifted.minute,
      ),
    );
  }

  /// `yyyy-MM-dd` بأرقام لاتينية دائمًا، لا يمرّ على `DateFormat` ولغته.
  static String dateKey(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  /// فهرس ثابت عبر التشغيلات والإصدارات.
  ///
  /// `String.hashCode` في Dart غير مضمون الثبات بين إصدارات المحرّك، فتتغيّر آية
  /// اليوم بعد تحديث Flutter. FNV-1a بسيطة وحتمية.
  static int stableIndex(String key, int length) {
    var hash = 0x811c9dc5;
    for (final unit in key.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash % length;
  }

  /// أرقام عربية للعرض فقط (مصدر الآية).
  static String arabicDigits(String input) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(
      RegExp('[0-9]'),
      (match) => digits[int.parse(match[0]!)],
    );
  }
}
