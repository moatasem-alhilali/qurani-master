part of '../../audio.dart';

/// فئة لتخصيص أنماط واجهة تشغيل السور الصوتية
/// Class for customizing Surah audio interface styles
class SurahAudioStyle {
  /// لون النص الأساسي
  /// Primary text color
  final Color? textColor;

  /// مسار أيقونة التشغيل المخصصة
  /// Custom play icon path
  final String? playIconPath;

  /// ارتفاع أيقونة التشغيل
  /// Play icon height
  final double? playIconHeight;

  /// لون أيقونة التشغيل
  /// Play icon color
  final Color? playIconColor;

  /// مسار أيقونة الإيقاف المخصصة
  /// Custom pause icon path
  final String? pauseIconPath;

  /// ارتفاع أيقونة الإيقاف
  /// Pause icon height
  final double? pauseIconHeight;

  /// ارتفاع أيقونة السابق
  /// Previous icon height
  final double? previousIconHeight;

  /// ارتفاع أيقونة التالي
  /// Next icon height
  final double? nextIconHeight;

  /// لون اسم القارئ في العنصر
  /// Reader name color in item
  final Color? readerNameInItemColor;

  /// حجم خط اسم القارئ في العنصر
  /// Reader name font size in item
  final double? readerNameInItemFontSize;

  /// حجم خط اسم القارئ
  /// Reader name font size
  final double? readerNameFontSize;

  /// لون إبهام شريط التقدم
  /// Seek bar thumb color
  final Color? seekBarThumbColor;

  /// لون المسار النشط لشريط التقدم
  /// Seek bar active track color
  final Color? seekBarActiveTrackColor;

  /// لون المسار غير النشط لشريط التقدم
  /// Seek bar inactive track color
  final Color? seekBarInactiveTrackColor;

  /// الحشو الأفقي لشريط التقدم
  /// Seek bar horizontal padding
  final double? seekBarHorizontalPadding;

  /// لون الخلفية الأساسي
  /// Primary background color
  final Color? backgroundColor;

  /// نصف قطر الحدود
  /// Border radius
  final double? borderRadius;

  /// لون خلفية النوافذ المنبثقة
  /// Dialog background color
  final Color? dialogBackgroundColor;

  /// نصف قطر حدود النوافذ المنبثقة
  /// Dialog border radius
  final double? dialogBorderRadius;

  /// لون العنصر المحدد
  /// Selected item color
  final Color? selectedItemColor;

  /// لون الأيقونات الثانوية
  /// Secondary icons color
  final Color? secondaryIconColor;

  /// حجم الخط الثانوي
  /// Secondary font size
  final double? secondaryFontSize;

  /// لون الخط الثانوي
  /// Secondary text color
  final Color? secondaryTextColor;

  /// اللون الأساسي للواجهة
  /// Primary interface color
  final Color? primaryColor;

  /// لون الأيقونات العامة
  /// General icons color
  final Color? iconColor;

  /// لون أيقونة الرجوع العامة
  /// General back icon color
  final Color? backIconColor;

  /// لون الأيقونات العامة
  /// General icons color
  final Color? audioSliderBackgroundColor;

  /// لون اسم السورة
  /// Surah name color
  final Color? surahNameColor;

  /// ارتفاع نافذة اختيار القارئ
  /// Reader dialog max height
  final double? dialogHeight;

  /// عرض نافذة اختيار القارئ
  /// Reader dialog max width
  final double? dialogWidth;

  /// عنوان ترويسة نافذة القارئ
  /// Reader dialog header title
  final String? dialogHeaderTitle;

  /// لون عنوان ترويسة نافذة القارئ
  /// Reader dialog header title color
  final Color? dialogHeaderTitleColor;

  /// لون أيقونة الإغلاق في الترويسة
  /// Reader dialog header close icon color
  final Color? dialogCloseIconColor;

  /// تدرج خلفية الترويسة في نافذة القارئ
  /// Reader dialog header background gradient
  final Gradient? dialogHeaderBackgroundGradient;

  /// لون العنصر المحدد في نافذة القارئ
  /// Selected color in reader dialog
  final Color? dialogSelectedReaderColor;

  /// لون العنصر غير المحدد في نافذة القارئ
  /// Unselected base color in reader dialog
  final Color? dialogUnSelectedReaderColor;

