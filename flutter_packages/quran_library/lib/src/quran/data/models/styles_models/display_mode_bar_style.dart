part of '/quran.dart';

/// نمط شريط أزرار أوضاع العرض
///
/// [DisplayModeBarStyle] Customization style for the display mode selector bar.
class DisplayModeBarStyle {
  /// لون خلفية الشريط
  final Color? backgroundColor;

  /// لون الأيقونة المحددة
  final Color? selectedIconColor;

  /// لون الأيقونة غير المحددة
  final Color? unselectedIconColor;

  /// لون خلفية الأيقونة المحددة
  final Color? selectedBackgroundColor;

  /// حجم الأيقونات
  final double? iconSize;

  /// نصف قطر الزوايا
  final double? borderRadius;

  /// الحشو الداخلي
  final EdgeInsetsGeometry? padding;

  /// المسافة بين الأزرار
  final double? spacing;

  /// ارتفاع الشريط (الظل)
  final double? elevation;

  /// موضع الشريط في الشاشة (افتراضي: يمين المنتصف)
  final Alignment? position;

  /// لون التلميحات (Tooltip)
  final Color? tooltipBackgroundColor;

  /// نمط نص التلميح
  final TextStyle? tooltipTextStyle;

  /// هل يظهر الـ tooltip عند الضغط المطوّل؟
  final bool? showTooltip;

  const DisplayModeBarStyle({
    this.backgroundColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.selectedBackgroundColor,
    this.iconSize,
    this.borderRadius,
    this.padding,
    this.spacing,
    this.elevation,
    this.position,
    this.tooltipBackgroundColor,
    this.tooltipTextStyle,
    this.showTooltip,
  });

  DisplayModeBarStyle copyWith({
    Color? backgroundColor,
    Color? selectedIconColor,
    Color? unselectedIconColor,
    Color? selectedBackgroundColor,
    double? iconSize,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? elevation,
    Alignment? position,
    Color? tooltipBackgroundColor,
    TextStyle? tooltipTextStyle,
    bool? showTooltip,
  }) {
    return DisplayModeBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      unselectedIconColor: unselectedIconColor ?? this.unselectedIconColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      iconSize: iconSize ?? this.iconSize,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      elevation: elevation ?? this.elevation,
      position: position ?? this.position,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
      showTooltip: showTooltip ?? this.showTooltip,
    );
  }

  factory DisplayModeBarStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return DisplayModeBarStyle(
      backgroundColor: isDark
          ? Colors.grey.shade800.withValues(alpha: .85)
          : Colors.grey.shade200.withValues(alpha: .85),
      selectedIconColor: scheme.onPrimary,
      unselectedIconColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
      selectedBackgroundColor: scheme.primary.withValues(alpha: .8),
      iconSize: 24,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      spacing: 4,
      elevation: 4,
      position: Alignment.centerRight,
      tooltipBackgroundColor:
          isDark ? Colors.grey.shade700 : Colors.grey.shade800,
      tooltipTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
      showTooltip: true,
    );
  }
}
