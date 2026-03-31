part of '../../audio.dart';

class AyahAudioStyle {
  final Color? textColor;
  final String? playIconPath;
  final double? playIconHeight;
  final Color? playIconColor;
  final String? pauseIconPath;
  final double? pauseIconHeight;
  final double? previousIconHeight;
  final double? nextIconHeight;
  final Color? readerNameInItemColor;
  final double? readerNameInItemFontSize;
  final double? readerNameFontSize;
  final Color? seekBarThumbColor;
  final Color? seekBarActiveTrackColor;
  final Color? seekBarInactiveTrackColor;
  final double? seekBarHorizontalPadding;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? dialogBackgroundColor;
  final double? dialogBorderRadius;
  final double? dialogWidth;
  final double? dialogHeight;
  final Gradient? dialogHeaderBackgroundGradient;
  final Color? dialogHeaderTitleColor;
  final String? dialogHeaderTitle;
  final Color? dialogCloseIconColor;
  final Color? dialogSelectedReaderColor;
  final Color? dialogUnSelectedReaderColor;
  final Color? dialogReaderTextColor;
  final Color? seekBarTimeContainerColor;
  final Color? tabIndicatorColor;
  final Color? tabLabelColor;
  final Color? tabUnselectedLabelColor;
  final TextStyle? tabLabelStyle;
  final String? readersTabText;
  final String? downloadedSurahsTabText;
  final String? noInternetConnectionText;

  AyahAudioStyle({
    this.textColor,
    this.playIconPath,
    this.playIconHeight,
    this.playIconColor,
    this.pauseIconPath,
    this.pauseIconHeight,
    this.readerNameInItemColor,
    this.readerNameInItemFontSize,
    this.readerNameFontSize,
    this.seekBarThumbColor,
    this.seekBarActiveTrackColor,
    this.seekBarHorizontalPadding,
    this.previousIconHeight,
    this.nextIconHeight,
    this.seekBarInactiveTrackColor,
    this.backgroundColor,
    this.borderRadius,
    this.dialogBackgroundColor,
    this.dialogBorderRadius,
    this.dialogWidth,
    this.dialogHeight,
    this.dialogHeaderBackgroundGradient,
    this.dialogHeaderTitleColor,
    this.dialogCloseIconColor,
    this.dialogSelectedReaderColor,
    this.dialogUnSelectedReaderColor,
    this.dialogReaderTextColor,
    this.seekBarTimeContainerColor,
    this.tabIndicatorColor,
    this.tabLabelColor,
    this.tabUnselectedLabelColor,
    this.tabLabelStyle,
    this.readersTabText,
    this.downloadedSurahsTabText,
    this.dialogHeaderTitle,
    this.noInternetConnectionText,
  });

