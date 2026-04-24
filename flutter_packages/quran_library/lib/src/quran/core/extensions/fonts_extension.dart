part of '/quran.dart';

/// Extension to handle font-related operations for the QuranCtrl class.
///
/// الخطوط تُحمّل ديناميكيًا عبر [QuranFontsService] من ملفات `.ttf.gz`
/// مضغوطة في الـ assets.
extension FontsExtension on QuranCtrl {
  /// يُرجع اسم عائلة الخط للصفحة المحددة (page1 .. page604).
  /// في الوضع الداكن مع التجويد يُرجع النسخة الداكنة (page1d .. page604d).
  String getFontPath(int pageIndex, {bool isDark = false}) {
    final withTajweed = state.isTajweedEnabled.value;
    if (withTajweed) {
      return isDark
          ? QuranFontsService.getDarkFontFamily(pageIndex)
          : QuranFontsService.getFontFamily(pageIndex);
    } else {
      return isDark
          ? QuranFontsService.getNoTajweedDarkFontFamily(pageIndex)
          : QuranFontsService.getNoTajweedFontFamily(pageIndex);
    }
  }

  /// يُرجع اسم عائلة الخط الأحمر لكلمات الخلاف (القراءات العشر).
  String getRedFontPath(int pageIndex) {
    return QuranFontsService.getRedFontFamily(pageIndex);
  }
}
