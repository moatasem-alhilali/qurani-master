part of '/quran.dart';

class SurahInfoStyle {
  final Color? backgroundColor;
  final Color? closeIconColor;
  final Color? surahNameColor;
  final Color? surahNumberColor;
  final Color? primaryColor;
  final Color? titleColor;
  final Color? indicatorColor;
  final Color? textColor;
  final String? ayahCount;
  final String? secondTabText;
  final String? firstTabText;
  final double? bottomSheetWidth;
  final double? bottomSheetHeight;

  SurahInfoStyle({
    this.closeIconColor,
    this.surahNameColor,
    this.surahNumberColor,
    this.backgroundColor,
    this.primaryColor,
    this.titleColor,
    this.indicatorColor,
    this.textColor,
    this.ayahCount,
    this.secondTabText,
    this.firstTabText,
    this.bottomSheetWidth,
    this.bottomSheetHeight,
  });

  SurahInfoStyle copyWith({
    Color? backgroundColor,
    Color? closeIconColor,
    Color? surahNameColor,
    Color? surahNumberColor,
    Color? primaryColor,
    Color? titleColor,
    Color? indicatorColor,
    Color? textColor,
    String? ayahCount,
    String? secondTabText,
    String? firstTabText,
    double? bottomSheetWidth,
    double? bottomSheetHeight,
  }) {
    return SurahInfoStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      surahNameColor: surahNameColor ?? this.surahNameColor,
      surahNumberColor: surahNumberColor ?? this.surahNumberColor,
      primaryColor: primaryColor ?? this.primaryColor,
      titleColor: titleColor ?? this.titleColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      textColor: textColor ?? this.textColor,
      ayahCount: ayahCount ?? this.ayahCount,
      secondTabText: secondTabText ?? this.secondTabText,
      firstTabText: firstTabText ?? this.firstTabText,
      bottomSheetWidth: bottomSheetWidth ?? this.bottomSheetWidth,
      bottomSheetHeight: bottomSheetHeight ?? this.bottomSheetHeight,
    );
  }

  factory SurahInfoStyle.defaults(
      {required bool isDark, required BuildContext context}) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return SurahInfoStyle(
      ayahCount: 'عدد الآيات',
      secondTabText: 'عن السورة',
      firstTabText: 'أسماء السورة',
      backgroundColor: AppColors.getBackgroundColor(isDark),
      closeIconColor: AppColors.getTextColor(isDark),
      indicatorColor: primary.withValues(alpha: .2),
      primaryColor: primary.withValues(alpha: .2),
      surahNameColor: AppColors.getTextColor(isDark),
      surahNumberColor: AppColors.getTextColor(isDark),
      textColor: AppColors.getTextColor(isDark),
      titleColor: AppColors.getTextColor(isDark),
      bottomSheetWidth: MediaQuery.of(context).size.width,
      bottomSheetHeight: MediaQuery.of(context).size.height * 0.9,
    );
  }
}