  AyahAudioStyle copyWith({
    Color? textColor,
    String? playIconPath,
    double? playIconHeight,
    Color? playIconColor,
    String? pauseIconPath,
    double? pauseIconHeight,
    double? previousIconHeight,
    double? nextIconHeight,
    Color? readerNameInItemColor,
    double? readerNameInItemFontSize,
    double? readerNameFontSize,
    Color? seekBarThumbColor,
    Color? seekBarActiveTrackColor,
    Color? seekBarInactiveTrackColor,
    double? seekBarHorizontalPadding,
    Color? backgroundColor,
    double? borderRadius,
    Color? dialogBackgroundColor,
    double? dialogBorderRadius,
    double? dialogWidth,
    double? dialogHeight,
    Gradient? dialogHeaderBackgroundGradient,
    Color? dialogHeaderTitleColor,
    Color? dialogCloseIconColor,
    Color? dialogSelectedReaderColor,
    Color? dialogUnSelectedReaderColor,
    Color? dialogReaderTextColor,
    Color? seekBarTimeContainerColor,
    Color? tabIndicatorColor,
    Color? tabLabelColor,
    Color? tabUnselectedLabelColor,
    TextStyle? tabLabelStyle,
    String? readersTabText,
    String? downloadedSurahsTabText,
    String? dialogHeaderTitle,
    String? noInternetConnectionText,
  }) {
    return AyahAudioStyle(
      textColor: textColor ?? this.textColor,
      playIconPath: playIconPath ?? this.playIconPath,
      playIconHeight: playIconHeight ?? this.playIconHeight,
      playIconColor: playIconColor ?? this.playIconColor,
      pauseIconPath: pauseIconPath ?? this.pauseIconPath,
      pauseIconHeight: pauseIconHeight ?? this.pauseIconHeight,
      previousIconHeight: previousIconHeight ?? this.previousIconHeight,
      nextIconHeight: nextIconHeight ?? this.nextIconHeight,
      readerNameInItemColor:
          readerNameInItemColor ?? this.readerNameInItemColor,
      readerNameInItemFontSize:
          readerNameInItemFontSize ?? this.readerNameInItemFontSize,
      readerNameFontSize: readerNameFontSize ?? this.readerNameFontSize,
      seekBarThumbColor: seekBarThumbColor ?? this.seekBarThumbColor,
      seekBarActiveTrackColor:
          seekBarActiveTrackColor ?? this.seekBarActiveTrackColor,
      seekBarInactiveTrackColor:
          seekBarInactiveTrackColor ?? this.seekBarInactiveTrackColor,
      seekBarHorizontalPadding:
          seekBarHorizontalPadding ?? this.seekBarHorizontalPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      dialogBackgroundColor:
          dialogBackgroundColor ?? this.dialogBackgroundColor,
      dialogBorderRadius: dialogBorderRadius ?? this.dialogBorderRadius,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      dialogHeight: dialogHeight ?? this.dialogHeight,
      dialogHeaderBackgroundGradient:
          dialogHeaderBackgroundGradient ?? this.dialogHeaderBackgroundGradient,
      dialogHeaderTitleColor:
          dialogHeaderTitleColor ?? this.dialogHeaderTitleColor,
      dialogCloseIconColor: dialogCloseIconColor ?? this.dialogCloseIconColor,
      dialogSelectedReaderColor:
          dialogSelectedReaderColor ?? this.dialogSelectedReaderColor,
      dialogUnSelectedReaderColor:
          dialogUnSelectedReaderColor ?? this.dialogUnSelectedReaderColor,
      dialogReaderTextColor:
          dialogReaderTextColor ?? this.dialogReaderTextColor,
      seekBarTimeContainerColor:
          seekBarTimeContainerColor ?? this.seekBarTimeContainerColor,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      tabLabelColor: tabLabelColor ?? this.tabLabelColor,
      tabUnselectedLabelColor:
          tabUnselectedLabelColor ?? this.tabUnselectedLabelColor,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      readersTabText: readersTabText ?? this.readersTabText,
      downloadedSurahsTabText:
          downloadedSurahsTabText ?? this.downloadedSurahsTabText,
      dialogHeaderTitle: dialogHeaderTitle ?? this.dialogHeaderTitle,
      noInternetConnectionText:
          noInternetConnectionText ?? this.noInternetConnectionText,
    );
  }

  factory AyahAudioStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final bg = AppColors.getBackgroundColor(isDark);
    final onBg = AppColors.getTextColor(isDark);
    final primary = scheme.primary;

    return AyahAudioStyle(
      // ألوان عامة
      backgroundColor: bg,
      textColor: onBg,
      playIconColor: primary,

      // الحدود
      borderRadius: 16.0,
      dialogBorderRadius: 12.0,
      dialogBackgroundColor: bg,

      // نافذة اختيار القارئ
      dialogHeight: MediaQuery.of(context).size.height * 0.7,
      dialogWidth: MediaQuery.of(context).size.width,
      dialogHeaderTitleColor: onBg,
      dialogCloseIconColor: onBg,
      dialogHeaderBackgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withValues(alpha: 0.15),
          primary.withValues(alpha: 0.05),
        ],
      ),
      dialogSelectedReaderColor: primary,
      dialogUnSelectedReaderColor: onBg,
      dialogReaderTextColor: onBg,

      // أيقونات التحكم
      pauseIconHeight: 38.0,
      playIconHeight: 38.0,
      previousIconHeight: 38.0,
      nextIconHeight: 38.0,

      // شريط التقدم
      seekBarThumbColor: primary,
      seekBarActiveTrackColor: primary,
      seekBarInactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
      seekBarHorizontalPadding: 32.0,
      seekBarTimeContainerColor: primary,

      // أسماء/أحجام
      readerNameFontSize: 16.0,
      readerNameInItemFontSize: 14.0,
      readerNameInItemColor: onBg,

      // التبويبات
      tabIndicatorColor: primary,
      tabLabelColor: primary,
      tabUnselectedLabelColor: onBg,
      tabLabelStyle: QuranLibrary().cairoStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
      readersTabText: 'القراء',
      downloadedSurahsTabText: 'السور المحملة',
      dialogHeaderTitle: 'تغيير القارئ',
      noInternetConnectionText: 'لا يوجد اتصال بالإنترنت',
    );
  }
}
