part of '/quran.dart';

/// نمط مخصص للـ SnackBar
class SnackBarStyle {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Duration? duration;
  final SnackBarBehavior? behavior;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final Color? actionTextColor;

  /// تمكين/تعطيل إظهار SnackBar
  final bool? enabled;

  const SnackBarStyle({
    this.backgroundColor,
    this.textStyle,
    this.duration,
    this.behavior,
    this.margin,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.actionTextColor,
    this.enabled,
  });

  SnackBarStyle copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    Duration? duration,
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    double? elevation,
    Color? actionTextColor,
    bool? enabled,
  }) {
    return SnackBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      duration: duration ?? this.duration,
      behavior: behavior ?? this.behavior,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      actionTextColor: actionTextColor ?? this.actionTextColor,
      enabled: enabled ?? this.enabled,
    );
  }

  factory SnackBarStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final onBg = AppColors.getTextColor(isDark);
    const primary = Colors.teal;

    return SnackBarStyle(
      backgroundColor:
          isDark ? const Color(0xFF2C2C2C) : const Color(0xffe8decb),
      textStyle: QuranLibrary().naskhStyle.copyWith(color: onBg),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 12,
      elevation: 0,
      actionTextColor: primary,
      enabled: true,
    );
  }
}
