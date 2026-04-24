part of '/quran.dart';

/// نمط وضع عرض المصحف مع التفسير الجانبي
///
/// [QuranTafsirSideStyle] Customization style for the quran-with-tafsir-side
/// display mode.
class QuranTafsirSideStyle {
  /// نسبة عرض قسم المصحف من العرض الكلي (0.0 – 1.0)
  final double? quranWidthFraction;

  /// لون خلفية قسم التفسير
  final Color? tafsirPanelBackgroundColor;

  /// لون الفاصل العمودي بين القسمين
  final Color? verticalDividerColor;

  /// سماكة الفاصل العمودي
  final double? verticalDividerWidth;

  /// لون نص التفسير
  final Color? tafsirTextColor;

  /// حجم خط التفسير
  final double? tafsirFontSize;

  /// لون خلفية شريط التفسير العلوي
  final Color? tafsirHeaderColor;

  /// لون نص شريط التفسير العلوي
  final Color? tafsirHeaderTextColor;

  /// لون الفاصل بين الآيات في قسم التفسير
  final Color? ayahDividerColor;

  /// لون نص الآية في قسم التفسير
  final Color? ayahTextColor;

  /// حجم خط الآية في قسم التفسير
  final double? ayahFontSize;

  /// عدد أسطر التفسير في الحالة المقلّصة
  final int? tafsirMaxLines;

  /// ارتفاع التفسير في الحالة المقلّصة
  final double? tafsirCollapsedHeight;

  /// نص زر "اقرأ المزيد"
  final String? readMoreText;

  /// نص زر "اقرأ أقل"
  final String? readLessText;

  /// لون زر "اقرأ المزيد"
  final Color? readMoreButtonColor;

  /// نمط نص زر "اقرأ المزيد"
  final TextStyle? readMoreTextStyle;

  /// لون أيقونة حجم الخط
  final Color? fontSizeIconColor;

  /// لون شريط حجم الخط (active)
  final Color? fontSizeActiveTrackColor;

  /// لون شريط حجم الخط (inactive)
  final Color? fontSizeInactiveTrackColor;

  /// لون مؤشر حجم الخط
  final Color? fontSizeThumbColor;

  const QuranTafsirSideStyle({
    this.quranWidthFraction,
    this.tafsirPanelBackgroundColor,
    this.verticalDividerColor,
    this.verticalDividerWidth,
    this.tafsirTextColor,
    this.tafsirFontSize,
    this.tafsirHeaderColor,
    this.tafsirHeaderTextColor,
    this.ayahDividerColor,
    this.ayahTextColor,
    this.ayahFontSize,
    this.tafsirMaxLines,
    this.tafsirCollapsedHeight,
    this.readMoreText,
    this.readLessText,
    this.readMoreButtonColor,
    this.readMoreTextStyle,
    this.fontSizeIconColor,
    this.fontSizeActiveTrackColor,
    this.fontSizeInactiveTrackColor,
    this.fontSizeThumbColor,
  });

  QuranTafsirSideStyle copyWith({
    double? quranWidthFraction,
    Color? tafsirPanelBackgroundColor,
    Color? verticalDividerColor,
    double? verticalDividerWidth,
    Color? tafsirTextColor,
    double? tafsirFontSize,
    Color? tafsirHeaderColor,
    Color? tafsirHeaderTextColor,
    Color? ayahDividerColor,
    Color? ayahTextColor,
    double? ayahFontSize,
    int? tafsirMaxLines,
    double? tafsirCollapsedHeight,
    String? readMoreText,
    String? readLessText,
    Color? readMoreButtonColor,
    TextStyle? readMoreTextStyle,
    Color? fontSizeIconColor,
    Color? fontSizeActiveTrackColor,
    Color? fontSizeInactiveTrackColor,
    Color? fontSizeThumbColor,
  }) {
    return QuranTafsirSideStyle(
      quranWidthFraction: quranWidthFraction ?? this.quranWidthFraction,
      tafsirPanelBackgroundColor:
          tafsirPanelBackgroundColor ?? this.tafsirPanelBackgroundColor,
      verticalDividerColor: verticalDividerColor ?? this.verticalDividerColor,
      verticalDividerWidth: verticalDividerWidth ?? this.verticalDividerWidth,
      tafsirTextColor: tafsirTextColor ?? this.tafsirTextColor,
      tafsirFontSize: tafsirFontSize ?? this.tafsirFontSize,
      tafsirHeaderColor: tafsirHeaderColor ?? this.tafsirHeaderColor,
      tafsirHeaderTextColor:
          tafsirHeaderTextColor ?? this.tafsirHeaderTextColor,
      ayahDividerColor: ayahDividerColor ?? this.ayahDividerColor,
      ayahTextColor: ayahTextColor ?? this.ayahTextColor,
      ayahFontSize: ayahFontSize ?? this.ayahFontSize,
      tafsirMaxLines: tafsirMaxLines ?? this.tafsirMaxLines,
      tafsirCollapsedHeight:
          tafsirCollapsedHeight ?? this.tafsirCollapsedHeight,
      readMoreText: readMoreText ?? this.readMoreText,
      readLessText: readLessText ?? this.readLessText,
      readMoreButtonColor: readMoreButtonColor ?? this.readMoreButtonColor,
      readMoreTextStyle: readMoreTextStyle ?? this.readMoreTextStyle,
      fontSizeIconColor: fontSizeIconColor ?? this.fontSizeIconColor,
      fontSizeActiveTrackColor:
          fontSizeActiveTrackColor ?? this.fontSizeActiveTrackColor,
      fontSizeInactiveTrackColor:
          fontSizeInactiveTrackColor ?? this.fontSizeInactiveTrackColor,
      fontSizeThumbColor: fontSizeThumbColor ?? this.fontSizeThumbColor,
    );
  }

  factory QuranTafsirSideStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return QuranTafsirSideStyle(
      quranWidthFraction: 0.5,
      tafsirPanelBackgroundColor:
          isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      verticalDividerColor:
          isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      verticalDividerWidth: 1.0,
      tafsirTextColor: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
      tafsirFontSize: 16,
      tafsirHeaderColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      tafsirHeaderTextColor: AppColors.getTextColor(isDark),
      ayahDividerColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      ayahTextColor: AppColors.getTextColor(isDark),
      ayahFontSize: 20,
      tafsirMaxLines: 4,
      tafsirCollapsedHeight: 80,
      readMoreText: 'اقرأ المزيد',
      readLessText: 'اقرأ أقل',
      readMoreButtonColor: scheme.primary,
      readMoreTextStyle: TextStyle(
        color: scheme.primary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      fontSizeIconColor: scheme.primary,
      fontSizeActiveTrackColor: scheme.primary,
      fontSizeInactiveTrackColor:
          isDark ? Colors.grey.shade600 : Colors.grey.shade400,
      fontSizeThumbColor: scheme.primary,
    );
  }
}
