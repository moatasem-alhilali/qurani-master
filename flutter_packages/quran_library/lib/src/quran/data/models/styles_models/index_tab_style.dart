part of '/quran.dart';

/// نمط مخصص لتبويب الفهرس (السور/الأجزاء) داخل شريط القرآن.
/// يتيح تخصيص الألوان والأبعاد والأنماط النصية والعناوين.
class IndexTabStyle {
  // الألوان الأساسية
  final Color? textColor;
  final Color? accentColor;

  // إعدادات TabBar
  final double? tabBarHeight;
  final double? tabBarRadius;
  final double? indicatorRadius;
  final EdgeInsetsGeometry? indicatorPadding;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final double? tabBarBgAlpha; // قيمة الشفافية لخلفية شريط التبويب

  // النصوص
  final String? tabSurahsLabel;
  final String? tabJozzLabel;

  // القوائم الداخلية
  final double? listItemRadius;
  final double? surahRowAltBgAlpha; // تظليل صفوف السور المتناوبة
  final double? jozzAltBgAlpha; // تظليل صفوف الأجزاء المتناوبة
  final double? hizbItemAltBgAlpha; // تظليل عناصر الأحزاب داخل ExpansionTile

  const IndexTabStyle({
    this.textColor,
    this.accentColor,
    this.tabBarHeight,
    this.tabBarRadius,
    this.indicatorRadius,
    this.indicatorPadding,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabBarBgAlpha,
    this.tabSurahsLabel,
    this.tabJozzLabel,
    this.listItemRadius,
    this.surahRowAltBgAlpha,
    this.jozzAltBgAlpha,
    this.hizbItemAltBgAlpha,
  });

  factory IndexTabStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final text = AppColors.getTextColor(isDark);
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return IndexTabStyle(
      textColor: text,
      accentColor: primary,
      tabBarHeight: 35.0,
      tabBarRadius: 12.0,
      indicatorRadius: 10.0,
      indicatorPadding: const EdgeInsets.all(4),
      labelColor: Colors.white,
      unselectedLabelColor: text.withValues(alpha: 0.6),
      labelStyle: QuranLibrary().cairoStyle.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
      unselectedLabelStyle: QuranLibrary().cairoStyle.copyWith(
            fontSize: 13,
          ),
      tabBarBgAlpha: 0.06,
      tabSurahsLabel: 'السور',
      tabJozzLabel: 'الأجزاء',
      listItemRadius: 8.0,
      surahRowAltBgAlpha: 0.1,
      jozzAltBgAlpha: 0.1,
      hizbItemAltBgAlpha: 0.05,
    );
  }

  IndexTabStyle copyWith({
    Color? textColor,
    Color? accentColor,
    double? tabBarHeight,
    double? tabBarRadius,
    double? indicatorRadius,
    EdgeInsetsGeometry? indicatorPadding,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    double? tabBarBgAlpha,
    String? tabSurahsLabel,
    String? tabJozzLabel,
    double? listItemRadius,
    double? surahRowAltBgAlpha,
    double? jozzAltBgAlpha,
    double? hizbItemAltBgAlpha,
  }) {
    return IndexTabStyle(
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      tabBarHeight: tabBarHeight ?? this.tabBarHeight,
      tabBarRadius: tabBarRadius ?? this.tabBarRadius,
      indicatorRadius: indicatorRadius ?? this.indicatorRadius,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
      labelColor: labelColor ?? this.labelColor,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      tabBarBgAlpha: tabBarBgAlpha ?? this.tabBarBgAlpha,
      tabSurahsLabel: tabSurahsLabel ?? this.tabSurahsLabel,
      tabJozzLabel: tabJozzLabel ?? this.tabJozzLabel,
      listItemRadius: listItemRadius ?? this.listItemRadius,
      surahRowAltBgAlpha: surahRowAltBgAlpha ?? this.surahRowAltBgAlpha,
      jozzAltBgAlpha: jozzAltBgAlpha ?? this.jozzAltBgAlpha,
      hizbItemAltBgAlpha: hizbItemAltBgAlpha ?? this.hizbItemAltBgAlpha,
    );
  }
}
