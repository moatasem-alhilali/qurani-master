import 'package:quran_app/l10n/l10n.dart';

/// تاريخ هجري محسوب من التاريخ الميلادي بالمعادلة الفلكية الجدولية.
///
/// يُستخدم في عرض التاريخ الهجري داخل شاشات المواقيت، وفي تحديد شهر رمضان
/// لتطبيق تعديل العشاء الخاص بتقويم أم القرى.
class HijriDate {
  const HijriDate(this.day, this.month, this.year);

  factory HijriDate.fromDate(DateTime date) {
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
