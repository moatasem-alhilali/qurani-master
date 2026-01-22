part of '/quran.dart';

/// نمط مخصص لتبويب البحث داخل مكتبة القرآن.
class SearchTabStyle {
  // ألوان عامة
  final Color? textColor;
  final Color? accentColor;

  // حقل البحث
  final String? searchHintText;
  final TextStyle? searchHintStyle;
  final TextStyle? searchTextStyle;
  final double? searchBorderRadius;
  final double? searchFillAlpha;
  final EdgeInsetsGeometry? searchContentPadding;
  final IconData? searchSuffixIconData;
  final double?
      searchSuffixIconAlpha; // نسبة شفافية لون الأيقونة (على textColor)

  // شريحة السور (chips)
  final double? surahChipRowHeight;
  final double? surahChipRadius;
  final EdgeInsetsGeometry? surahChipPadding;
  final EdgeInsetsGeometry? surahChipMargin;
  final Color? surahChipBgColor; // إن لم تُحدد تُستخدم accentColor
  final TextStyle? surahChipTextStyle;

  // قائمة النتائج
  final Color? resultsDividerColor;
  final double? resultsDividerThickness;
  final double?
      subtitleTextAlpha; // شفافية النص الثانوي (اسم السورة/رقم الصفحة)
  final EdgeInsetsGeometry? listItemContentPadding;

  const SearchTabStyle({
    this.textColor,
    this.accentColor,
    this.searchHintText,
    this.searchHintStyle,
    this.searchTextStyle,
    this.searchBorderRadius,
    this.searchFillAlpha,
    this.searchContentPadding,
    this.searchSuffixIconData,
    this.searchSuffixIconAlpha,
    this.surahChipRowHeight,
    this.surahChipRadius,
    this.surahChipPadding,
    this.surahChipMargin,
    this.surahChipBgColor,
    this.surahChipTextStyle,
    this.resultsDividerColor,
    this.resultsDividerThickness,
    this.subtitleTextAlpha,
    this.listItemContentPadding,
  });

  factory SearchTabStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final text = AppColors.getTextColor(isDark);
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return SearchTabStyle(
      textColor: text,
      accentColor: primary,
      searchHintText: 'بحث في القرآن',
      searchHintStyle: QuranLibrary().cairoStyle.copyWith(
            color: text.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
      searchTextStyle: TextStyle(color: text),
      searchBorderRadius: 10.0,
      searchFillAlpha: 0.1,
      searchContentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      searchSuffixIconData: Icons.search,
      searchSuffixIconAlpha: 0.6,
      surahChipRowHeight: 64.0,
      surahChipRadius: 8.0,
      surahChipPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      surahChipMargin:
          const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      surahChipBgColor: null, // null => accentColor
      surahChipTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'surahName',
        fontSize: 28,
        package: 'quran_library',
      ),
      resultsDividerColor: Colors.grey,
      resultsDividerThickness: 1.0,
      subtitleTextAlpha: 0.8,
      listItemContentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  SearchTabStyle copyWith({
    Color? textColor,
    Color? accentColor,
    String? searchHintText,
    TextStyle? searchHintStyle,
    TextStyle? searchTextStyle,
    double? searchBorderRadius,
    double? searchFillAlpha,
    EdgeInsetsGeometry? searchContentPadding,
    IconData? searchSuffixIconData,
    double? searchSuffixIconAlpha,
    double? surahChipRowHeight,
    double? surahChipRadius,
    EdgeInsetsGeometry? surahChipPadding,
    EdgeInsetsGeometry? surahChipMargin,
    Color? surahChipBgColor,
    TextStyle? surahChipTextStyle,
    Color? resultsDividerColor,
    double? resultsDividerThickness,
    double? subtitleTextAlpha,
    EdgeInsetsGeometry? listItemContentPadding,
  }) {
    return SearchTabStyle(
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      searchHintText: searchHintText ?? this.searchHintText,
      searchHintStyle: searchHintStyle ?? this.searchHintStyle,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      searchBorderRadius: searchBorderRadius ?? this.searchBorderRadius,
      searchFillAlpha: searchFillAlpha ?? this.searchFillAlpha,
      searchContentPadding: searchContentPadding ?? this.searchContentPadding,
      searchSuffixIconData: searchSuffixIconData ?? this.searchSuffixIconData,
      searchSuffixIconAlpha:
          searchSuffixIconAlpha ?? this.searchSuffixIconAlpha,
      surahChipRowHeight: surahChipRowHeight ?? this.surahChipRowHeight,
      surahChipRadius: surahChipRadius ?? this.surahChipRadius,
      surahChipPadding: surahChipPadding ?? this.surahChipPadding,
      surahChipMargin: surahChipMargin ?? this.surahChipMargin,
      surahChipBgColor: surahChipBgColor ?? this.surahChipBgColor,
      surahChipTextStyle: surahChipTextStyle ?? this.surahChipTextStyle,
      resultsDividerColor: resultsDividerColor ?? this.resultsDividerColor,
      resultsDividerThickness:
          resultsDividerThickness ?? this.resultsDividerThickness,
      subtitleTextAlpha: subtitleTextAlpha ?? this.subtitleTextAlpha,
      listItemContentPadding:
          listItemContentPadding ?? this.listItemContentPadding,
    );
  }
}