  /// لون نص العنصر في نافذة القارئ
  /// Reader text color in dialog list
  final Color? dialogReaderTextColor;

  /// إظهار شريط التطبيق
  /// Show app bar
  final bool? withAppBar;

  /// نص "آية" المخصص
  /// Custom "ayah" text (singular)
  final String? ayahSingularText;

  /// نص "آيات" المخصص
  /// Custom "ayat" text (plural)
  final String? ayahPluralText;

  /// نص "آخر إستماع" المخصص
  /// Custom "last listen" text
  final String? lastListenText;

  /// لون "شريط التقدم" المخصص
  /// Custom "progress" color
  final Color? downloadProgressColor;

  /// نص "لا يوجد اتصال بالإنترنت" المخصص
  /// Custom "no internet connection" text
  final String? noInternetConnectionText;

  /// لون حاوية الوقت المخصص
  /// Custom "time container" color
  final Color? timeContainerColor;

  /// منشئ فئة SurahAudioStyle
  /// SurahAudioStyle class constructor
  SurahAudioStyle({
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
    this.selectedItemColor,
    this.secondaryIconColor,
    this.secondaryFontSize,
    this.secondaryTextColor,
    this.primaryColor,
    this.iconColor,
    this.audioSliderBackgroundColor,
    this.surahNameColor,
    this.dialogHeight,
    this.dialogWidth,
    this.dialogHeaderTitleColor,
    this.dialogCloseIconColor,
    this.dialogHeaderBackgroundGradient,
    this.dialogSelectedReaderColor,
    this.dialogUnSelectedReaderColor,
    this.dialogReaderTextColor,
    this.withAppBar,
    this.ayahSingularText,
    this.ayahPluralText,
    this.lastListenText,
    this.dialogHeaderTitle,
    this.backIconColor,
    this.downloadProgressColor,
    this.noInternetConnectionText,
    this.timeContainerColor,
  });

  SurahAudioStyle copyWith({
    Color? textColor,
    String? playIconPath,
    double? playIconHeight,
    Color? playIconColor,
    String? pauseIconPath,
    double? pauseIconHeight,
    Color? readerNameInItemColor,
    double? readerNameInItemFontSize,
    double? readerNameFontSize,
    Color? seekBarThumbColor,
    Color? seekBarActiveTrackColor,
    Color? seekBarInactiveTrackColor,
    double? seekBarHorizontalPadding,
    double? previousIconHeight,
    double? nextIconHeight,
    Color? backgroundColor,
    double? borderRadius,
    Color? dialogBackgroundColor,
    double? dialogBorderRadius,
    Color? selectedItemColor,
    Color? secondaryIconColor,
    double? secondaryFontSize,
    Color? secondaryTextColor,
    Color? primaryColor,
    Color? iconColor,
    Color? audioSliderBackgroundColor,
    Color? surahNameColor,
    double? dialogHeight,
    double? dialogWidth,
    Color? dialogHeaderTitleColor,
    Color? dialogCloseIconColor,
    Gradient? dialogHeaderBackgroundGradient,
    Color? dialogSelectedReaderColor,
    Color? dialogUnSelectedReaderColor,
    Color? dialogReaderTextColor,
    bool? withAppBar,
    String? ayahSingularText,
    String? ayahPluralText,
    String? lastListenText,
    String? dialogHeaderTitle,
    Color? backIconColor,
    Color? downloadProgressColor,
    String? noInternetConnectionText,
    Color? timeContainerColor,
  }) {
    return SurahAudioStyle(
      textColor: textColor ?? this.textColor,
      playIconPath: playIconPath ?? this.playIconPath,
      playIconHeight: playIconHeight ?? this.playIconHeight,
      playIconColor: playIconColor ?? this.playIconColor,
      pauseIconPath: pauseIconPath ?? this.pauseIconPath,
      pauseIconHeight: pauseIconHeight ?? this.pauseIconHeight,
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
      previousIconHeight: previousIconHeight ?? this.previousIconHeight,
      nextIconHeight: nextIconHeight ?? this.nextIconHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      dialogBackgroundColor:
          dialogBackgroundColor ?? this.dialogBackgroundColor,
      dialogBorderRadius: dialogBorderRadius ?? this.dialogBorderRadius,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      secondaryIconColor: secondaryIconColor ?? this.secondaryIconColor,
      secondaryFontSize: secondaryFontSize ?? this.secondaryFontSize,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      primaryColor: primaryColor ?? this.primaryColor,
      iconColor: iconColor ?? this.iconColor,
      audioSliderBackgroundColor:
          audioSliderBackgroundColor ?? this.audioSliderBackgroundColor,
      surahNameColor: surahNameColor ?? this.surahNameColor,
      dialogHeight: dialogHeight ?? this.dialogHeight,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      dialogHeaderTitleColor:
          dialogHeaderTitleColor ?? this.dialogHeaderTitleColor,
      dialogCloseIconColor: dialogCloseIconColor ?? this.dialogCloseIconColor,
      dialogHeaderBackgroundGradient:
          dialogHeaderBackgroundGradient ?? this.dialogHeaderBackgroundGradient,
      dialogSelectedReaderColor:
          dialogSelectedReaderColor ?? this.dialogSelectedReaderColor,
      dialogUnSelectedReaderColor:
          dialogUnSelectedReaderColor ?? this.dialogUnSelectedReaderColor,
      dialogReaderTextColor:
          dialogReaderTextColor ?? this.dialogReaderTextColor,
      withAppBar: withAppBar ?? this.withAppBar,
      ayahSingularText: ayahSingularText ?? this.ayahSingularText,
      ayahPluralText: ayahPluralText ?? this.ayahPluralText,
      lastListenText: lastListenText ?? this.lastListenText,
      dialogHeaderTitle: dialogHeaderTitle ?? this.dialogHeaderTitle,
      backIconColor: backIconColor ?? this.backIconColor,
      downloadProgressColor:
          downloadProgressColor ?? this.downloadProgressColor,
      noInternetConnectionText:
          noInternetConnectionText ?? this.noInternetConnectionText,
      timeContainerColor: timeContainerColor ?? this.timeContainerColor,
    );
  }

