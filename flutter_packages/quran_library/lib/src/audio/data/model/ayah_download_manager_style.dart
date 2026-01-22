part of '../../audio.dart';

typedef AyahCountTextBuilder = String Function(int downloaded, int total);

class AyahDownloadManagerStyle {
  // Header
  final String? titleText;
  final TextStyle? titleTextStyle;
  final Widget? headerIcon;
  final double? surahNameSize;

  // Handle (top bar)
  final Color? handleColor;
  final double? handleWidth;
  final double? handleHeight;
  final double? handleRadius;

  // Stop/Cancel button
  final IconData? stopButtonIcon;
  final Color? stopButtonForeground;
  final Color? stopButtonBackground;

  // List/Item visuals
  final Color? separatorColor;
  final double? itemHorizontalPadding;
  final double? itemVerticalPadding;
  final TextStyle? surahTitleStyle;
  final TextStyle? surahSubtitleStyle;

  // Avatar
  final Color? avatarDownloadedColor;
  final Color? avatarUndownloadedColor;
  final TextStyle? avatarTextStyle;

  // Progress
  final Color? progressColor;
  final Color? progressBackgroundColor;
  final double? progressHeight;
  final double? progressRadius;

  // Delete action
  final IconData? deleteIcon;
  final Color? deleteIconColor;

  // Download action
  final IconData? downloadIcon;
  final String? redownloadText;
  final IconData? redownloadIcon;
  final Color? downloadForeground;
  final Color? downloadBackground;

  final Color? backgroundColor;

  final Widget? changeReaderWidget;

  // Count text
  final AyahCountTextBuilder? countTextBuilder;

  const AyahDownloadManagerStyle({
    this.titleText,
    this.titleTextStyle,
    this.headerIcon,
    this.surahNameSize,
    this.handleColor,
    this.handleWidth,
    this.handleHeight,
    this.handleRadius,
    this.stopButtonIcon,
    this.stopButtonForeground,
    this.stopButtonBackground,
    this.separatorColor,
    this.itemHorizontalPadding,
    this.itemVerticalPadding,
    this.surahTitleStyle,
    this.surahSubtitleStyle,
    this.avatarDownloadedColor,
    this.avatarUndownloadedColor,
    this.avatarTextStyle,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressHeight,
    this.progressRadius,
    this.deleteIcon,
    this.deleteIconColor,
    this.downloadIcon,
    this.redownloadText,
    this.redownloadIcon,
    this.downloadForeground,
    this.downloadBackground,
    this.countTextBuilder,
    this.backgroundColor,
    this.changeReaderWidget,
  });

