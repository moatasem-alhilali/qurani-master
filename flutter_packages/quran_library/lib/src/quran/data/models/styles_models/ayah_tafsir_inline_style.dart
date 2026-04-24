part of '/quran.dart';

typedef AyahTafsirInlineOptionsBarWidget = Widget Function(
  AyahModel ayah,
  SurahModel surah,
  int pageIndex,
);

/// نمط وضع عرض الآية مع التفسير المدمج
///
/// [AyahTafsirInlineStyle] Customization style for the ayah-with-inline-tafsir
/// display mode.
class AyahTafsirInlineStyle {
  /// لون خلفية الصفحة
  final Color? backgroundColor;

  /// لون نص الآية
  final Color? ayahTextColor;

  /// حجم خط الآية
  final double? ayahFontSize;

  /// لون نص التفسير
  final Color? tafsirTextColor;

  /// حجم خط التفسير
  final double? tafsirFontSize;

  /// لون خلفية قسم التفسير
  final Color? tafsirBackgroundColor;

  /// لون الفاصل بين الآيات
  final Color? dividerColor;

  /// سماكة الفاصل
  final double? dividerThickness;

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

  /// الحشو الداخلي لكل آية
  final EdgeInsetsGeometry? ayahPadding;

  /// الحشو الداخلي للتفسير
  final EdgeInsetsGeometry? tafsirPadding;

  /// لون رقم الآية
  final Color? ayahNumberColor;

  /// لون خلفية رقم الآية
  final Color? optionsBarBackgroundColor;

  /// لون شريط تغيير التفسير العلوي
  final Color? tafsirSelectorBarColor;

  /// لون نص شريط تغيير التفسير
  final Color? tafsirSelectorTextColor;

  /// لون أيقونة حجم الخط
  final Color? fontSizeIconColor;

  /// عنصر واجهة المستخدم لحجم الخط
  final Widget? fontSizeWidget;

  /// عنصر واجهة المستخدم لرأس قسم آية مع التفسير (مثل اسم المفسر)
  final Widget? headerWidget;

  /// عنصر واجهة المستخدم لشريط خيارات إضافية (مثل مشاركة الآية أو إضافتها للمفضلة)
  final AyahTafsirInlineOptionsBarWidget? optionsBarWidget;

  /// أيقونة زر تشغيل صوت الآية
  final IconData? playIconData;

  /// لون أيقونة زر تشغيل صوت الآية
  final Color? playIconColor;

  /// أيقونة زر تشغيل صوت جميع الآيات
  final IconData? playAllIconData;

  /// لون أيقونة زر تشغيل صوت جميع الآيات
  final Color? playAllIconColor;

  /// أيقونة زر نسخ نص الآية
  final IconData? copyIconData;

  /// لون أيقونة زر نسخ نص الآية
  final Color? copyIconColor;

  /// حجم أيقونة زر تشغيل صوت الآية
  final double? iconSize;

  /// ألوان رموز العلامات المرجعية
  final List<int>? bookmarkColorCodes;

  /// الحشو الأفقي للأيقونات
  final double? iconHorizontalPadding;

  /// أيقونة العلامة المرجعية
  final IconData? bookmarkIconData;

  final double? tafsirBackgroundBorderRadius;

  const AyahTafsirInlineStyle({
    this.backgroundColor,
    this.ayahTextColor,
    this.ayahFontSize,
    this.tafsirTextColor,
    this.tafsirFontSize,
    this.tafsirBackgroundColor,
    this.dividerColor,
    this.dividerThickness,
    this.tafsirMaxLines,
    this.tafsirCollapsedHeight,
    this.readMoreText,
    this.readLessText,
    this.readMoreButtonColor,
    this.readMoreTextStyle,
    this.ayahPadding,
    this.tafsirPadding,
    this.ayahNumberColor,
    this.optionsBarBackgroundColor,
    this.tafsirSelectorBarColor,
    this.tafsirSelectorTextColor,
    this.fontSizeIconColor,
    this.fontSizeWidget,
    this.headerWidget,
    this.optionsBarWidget,
    this.playIconData,
    this.playIconColor,
    this.iconSize,
    this.playAllIconData,
    this.playAllIconColor,
    this.copyIconData,
    this.copyIconColor,
    this.bookmarkColorCodes,
    this.iconHorizontalPadding,
    this.bookmarkIconData,
    this.tafsirBackgroundBorderRadius,
  });

