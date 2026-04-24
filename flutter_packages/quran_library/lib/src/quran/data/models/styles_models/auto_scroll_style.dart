part of '/quran.dart';

/// نمط تخصيص مظهر السكرول التلقائي
///
/// [AutoScrollStyle] Style customization for the auto-scroll overlay
class AutoScrollStyle {
  final Color? sliderActiveColor;
  final Color? sliderInactiveColor;
  final Color? sliderThumbColor;
  final Color? overlayBackgroundColor;
  final Color? iconColor;
  final Color? activeIconColor;
  final Color? textColor;
  final Color? chipSelectedColor;
  final Color? chipUnselectedColor;
  final double? borderRadius;
  final TextStyle? labelStyle;
  final TextStyle? speedLabelStyle;

  // ─── Settings texts ───────────────────────────────────────────
  /// عنوان قسم الإعدادات (افتراضي: 'السكرول التلقائي')
  final String? settingsTitleText;

  /// نص تسمية شرط التوقف (افتراضي: 'التوقف عند:')
  final String? stopConditionLabelText;

  /// نص تسمية عدد الصفحات (افتراضي: 'عدد الصفحات:')
  final String? pageCountLabelText;

  /// نص تسمية السرعة (افتراضي: 'السرعة:')
  final String? speedLabelText;

  /// نص تسمية "بطيء" (افتراضي: 'بطيء')
  final String? slowLabelText;

  /// نص تسمية "سريع" (افتراضي: 'سريع')
  final String? fastLabelText;

  /// أسماء شروط التوقف المخصصة (ترتيب: nextHizb, nextJuz, pageCount, manual)
  final Map<AutoScrollStopCondition, String>? stopConditionLabels;

  // ─── Settings styles ──────────────────────────────────────────
  /// نمط العنوان الرئيسي
  final TextStyle? settingsTitleStyle;

  /// نمط التسميات الفرعية (التوقف عند، عدد الصفحات، السرعة)
  final TextStyle? settingsSubLabelStyle;

  /// نمط نصوص الـ Chips
  final TextStyle? chipTextStyle;

  /// نمط نص عداد الصفحات
  final TextStyle? pageCountValueStyle;

  /// نمط نصوص بطيء/سريع
  final TextStyle? sliderHintStyle;

  /// لون حدود الـ Chip المحدد
  final Color? chipSelectedBorderColor;

  /// لون حدود الـ Chip غير المحدد
  final Color? chipUnselectedBorderColor;

  /// نصف قطر حواف الـ Chip
  final double? chipBorderRadius;

  /// لون خلفية الـ Chip المحدد
  final Color? chipSelectedBackgroundColor;

  /// لون خلفية الـ Chip غير المحدد
  final Color? chipUnselectedBackgroundColor;

  /// لون أزرار +/- لعداد الصفحات
  final Color? pageCountButtonColor;

  const AutoScrollStyle({
    this.sliderActiveColor,
    this.sliderInactiveColor,
    this.sliderThumbColor,
    this.overlayBackgroundColor,
    this.iconColor,
    this.activeIconColor,
    this.textColor,
    this.chipSelectedColor,
    this.chipUnselectedColor,
    this.borderRadius,
    this.labelStyle,
    this.speedLabelStyle,
    this.settingsTitleText,
    this.stopConditionLabelText,
    this.pageCountLabelText,
    this.speedLabelText,
    this.slowLabelText,
    this.fastLabelText,
    this.stopConditionLabels,
    this.settingsTitleStyle,
    this.settingsSubLabelStyle,
    this.chipTextStyle,
    this.pageCountValueStyle,
    this.sliderHintStyle,
    this.chipSelectedBorderColor,
    this.chipUnselectedBorderColor,
    this.chipBorderRadius,
    this.chipSelectedBackgroundColor,
    this.chipUnselectedBackgroundColor,
    this.pageCountButtonColor,
  });

