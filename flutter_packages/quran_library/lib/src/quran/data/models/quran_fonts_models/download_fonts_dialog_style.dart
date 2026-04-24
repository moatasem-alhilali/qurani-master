part of '/quran.dart';

/// A class that defines the style for the download fonts dialog.
///
/// This class can be used to customize the appearance and behavior of the
/// dialog that is shown when downloading fonts in the application.
class DownloadFontsDialogStyle {
  /// The background color of the dialog. This can be null, in which case
  /// the default background color will be used.
  final Color? backgroundColor;

  /// The text to be displayed as the title for the default font.
  @Deprecated('استخدم recitationNames بدلًا من defaultFontText.')
  final String? defaultFontText;

  /// The color of the divider in the dialog. This can be null, in which case
  /// the default color will be used.
  final Color? dividerColor;

  /// The text to be displayed as the title for the quran font.
  @Deprecated('استخدم recitationNames بدلًا من downloadedFontsText.')
  final String? downloadedFontsText;

  /// أسماء مخصّصة لقائمة القراءات/الخطوط.
  ///
  /// إذا تم تمرير هذه القائمة، فسيتم استخدام الاسم الموافق لترتيب
  /// [QuranRecitation.values] عند العرض. إذا لم يوجد عنصر في القائمة للمؤشر
  /// المطلوب، فسيتم الرجوع للاسم الافتراضي [QuranRecitation.arabicName].
  final List<String>? recitationNames;

  /// The background color of the download button in the dialog.
  ///
  /// This property allows you to customize the appearance of the download button
  /// by specifying a [Color]. If no color is provided, the default color will be used.
  final Color? downloadButtonBackgroundColor;

  /// The text to be displayed while the font is being downloaded.

  final String? downloadingText;

  /// The text style to be applied to the downloading text in the dialog.
  ///
  /// This style can be used to customize the appearance of the text
  /// displayed while fonts are being downloaded.
  ///
  /// If no style is provided, the default text style will be used.
  final TextStyle? downloadingStyle;

  /// The text style for displaying the font name in the download fonts dialog.
  ///
  /// This style can be customized to change the appearance of the font name text.
  ///
  /// If no style is provided, the default text style will be used.
  final TextStyle? fontNameStyle;

  /// An optional widget to display an icon in the dialog.
  ///
  /// This widget can be used to provide a custom icon for the dialog,
  /// enhancing the visual representation and user experience.
  final Widget? iconWidget;

  /// The color of the icon in the dialog.
  ///
  /// This property allows you to customize the color of the icon displayed
  /// in the download fonts dialog. If no color is provided, the default
  /// color will be used.
  final Color? iconColor;

  /// The size of the icon to be displayed in the dialog.
  ///
  /// This property is optional and can be null. If null, a default size
  /// will be used.
  final double? iconSize;

  /// The background color for the linear progress indicator in the download fonts dialog.
  ///
  /// This color is used to fill the background of the linear progress indicator.
  /// If no color is provided, the default color will be used.
  final Color? linearProgressBackgroundColor;

  /// The color of the linear progress indicator.
  ///
  /// This property is optional and can be null. If null, the default color
  /// will be used.
  final Color? linearProgressColor;

  /// Optional notes associated with the download fonts dialog style.
  final String? notes;

  /// The color used for notes in the download fonts dialog.
  ///
  /// This property is optional and can be null.
  final Color? notesColor;

  /// The text style to be applied to the notes section in the download fonts dialog.
  ///
  /// This style can be customized to change the appearance of the notes text.
  /// If no style is provided, the default text style will be used.
  final TextStyle? notesStyle;

  /// The color of the title text in the download fonts dialog.
  ///
  /// This property allows you to customize the color of the title text.
  /// If no color is provided, the default color will be used.
  final Color? titleColor;

  /// The style to be applied to the title text in the download fonts dialog.
  ///
  /// This property allows you to customize the appearance of the title text,
  /// such as font size, color, weight, etc. If no style is provided, the default
  /// style will be used.
  final TextStyle? titleStyle;

  /// The text to be displayed as the header title in the download fonts dialog.
  ///
  /// This property allows you to customize the header title text.
  /// If no text is provided, the default header title will be used.
  final String? headerTitle;

  /// The color of the close icon in the download fonts dialog.
  ///
  /// This property allows you to customize the color of the close icon.
  /// If no color is provided, the default color will be used.
  final Color? closeIconColor;

  /// The background gradient for the header of the download fonts dialog.
  ///
  /// This property allows you to customize the background appearance
  /// of the header by providing a [Gradient]. If no gradient is provided,
  /// the default background will be used.
  final Gradient? backgroundGradient;

  // final String? downloadedNotesBody;
  // final Color? downloadButtonTextColor;
  // final String? downloadButtonText;
  // final String? deleteButtonText;
  // final String? downloadedFontsTajweedText;
  // final String? downloadedNotesTitle;
  // final String? withTajweedText;
  // final String? withoutTajweedText;
  final String? tajweedOptionNames;

  /// A class representing the style for the download fonts dialog.
  ///
  /// This class is used to define the visual appearance and behavior of the
  /// dialog that is shown when downloading fonts in the Quran Library.
  ///
  /// The [DownloadFontsDialogStyle] constructor allows you to create an instance
  /// of this class with specific style properties.
  DownloadFontsDialogStyle({
    this.backgroundColor,
    this.defaultFontText,
    this.dividerColor,
    this.downloadedFontsText,
    this.recitationNames,
    this.downloadButtonBackgroundColor,
    this.downloadingStyle,
    this.downloadingText,
    this.fontNameStyle,
    this.iconColor,
    this.iconSize,
    this.iconWidget,
    this.linearProgressBackgroundColor,
    this.linearProgressColor,
    this.notes,
    this.notesColor,
    this.notesStyle,
    this.titleColor,
    this.titleStyle,
    this.headerTitle,
    this.closeIconColor,
    this.backgroundGradient,
    this.tajweedOptionNames,
  });

