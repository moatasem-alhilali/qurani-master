part of '/quran.dart';

const rtlLang = [
  'العربية',
  'עברית',
  'فارسی',
  'اردو',
  'کوردی',
];

extension StringExtension on String {
  /// تحقق من كون النص يحتوي على أحرف عربية أو فارسية أو عبرية
  /// Check if text contains Arabic, Persian, or Hebrew characters
  bool _containsRtlCharacters() {
    // نطاق الأحرف العربية والفارسية والعبرية
    final rtlRange = RegExp(
        r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]');
    return rtlRange.hasMatch(this);
  }

  /// تحقق من كون النص يبدأ بكلمة "تفسير" أو يحتوي على كلمات مفاتيح عربية
  /// Check if text starts with "tafsir" or contains Arabic keywords
  bool _isArabicIslamicText() {
    final arabicKeywords = [
      'تفسير',
      'تفسیر',
      'تفسير',
      'اللباب',
      'البحر',
      'الطبري',
      'القرطبي',
      'البغوي',
      'الجلالين',
      'البيضاوي',
      'النسفي',
      'السعدي',
      'كثير',
      'عطية',
      'البسيط',
      'الوسيط',
      'السمعاني',
      'الثعالبي',
      'أبي زمنين',
      'جُزَيّ',
      '(UR)',
    ];

    return arabicKeywords.any((keyword) => contains(keyword));
  }

  /// الكشف الذكي عن اللغات والنصوص العربية
  /// Smart detection for RTL languages and Arabic texts
  bool isRtlLanguage() {
    // إذا كان النص في القائمة المحددة مسبقاً
    if (rtlLang.contains(this)) return true;

    // إذا كان نصاً إسلامياً باللغة العربية
    if (_isArabicIslamicText()) return true;

    // إذا كان أكثر من 70% من النص يحتوي على أحرف RTL
    if (length > 0) {
      final rtlCharCount =
          split('').where((char) => char._containsRtlCharacters()).length;
      final rtlPercentage = rtlCharCount / length;
      if (rtlPercentage > 0.7) return true;
    }

    // إذا كان يحتوي على أحرف عربية أو فارسية أو عبرية
    return _containsRtlCharacters();
  }

  bool isRtlLanguageWPassLang(String language) {
    return language.isRtlLanguage();
  }
}

/// Extension on [BuildContext] to provide additional utility methods.
extension ContextExtensions on BuildContext {
  /// Creates a vertical divider widget with the specified width, height, and color.
  ///
  /// The [width] parameter specifies the width of the divider. If not provided, it defaults to a standard width.
  /// The [height] parameter specifies the height of the divider. If not provided, it defaults to a standard height.
  /// The [color] parameter specifies the color of the divider. If not provided, it defaults to a standard color.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// verticalDivider(width: 2.0, height: 50.0, color: Colors.black);
  /// ```
  ///
  /// This will create a vertical divider with a width of 2.0, height of 50.0, and black color.
  Widget verticalDivider({
    double? width,
    double? height,
    Color? color,
  }) {
    return Container(
      height: height ?? 20,
      width: width ?? 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: color ?? Colors.black,
    );
  }

  /// Creates a horizontal divider widget with the specified width, height, and color.
  ///
  /// The [width] parameter specifies the width of the divider. If null, the default width is used.
  /// The [height] parameter specifies the height of the divider. If null, the default height is used.
  /// The [color] parameter specifies the color of the divider. If null, the default color is used.
  ///
  /// Example usage:
  /// ```dart
  /// horizontalDivider(width: 100.0, height: 2.0, color: Colors.grey);
  /// ```
  Widget horizontalDivider({double? width, double? height, Color? color}) {
    return Container(
      height: height ?? 2,
      width: width ?? MediaQuery.sizeOf(this).width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: color ?? Colors.black,
    );
  }

  dynamic alignmentLayoutWPassLang(String language, var rtl, var ltr) {
    if (language.isRtlLanguageWPassLang(language)) {
      return rtl;
    } else {
      return ltr;
    }
  }
}