  AyahDownloadManagerStyle copyWith({
    String? titleText,
    TextStyle? titleTextStyle,
    Widget? headerIcon,
    double? surahNameSize,
    Color? handleColor,
    double? handleWidth,
    double? handleHeight,
    double? handleRadius,
    String? stopButtonText,
    IconData? stopButtonIcon,
    Color? stopButtonForeground,
    Color? stopButtonBackground,
    Color? separatorColor,
    double? itemHorizontalPadding,
    double? itemVerticalPadding,
    TextStyle? surahTitleStyle,
    TextStyle? surahSubtitleStyle,
    Color? avatarDownloadedColor,
    Color? avatarUndownloadedColor,
    TextStyle? avatarTextStyle,
    Color? progressColor,
    Color? progressBackgroundColor,
    double? progressHeight,
    double? progressRadius,
    String? deleteTooltipText,
    IconData? deleteIcon,
    Color? deleteIconColor,
    String? downloadText,
    IconData? downloadIcon,
    String? redownloadText,
    IconData? redownloadIcon,
    Color? downloadForeground,
    Color? downloadBackground,
    Color? backgroundColor,
    Widget? changeReaderWidget,
    AyahCountTextBuilder? countTextBuilder,
  }) {
    return AyahDownloadManagerStyle(
      titleText: titleText ?? this.titleText,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      headerIcon: headerIcon ?? this.headerIcon,
      surahNameSize: surahNameSize ?? this.surahNameSize,
      handleColor: handleColor ?? this.handleColor,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      handleRadius: handleRadius ?? this.handleRadius,
      stopButtonIcon: stopButtonIcon ?? this.stopButtonIcon,
      stopButtonForeground: stopButtonForeground ?? this.stopButtonForeground,
      stopButtonBackground: stopButtonBackground ?? this.stopButtonBackground,
      separatorColor: separatorColor ?? this.separatorColor,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      itemVerticalPadding: itemVerticalPadding ?? this.itemVerticalPadding,
      surahTitleStyle: surahTitleStyle ?? this.surahTitleStyle,
      surahSubtitleStyle: surahSubtitleStyle ?? this.surahSubtitleStyle,
      avatarDownloadedColor:
          avatarDownloadedColor ?? this.avatarDownloadedColor,
      avatarUndownloadedColor:
          avatarUndownloadedColor ?? this.avatarUndownloadedColor,
      avatarTextStyle: avatarTextStyle ?? this.avatarTextStyle,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      progressHeight: progressHeight ?? this.progressHeight,
      progressRadius: progressRadius ?? this.progressRadius,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      deleteIconColor: deleteIconColor ?? this.deleteIconColor,
      downloadIcon: downloadIcon ?? this.downloadIcon,
      redownloadText: redownloadText ?? this.redownloadText,
      redownloadIcon: redownloadIcon ?? this.redownloadIcon,
      downloadForeground: downloadForeground ?? this.downloadForeground,
      downloadBackground: downloadBackground ?? this.downloadBackground,
      countTextBuilder: countTextBuilder ?? this.countTextBuilder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      changeReaderWidget: changeReaderWidget ?? this.changeReaderWidget,
    );
  }

  /// القيم الافتراضية الموحدة حسب الثيم
  /// Unified defaults based on theme
  factory AyahDownloadManagerStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final onBg = AppColors.getTextColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);

    return AyahDownloadManagerStyle(
      backgroundColor: backgroundColor,
      // Header
      titleText: 'إدارة تحميل آيات السور',
      titleTextStyle: QuranLibrary().cairoStyle.copyWith(
            fontSize: 18,
            color: onBg,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
      surahNameSize: 30.0,

      // Handle
      handleColor: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
      handleWidth: 48.0,
      handleHeight: 5.0,
      handleRadius: 8.0,

      // Stop/Cancel button
      stopButtonIcon: Icons.stop_circle_outlined,
      stopButtonForeground: Colors.white,
      stopButtonBackground: primary,

      // List/Item
      separatorColor: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.08),
      itemHorizontalPadding: 16.0,
      itemVerticalPadding: 8.0,
      surahTitleStyle: TextStyle(
        color: onBg,
        fontFamily: "surahName",
        fontSize: 30.0,
        height: 1.2,
        package: "quran_library",
      ),
      surahSubtitleStyle: QuranLibrary().cairoStyle.copyWith(
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            height: 1.2,
          ),

      // Avatar
      avatarDownloadedColor: primary,
      avatarUndownloadedColor: primary.withValues(alpha: 0.4),
      avatarTextStyle: QuranLibrary()
          .cairoStyle
          .copyWith(color: Colors.white, fontWeight: FontWeight.bold),

      // Progress
      progressColor: primary.withValues(alpha: 0.25),
      progressBackgroundColor:
          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      progressHeight: 70.0,
      progressRadius: 8.0,

      // Delete action
      deleteIcon: Icons.delete_outline,
      deleteIconColor: Colors.red,

      // Download action
      downloadIcon: Icons.download,
      redownloadText: 'إعادة',
      redownloadIcon: Icons.refresh,
      downloadForeground: Colors.white,
      downloadBackground: primary,

      // Count text builder - يمكن تخصيصه لاحقًا
      countTextBuilder: null,
      changeReaderWidget: null,
    );
  }
}
