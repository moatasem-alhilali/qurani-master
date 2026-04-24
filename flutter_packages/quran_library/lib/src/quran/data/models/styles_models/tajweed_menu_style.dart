part of '/quran.dart';

/// نمط تخصيص نافذة/قائمة أحكام التجويد.
///
/// يُستخدم هذا النمط لضبط أبعاد الحاوية، ألوان الخلفية والنص، ترويسة النافذة
/// (العنوان/الأيقونة/الخلفية المتدرجة) وتنسيق عناصر القائمة.
class TajweedMenuStyle {
  // Container
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? containerPadding;
  final Color? backgroundColor;
  final double? borderRadius;

  // Header
  final EdgeInsetsGeometry? headerPadding;
  final String? headerTitle;
  final Color? headerTitleColor;
  final Color? headerCloseIconColor;
  final Gradient? headerBackgroundGradient;

  // List container
  final EdgeInsetsGeometry? listMargin;
  final EdgeInsets? listPadding;
  final double? listBorderRadius;

  // Item
  final EdgeInsetsGeometry? itemMargin;
  final EdgeInsetsGeometry? itemPadding;
  final double? itemBorderRadius;
  final Color? itemBorderColor;
  final double? itemBorderWidth;
  final double? itemGradientOpacity;

  // Color swatch
  final double? swatchSize;
  final double? swatchBorderRadius;

  // Text
  final TextStyle? itemTextStyle;

  const TajweedMenuStyle({
    this.width,
    this.height,
    this.containerPadding,
    this.backgroundColor,
    this.borderRadius,
    this.headerPadding,
    this.headerTitle,
    this.headerTitleColor,
    this.headerCloseIconColor,
    this.headerBackgroundGradient,
    this.listMargin,
    this.listPadding,
    this.listBorderRadius,
    this.itemMargin,
    this.itemPadding,
    this.itemBorderRadius,
    this.itemBorderColor,
    this.itemBorderWidth,
    this.itemGradientOpacity,
    this.swatchSize,
    this.swatchBorderRadius,
    this.itemTextStyle,
  });

  TajweedMenuStyle copyWith({
    double? width,
    double? height,
    EdgeInsetsGeometry? containerPadding,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? headerPadding,
    String? headerTitle,
    Color? headerTitleColor,
    Color? headerCloseIconColor,
    Gradient? headerBackgroundGradient,
    EdgeInsetsGeometry? listMargin,
    EdgeInsets? listPadding,
    double? listBorderRadius,
    EdgeInsetsGeometry? itemMargin,
    EdgeInsetsGeometry? itemPadding,
    double? itemBorderRadius,
    Color? itemBorderColor,
    double? itemBorderWidth,
    double? itemGradientOpacity,
    double? swatchSize,
    double? swatchBorderRadius,
    TextStyle? itemTextStyle,
  }) {
    return TajweedMenuStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      containerPadding: containerPadding ?? this.containerPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      headerPadding: headerPadding ?? this.headerPadding,
      headerTitle: headerTitle ?? this.headerTitle,
      headerTitleColor: headerTitleColor ?? this.headerTitleColor,
      headerCloseIconColor: headerCloseIconColor ?? this.headerCloseIconColor,
      headerBackgroundGradient:
          headerBackgroundGradient ?? this.headerBackgroundGradient,
      listMargin: listMargin ?? this.listMargin,
      listPadding: listPadding ?? this.listPadding,
      listBorderRadius: listBorderRadius ?? this.listBorderRadius,
      itemMargin: itemMargin ?? this.itemMargin,
      itemPadding: itemPadding ?? this.itemPadding,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemBorderColor: itemBorderColor ?? this.itemBorderColor,
      itemBorderWidth: itemBorderWidth ?? this.itemBorderWidth,
      itemGradientOpacity: itemGradientOpacity ?? this.itemGradientOpacity,
      swatchSize: swatchSize ?? this.swatchSize,
      swatchBorderRadius: swatchBorderRadius ?? this.swatchBorderRadius,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
    );
  }

  /// قيم افتراضية متناسقة مع الوضع (ليلي/نهاري)
  factory TajweedMenuStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = AppColors.getTextColor(isDark);

    return TajweedMenuStyle(
      width: 350,
      height: 350,
      containerPadding:
          const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      backgroundColor: AppColors.getBackgroundColor(isDark),
      borderRadius: 8,
      headerPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      headerTitle: 'أحكام التجويد',
      headerTitleColor: null,
      headerCloseIconColor: null,
      headerBackgroundGradient: null,
      listMargin: const EdgeInsets.all(4.0),
      listPadding: const EdgeInsets.symmetric(vertical: 6.0),
      listBorderRadius: 8,
      itemMargin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      itemBorderRadius: 8,
      itemBorderColor: scheme.primary.withValues(alpha: 0.2),
      itemBorderWidth: 1,
      itemGradientOpacity: 0.1,
      swatchSize: 34,
      swatchBorderRadius: 4,
      itemTextStyle: TextStyle(
        color: textColor,
        fontSize: 16,
        fontFamily: 'cairo',
        fontWeight: FontWeight.w500,
        package: 'quran_library',
      ),
    );
  }
}