  AutoScrollStyle copyWith({
    Color? sliderActiveColor,
    Color? sliderInactiveColor,
    Color? sliderThumbColor,
    Color? overlayBackgroundColor,
    Color? iconColor,
    Color? activeIconColor,
    Color? textColor,
    Color? chipSelectedColor,
    Color? chipUnselectedColor,
    double? borderRadius,
    TextStyle? labelStyle,
    TextStyle? speedLabelStyle,
    String? settingsTitleText,
    String? stopConditionLabelText,
    String? pageCountLabelText,
    String? speedLabelText,
    String? slowLabelText,
    String? fastLabelText,
    Map<AutoScrollStopCondition, String>? stopConditionLabels,
    TextStyle? settingsTitleStyle,
    TextStyle? settingsSubLabelStyle,
    TextStyle? chipTextStyle,
    TextStyle? pageCountValueStyle,
    TextStyle? sliderHintStyle,
    Color? chipSelectedBorderColor,
    Color? chipUnselectedBorderColor,
    double? chipBorderRadius,
    Color? chipSelectedBackgroundColor,
    Color? chipUnselectedBackgroundColor,
    Color? pageCountButtonColor,
  }) {
    return AutoScrollStyle(
      sliderActiveColor: sliderActiveColor ?? this.sliderActiveColor,
      sliderInactiveColor: sliderInactiveColor ?? this.sliderInactiveColor,
      sliderThumbColor: sliderThumbColor ?? this.sliderThumbColor,
      overlayBackgroundColor:
          overlayBackgroundColor ?? this.overlayBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      textColor: textColor ?? this.textColor,
      chipSelectedColor: chipSelectedColor ?? this.chipSelectedColor,
      chipUnselectedColor: chipUnselectedColor ?? this.chipUnselectedColor,
      borderRadius: borderRadius ?? this.borderRadius,
      labelStyle: labelStyle ?? this.labelStyle,
      speedLabelStyle: speedLabelStyle ?? this.speedLabelStyle,
      settingsTitleText: settingsTitleText ?? this.settingsTitleText,
      stopConditionLabelText:
          stopConditionLabelText ?? this.stopConditionLabelText,
      pageCountLabelText: pageCountLabelText ?? this.pageCountLabelText,
      speedLabelText: speedLabelText ?? this.speedLabelText,
      slowLabelText: slowLabelText ?? this.slowLabelText,
      fastLabelText: fastLabelText ?? this.fastLabelText,
      stopConditionLabels: stopConditionLabels ?? this.stopConditionLabels,
      settingsTitleStyle: settingsTitleStyle ?? this.settingsTitleStyle,
      settingsSubLabelStyle:
          settingsSubLabelStyle ?? this.settingsSubLabelStyle,
      chipTextStyle: chipTextStyle ?? this.chipTextStyle,
      pageCountValueStyle: pageCountValueStyle ?? this.pageCountValueStyle,
      sliderHintStyle: sliderHintStyle ?? this.sliderHintStyle,
      chipSelectedBorderColor:
          chipSelectedBorderColor ?? this.chipSelectedBorderColor,
      chipUnselectedBorderColor:
          chipUnselectedBorderColor ?? this.chipUnselectedBorderColor,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipSelectedBackgroundColor:
          chipSelectedBackgroundColor ?? this.chipSelectedBackgroundColor,
      chipUnselectedBackgroundColor:
          chipUnselectedBackgroundColor ?? this.chipUnselectedBackgroundColor,
      pageCountButtonColor: pageCountButtonColor ?? this.pageCountButtonColor,
    );
  }

  factory AutoScrollStyle.defaults(
      {required bool isDark, required BuildContext context}) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return AutoScrollStyle(
      sliderActiveColor: primary,
      sliderInactiveColor: primary.withValues(alpha: .3),
      sliderThumbColor: primary,
      overlayBackgroundColor:
          AppColors.getBackgroundColor(isDark).withValues(alpha: .92),
      iconColor: AppColors.getTextColor(isDark),
      activeIconColor: primary,
      textColor: AppColors.getTextColor(isDark),
      chipSelectedColor: primary.withValues(alpha: .15),
      chipUnselectedColor: Colors.transparent,
      borderRadius: 16,
      labelStyle: TextStyle(
        fontSize: 13,
        fontFamily: 'cairo',
        color: AppColors.getTextColor(isDark),
        package: 'quran_library',
      ),
      speedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'cairo',
        color: primary,
        package: 'quran_library',
      ),
    );
  }
}

/// InheritedWidget for [AutoScrollStyle] injection
class AutoScrollTheme extends InheritedWidget {
  final AutoScrollStyle style;

  const AutoScrollTheme({
    super.key,
    required this.style,
    required super.child,
  });

  static AutoScrollTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AutoScrollTheme>();

  @override
  bool updateShouldNotify(AutoScrollTheme oldWidget) =>
      style != oldWidget.style;
}