  /// Creates a copy of the current [DownloadFontsDialogStyle] instance with the
  /// specified properties replaced by new values.
  ///
  /// This method allows you to create a modified version of the current style
  /// by providing new values for specific properties while keeping the rest
  /// unchanged.
  DownloadFontsDialogStyle copyWith({
    Color? backgroundColor,
    String? defaultFontText,
    Color? dividerColor,
    String? downloadedFontsText,
    List<String>? recitationNames,
    Color? downloadButtonBackgroundColor,
    TextStyle? downloadingStyle,
    String? downloadingText,
    TextStyle? fontNameStyle,
    Color? iconColor,
    double? iconSize,
    Widget? iconWidget,
    Color? linearProgressBackgroundColor,
    Color? linearProgressColor,
    String? notes,
    Color? notesColor,
    TextStyle? notesStyle,
    String? title,
    Color? titleColor,
    TextStyle? titleStyle,
    String? headerTitle,
    Color? closeIconColor,
    Gradient? backgroundGradient,
    String? tajweedOptionNames,
  }) {
    return DownloadFontsDialogStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        defaultFontText: defaultFontText ?? this.defaultFontText,
        dividerColor: dividerColor ?? this.dividerColor,
        downloadedFontsText: downloadedFontsText ?? this.downloadedFontsText,
        recitationNames: recitationNames ?? this.recitationNames,
        downloadButtonBackgroundColor:
            downloadButtonBackgroundColor ?? this.downloadButtonBackgroundColor,
        downloadingStyle: downloadingStyle ?? this.downloadingStyle,
        downloadingText: downloadingText ?? this.downloadingText,
        fontNameStyle: fontNameStyle ?? this.fontNameStyle,
        iconColor: iconColor ?? this.iconColor,
        iconSize: iconSize ?? this.iconSize,
        iconWidget: iconWidget ?? this.iconWidget,
        linearProgressBackgroundColor:
            linearProgressBackgroundColor ?? this.linearProgressBackgroundColor,
        linearProgressColor: linearProgressColor ?? this.linearProgressColor,
        notes: notes ?? this.notes,
        notesColor: notesColor ?? this.notesColor,
        notesStyle: notesStyle ?? this.notesStyle,
        titleColor: titleColor ?? this.titleColor,
        titleStyle: titleStyle ?? this.titleStyle,
        headerTitle: headerTitle ?? this.headerTitle,
        closeIconColor: closeIconColor ?? this.closeIconColor,
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
        tajweedOptionNames: tajweedOptionNames ?? this.tajweedOptionNames);
  }

  /// A method to create default styles for the download fonts dialog.
  ///
  /// This method provides a convenient way to generate a [DownloadFontsDialogStyle]
  /// instance with predefined default values for various style properties.
  /// If no custom values are provided, the default values will be used.
  static DownloadFontsDialogStyle defaults(
      bool isDarkMode, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return DownloadFontsDialogStyle(
      // لون خلفية النافذة الافتراضي
      backgroundColor: AppColors.getBackgroundColor(isDarkMode),
      // لون الفاصل الافتراضي
      dividerColor: primary,
      // لا نضع أسماء افتراضية هنا: الواجهة ستستخدم QuranRecitation.arabicName.
      defaultFontText: null,
      downloadedFontsText: null,
      recitationNames: null,
      // لون خلفية زر التحميل الافتراضي
      downloadButtonBackgroundColor: primary,
      // نص التحميل الافتراضي
      downloadingText: 'جاري التحميل...',
      // نمط نص التحميل الافتراضي
      downloadingStyle: TextStyle(
        fontSize: 14.0,
        color: AppColors.getTextColor(isDarkMode),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      // نمط اسم الخط الافتراضي
      fontNameStyle: TextStyle(
        fontSize: 16.0,
        color: AppColors.getTextColor(isDarkMode),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      // لون خلفية مؤشر التقدم الخطي الافتراضي
      linearProgressBackgroundColor: primary,
      // لون مؤشر التقدم الخطي الافتراضي
      linearProgressColor: primary.withValues(alpha: .6),
      // لون نص العنوان الافتراضي
      titleColor: AppColors.getTextColor(isDarkMode),
      // نمط نص العنوان الافتراضي
      titleStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextColor(isDarkMode),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      // عنوان ترويسة النافذة الافتراضي
      headerTitle: 'الخطوط',
      // لون أيقونة الإغلاق الافتراضي
      closeIconColor: AppColors.getTextColor(isDarkMode),
      backgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withValues(alpha: 0.15),
          primary.withValues(alpha: 0.05),
        ],
      ),
      iconColor: primary,
      iconSize: 24.0,
      iconWidget: SvgPicture.asset(AssetsPath.assets.options,
          height: 24.0,
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
      notes: 'لجعل مظهر المصحف مشابه لمصحف المدينة يمكنك تحميل خطوط المصحف',
      notesColor: AppColors.getTextColor(isDarkMode),
      notesStyle: TextStyle(
        fontSize: 14.0,
        color: AppColors.getTextColor(isDarkMode),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tajweedOptionNames: 'مع التجويد',
    );
  }
}
