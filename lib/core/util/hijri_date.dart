import 'package:hijri_core/hijri_core.dart' as hijri_core;
import 'package:quran_app/l10n/l10n.dart';

/// تاريخ هجري بتقويم أم القرى.
///
/// يُستخدم في عرض التاريخ الهجري داخل شاشات المواقيت، وفي تحديد شهر رمضان
/// لتطبيق تعديل العشاء.
///
/// **Why not the arithmetic formula.** This used to convert with the tabular
/// 30-year cycle, which approximates the calendar instead of reproducing it.
/// Measured against the Saudi High Judiciary Council calendar over 730 days,
/// it was wrong on 477 of them — 411 off by a day and 66 off by two. So the
/// date on the prayer screen was wrong two days out of three, and the Ramadan
/// boundary that drives the Isha adjustment moved with it.
///
/// Umm al-Qura is a published table of real month lengths, not a formula, so
/// it has to be looked up. `hijri_core` carries that table for 1356–1500 AH
/// and `test/core/hijri_date_test.dart` checks every day of it against the
/// official calendar.
class HijriDate {
  const HijriDate(this.day, this.month, this.year);

  /// يحوّل تاريخًا ميلاديًّا إلى ما يقابله في تقويم أم القرى.
  ///
  /// خارج مدى الجدول (1356–1500 هـ) يسقط على الحساب الجدولي بدل أن يرمي:
  /// تاريخٌ تقريبي أهون من شاشةِ مواقيتَ لا تُفتح.
  factory HijriDate.fromDate(DateTime date) {
    // The table is keyed by calendar day, so the time of day must not shift
    // it across a boundary.
    final converted = hijri_core.toHijri(
      DateTime.utc(date.year, date.month, date.day),
    );

    if (converted == null) {
      return HijriDate._tabular(date);
    }

    return HijriDate(converted.hd, converted.hm, converted.hy);
  }

  /// الحساب الجدولي القديم — احتياطٌ خارج مدى جدول أم القرى وحده.
  factory HijriDate._tabular(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    final julianDay = date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;

    var l = julianDay - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    return HijriDate(day, month, year);
  }

  final int day;
  final int month;
  final int year;

  /// ترتيب شهر رمضان في السنة الهجرية.
  static const int ramadanMonth = 9;

  /// أسماء الشهور بالعربية. للعرض في الواجهة استعمل [localizedMonthName].
  static const List<String> months = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  bool get isRamadan => month == ramadanMonth;

  String get monthName => months[(month - 1).clamp(0, months.length - 1)];

  /// التاريخ بالعربية دائمًا، مهما كانت لغة الواجهة. أُبقي للتوافق؛ للعرض في
  /// الواجهة استعمل [format].
  String formatArabic() => '$day $monthName $year هـ';

  /// اسم الشهر بلغة الواجهة: `hijri.localizedMonthName(context.l10n)`.
  String localizedMonthName(L10n l10n) => l10n.hijriMonth(month);

  /// التاريخ الهجري بلغة الواجهة: `hijri.format(context.l10n)`، أو
  /// `hijri.format(L10nService.current)` حيث لا يوجد `BuildContext`.
  String format(L10n l10n) => l10n.hijriDate(
        day.toString(),
        localizedMonthName(l10n),
        year.toString(),
      );
}