  /// القيم الافتراضية الموحدة حسب الثيم
  /// Unified defaults based on theme
  factory SurahAudioStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final bg = AppColors.getBackgroundColor(isDark);
    final onBg = AppColors.getTextColor(isDark);
    final primary = scheme.primary;

    return SurahAudioStyle(
      // ألوان عامة
      backgroundColor: bg,
      textColor: onBg,
      primaryColor: primary,
      backIconColor: primary,
      iconColor: onBg,
      surahNameColor: onBg,
      audioSliderBackgroundColor:
          isDark ? const Color(0xFF1E1E1E) : bg.withValues(alpha: 0.98),

      // الحدّ ونصف القطر
      borderRadius: 16.0,
      dialogBorderRadius: 12.0,
      dialogBackgroundColor: bg,

      // خصائص نافذة اختيار القارئ
      dialogHeight: MediaQuery.of(context).size.height * 0.7,
      dialogWidth: MediaQuery.of(context).size.width * 0.6,
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

      // عناصر التحكم
      playIconColor: primary,
      pauseIconHeight: 38.0,
      playIconHeight: 38.0,
      previousIconHeight: 38.0,
      nextIconHeight: 38.0,

      // شريط التقدم
      seekBarThumbColor: primary,
      seekBarActiveTrackColor: primary,
      seekBarInactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
      seekBarHorizontalPadding: 32.0,

      // نصوص ثانوية وايقونات ثانوية
      secondaryTextColor: onBg.withValues(alpha: 0.75),
      secondaryIconColor: onBg.withValues(alpha: 0.70),
      secondaryFontSize: 14.0,

      // أسماء/أحجام
      readerNameFontSize: 16.0,
      readerNameInItemFontSize: 14.0,
      readerNameInItemColor: onBg,

      // حالات التحديد
      selectedItemColor: primary.withValues(alpha: 0.10),
      withAppBar: true,

      // نصوص الآيات الافتراضية
      ayahSingularText: 'آية',
      ayahPluralText: 'آيات',

      // نص آخر استماع الافتراضي
      lastListenText: 'آخر إستماع',
      dialogHeaderTitle: 'تغيير القارئ',
      downloadProgressColor: Colors.white,
      noInternetConnectionText: 'لا يوجد اتصال بالإنترنت',
      timeContainerColor: primary,
    );
  }
}