  AyahTafsirInlineStyle copyWith({
    Color? backgroundColor,
    Color? ayahTextColor,
    double? ayahFontSize,
    Color? tafsirTextColor,
    double? tafsirFontSize,
    Color? tafsirBackgroundColor,
    Color? dividerColor,
    double? dividerThickness,
    int? tafsirMaxLines,
    double? tafsirCollapsedHeight,
    String? readMoreText,
    String? readLessText,
    Color? readMoreButtonColor,
    TextStyle? readMoreTextStyle,
    EdgeInsetsGeometry? ayahPadding,
    EdgeInsetsGeometry? tafsirPadding,
    Color? ayahNumberColor,
    Color? ayahNumberBackgroundColor,
    Color? tafsirSelectorBarColor,
    Color? tafsirSelectorTextColor,
    Color? fontSizeIconColor,
    Widget? fontSizeWidget,
    Widget? headerWidget,
    AyahTafsirInlineOptionsBarWidget? optionsBarWidget,
    IconData? playIconData,
    Color? playIconColor,
    double? iconSize,
    IconData? playAllIconData,
    Color? playAllIconColor,
    IconData? copyIconData,
    Color? copyIconColor,
    List<int>? bookmarkColorCodes,
    double? iconHorizontalPadding,
    IconData? bookmarkIconData,
    double? tafsirBackgroundBorderRadius,
  }) {
    return AyahTafsirInlineStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      ayahTextColor: ayahTextColor ?? this.ayahTextColor,
      ayahFontSize: ayahFontSize ?? this.ayahFontSize,
      tafsirTextColor: tafsirTextColor ?? this.tafsirTextColor,
      tafsirFontSize: tafsirFontSize ?? this.tafsirFontSize,
      tafsirBackgroundColor:
          tafsirBackgroundColor ?? this.tafsirBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      tafsirMaxLines: tafsirMaxLines ?? this.tafsirMaxLines,
      tafsirCollapsedHeight:
          tafsirCollapsedHeight ?? this.tafsirCollapsedHeight,
      readMoreText: readMoreText ?? this.readMoreText,
      readLessText: readLessText ?? this.readLessText,
      readMoreButtonColor: readMoreButtonColor ?? this.readMoreButtonColor,
      readMoreTextStyle: readMoreTextStyle ?? this.readMoreTextStyle,
      ayahPadding: ayahPadding ?? this.ayahPadding,
      tafsirPadding: tafsirPadding ?? this.tafsirPadding,
      ayahNumberColor: ayahNumberColor ?? this.ayahNumberColor,
      optionsBarBackgroundColor:
          ayahNumberBackgroundColor ?? optionsBarBackgroundColor,
      tafsirSelectorBarColor:
          tafsirSelectorBarColor ?? this.tafsirSelectorBarColor,
      tafsirSelectorTextColor:
          tafsirSelectorTextColor ?? this.tafsirSelectorTextColor,
      fontSizeIconColor: fontSizeIconColor ?? this.fontSizeIconColor,
      fontSizeWidget: fontSizeWidget ?? this.fontSizeWidget,
      headerWidget: headerWidget ?? this.headerWidget,
      optionsBarWidget: optionsBarWidget ?? this.optionsBarWidget,
      playIconData: playIconData ?? this.playIconData,
      playIconColor: playIconColor ?? this.playIconColor,
      iconSize: iconSize ?? this.iconSize,
      playAllIconData: playAllIconData ?? this.playAllIconData,
      playAllIconColor: playAllIconColor ?? this.playAllIconColor,
      copyIconData: copyIconData ?? this.copyIconData,
      copyIconColor: copyIconColor ?? this.copyIconColor,
      bookmarkColorCodes: bookmarkColorCodes ?? this.bookmarkColorCodes,
      iconHorizontalPadding:
          iconHorizontalPadding ?? this.iconHorizontalPadding,
      bookmarkIconData: bookmarkIconData ?? this.bookmarkIconData,
      tafsirBackgroundBorderRadius:
          tafsirBackgroundBorderRadius ?? this.tafsirBackgroundBorderRadius,
    );
  }

  factory AyahTafsirInlineStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return AyahTafsirInlineStyle(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      ayahTextColor: AppColors.getTextColor(isDark),
      ayahFontSize: 22,
      tafsirTextColor: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
      tafsirFontSize: 16,
      tafsirBackgroundColor: isDark
          ? Colors.grey.shade900.withValues(alpha: .5)
          : Colors.grey.shade200.withValues(alpha: .7),
      dividerColor: Colors.teal,
      dividerThickness: 1.0,
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
      ayahPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tafsirPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ayahNumberColor: scheme.primary,
      optionsBarBackgroundColor: scheme.primary.withValues(alpha: .1),
      tafsirSelectorBarColor: scheme.primary.withValues(alpha: .1),
      tafsirSelectorTextColor: AppColors.getTextColor(isDark),
      fontSizeIconColor: scheme.primary,
      fontSizeWidget: null,
      headerWidget: null,
      optionsBarWidget: null,
      playIconData: Icons.play_arrow,
      playIconColor: scheme.primary,
      iconSize: 24,
      playAllIconData: Icons.playlist_play,
      playAllIconColor: scheme.primary,
      copyIconData: Icons.copy_rounded,
      copyIconColor: scheme.primary,
      bookmarkColorCodes: const [
        0xAAFFD354,
        0xAAF36077,
        0xAA00CD00,
      ],
      iconHorizontalPadding: 4.0,
      bookmarkIconData: Icons.bookmark,
      tafsirBackgroundBorderRadius: 12.0,
    );
  }
}
