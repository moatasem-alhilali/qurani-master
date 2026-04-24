part of '../../../tafsir.dart';

class TafsirStyle {
  final Widget? tafsirNameWidget;
  final Widget? fontSizeWidget;
  final String? translateName;
  final String? tafsirName;
  final Color? currentTafsirColor;
  final Color? textTitleColor;
  final Color? backgroundTitleColor;
  final Color? selectedTafsirColor;
  final Color? unSelectedTafsirColor;
  final Color? selectedTafsirTextColor;
  final Color? unSelectedTafsirTextColor;
  final Color? selectedTafsirBorderColor;
  final Color? unSelectedTafsirBorderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? tafsirBackgroundColor;
  final Color? dividerColor;
  final double? fontSize;
  final String? footnotesName;
  final double? horizontalMargin;
  final double? verticalMargin;
  final String? tafsirIsEmptyNote;
  final double? heightOfBottomSheet;
  final double? widthOfBottomSheet;
  final double? changeTafsirDialogHeight;
  final double? changeTafsirDialogWidth;
  final Widget? fontSizeIconWidget;
  final Color? fontSizeBackgroundColor;
  final Color? fontSizeThumbColor;
  final Color? fontSizeActiveTrackColor;
  final Color? fontSizeInactiveTrackColor;
  final double? fontSizeIconSize;
  final Color? downloadIconColor;
  final Gradient? dialogHeaderBackgroundGradient;
  final Color? dialogHeaderTitleColor;
  final String? dialogHeaderTitle;
  final Color? dialogCloseIconColor;

  // Tajweed (Ayah) tab texts/styles
  final String? tajweedSurahNumberErrorText;
  final String? tajweedUnavailableText;
  final String? tajweedDownloadText;
  final String? tajweedDownloadingText;
  final String? tajweedLoadErrorText;
  final String? tajweedNoDataText;
  final TextStyle? tajweedAyahTextStyle;
  final TextStyle? tajweedMarkedTextStyle;
  final TextStyle? tajweedStatusTextStyle;
  final TextStyle? tajweedButtonTextStyle;
  final TextStyle? tajweedProgressTextStyle;
  final TextStyle? tajweedContentTextStyle;
  final TextStyle? tabBarLabelStyle;
  final TextStyle? tabBarUnselectedLabelStyle;
  final TextStyle? dialogHeaderTitleTextStyle;
  final TextStyle? dialogTypeTextStyle;
  final TextStyle? tafsirTextTextStyle;
  final TextStyle? currentTafsirTextStyle;
  final Widget? handleWidget;
  final Widget? tajweedDownloadButtonWidget;
  final Color? dialogBackgroundColor;
  final Widget? removeTafsirIconWidget;
  final Widget? downloadTafsirIconWidget;

  /// ويدجت مخصص بدلاً من أيقونة السهم الافتراضية بجانب اسم القارئ
  /// Custom widget to replace the default dropdown arrow icon next to reader name
  final Widget? tafsirDropdownWidget;

  TafsirStyle({
    this.backgroundColor,
    this.textColor,
    this.fontSizeWidget,
    this.tafsirNameWidget,
    this.translateName,
    this.tafsirName,
    this.textTitleColor,
    this.currentTafsirColor,
    this.backgroundTitleColor,
    this.selectedTafsirColor,
    this.unSelectedTafsirColor,
    this.selectedTafsirBorderColor,
    this.unSelectedTafsirBorderColor,
    this.selectedTafsirTextColor,
    this.unSelectedTafsirTextColor,
    this.fontSize,
    this.footnotesName,
    this.dividerColor,
    this.horizontalMargin,
    this.verticalMargin,
    this.tafsirBackgroundColor,
    this.tafsirIsEmptyNote,
    this.heightOfBottomSheet,
    this.widthOfBottomSheet,
    this.changeTafsirDialogHeight,
    this.changeTafsirDialogWidth,
    this.fontSizeIconWidget,
    this.fontSizeBackgroundColor,
    this.fontSizeThumbColor,
    this.fontSizeActiveTrackColor,
    this.fontSizeInactiveTrackColor,
    this.fontSizeIconSize,
    this.downloadIconColor,
    this.dialogHeaderBackgroundGradient,
    this.dialogHeaderTitleColor,
    this.dialogHeaderTitle,
    this.dialogCloseIconColor,
    this.tajweedSurahNumberErrorText,
    this.tajweedUnavailableText,
    this.tajweedDownloadText,
    this.tajweedDownloadingText,
    this.tajweedLoadErrorText,
    this.tajweedNoDataText,
    this.tajweedAyahTextStyle,
    this.tajweedMarkedTextStyle,
    this.tajweedStatusTextStyle,
    this.tajweedButtonTextStyle,
    this.tajweedProgressTextStyle,
    this.tajweedContentTextStyle,
    this.tabBarLabelStyle,
    this.handleWidget,
    this.tabBarUnselectedLabelStyle,
    this.dialogHeaderTitleTextStyle,
    this.dialogTypeTextStyle,
    this.tafsirTextTextStyle,
    this.currentTafsirTextStyle,
    this.tajweedDownloadButtonWidget,
    this.tafsirDropdownWidget,
    this.dialogBackgroundColor,
    this.removeTafsirIconWidget,
    this.downloadTafsirIconWidget,
  });

  TafsirStyle copyWith({
    Widget? tafsirNameWidget,
    Widget? fontSizeWidget,
    String? translateName,
    String? tafsirName,
    Color? currentTafsirColor,
    Color? textTitleColor,
    Color? backgroundTitleColor,
    Color? selectedTafsirColor,
    Color? unSelectedTafsirColor,
    Color? selectedTafsirTextColor,
    Color? unSelectedTafsirTextColor,
    Color? selectedTafsirBorderColor,
    Color? unSelectedTafsirBorderColor,
    Color? backgroundColor,
    Color? textColor,
    Color? tafsirBackgroundColor,
    Color? dividerColor,
    double? fontSize,
    String? footnotesName,
    double? horizontalMargin,
    double? verticalMargin,
    String? tafsirIsEmptyNote,
    double? heightOfBottomSheet,
    double? widthOfBottomSheet,
    double? changeTafsirDialogHeight,
    double? changeTafsirDialogWidth,
    Widget? fontSizeIconWidget,
    Color? fontSizeBackgroundColor,
    Color? fontSizeThumbColor,
    Color? fontSizeActiveTrackColor,
    Color? fontSizeInactiveTrackColor,
    double? fontSizeIconSize,
    Color? downloadIconColor,
    Gradient? dialogHeaderBackgroundGradient,
    Color? dialogHeaderTitleColor,
    String? dialogHeaderTitle,
    Color? dialogCloseIconColor,
    String? tajweedSurahNumberErrorText,
    String? tajweedUnavailableText,
    String? tajweedDownloadText,
    String? tajweedDownloadingText,
    String? tajweedLoadErrorText,
    String? tajweedNoDataText,
    TextStyle? tajweedAyahTextStyle,
    TextStyle? tajweedMarkedTextStyle,
    TextStyle? tajweedStatusTextStyle,
    TextStyle? tajweedButtonTextStyle,
    TextStyle? tajweedProgressTextStyle,
    TextStyle? tajweedContentTextStyle,
    TextStyle? tabBarLabelStyle,
    TextStyle? tabBarUnselectedLabelStyle,
    Widget? handleWidget,
    TextStyle? dialogHeaderTitleTextStyle,
    TextStyle? dialogTypeTextStyle,
    TextStyle? tafsirTextTextStyle,
    TextStyle? currentTafsirTextStyle,
    Widget? tajweedDownloadButtonWidget,
    Widget? tafsirDropdownWidget,
    Color? dialogBackgroundColor,
    Widget? removeTafsirIconWidget,
    Widget? downloadTafsirIconWidget,
  }) {
    return TafsirStyle(
      tafsirNameWidget: tafsirNameWidget ?? this.tafsirNameWidget,
      fontSizeWidget: fontSizeWidget ?? this.fontSizeWidget,
      translateName: translateName ?? this.translateName,
      tafsirName: tafsirName ?? this.tafsirName,
      currentTafsirColor: currentTafsirColor ?? this.currentTafsirColor,
      textTitleColor: textTitleColor ?? this.textTitleColor,
      backgroundTitleColor: backgroundTitleColor ?? this.backgroundTitleColor,
      selectedTafsirColor: selectedTafsirColor ?? this.selectedTafsirColor,
      unSelectedTafsirColor:
          unSelectedTafsirColor ?? this.unSelectedTafsirColor,
      selectedTafsirTextColor:
          selectedTafsirTextColor ?? this.selectedTafsirTextColor,
      unSelectedTafsirTextColor:
          unSelectedTafsirTextColor ?? this.unSelectedTafsirTextColor,
      selectedTafsirBorderColor:
          selectedTafsirBorderColor ?? this.selectedTafsirBorderColor,
      unSelectedTafsirBorderColor:
          unSelectedTafsirBorderColor ?? this.unSelectedTafsirBorderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      tafsirBackgroundColor:
          tafsirBackgroundColor ?? this.tafsirBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      fontSize: fontSize ?? this.fontSize,
      footnotesName: footnotesName ?? this.footnotesName,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      tafsirIsEmptyNote: tafsirIsEmptyNote ?? this.tafsirIsEmptyNote,
      heightOfBottomSheet: heightOfBottomSheet ?? this.heightOfBottomSheet,
      widthOfBottomSheet: widthOfBottomSheet ?? this.widthOfBottomSheet,
      changeTafsirDialogHeight:
          changeTafsirDialogHeight ?? this.changeTafsirDialogHeight,
      changeTafsirDialogWidth:
          changeTafsirDialogWidth ?? this.changeTafsirDialogWidth,
      fontSizeIconWidget: fontSizeIconWidget ?? this.fontSizeIconWidget,
      fontSizeBackgroundColor:
          fontSizeBackgroundColor ?? this.fontSizeBackgroundColor,
      fontSizeThumbColor: fontSizeThumbColor ?? this.fontSizeThumbColor,
      fontSizeActiveTrackColor:
          fontSizeActiveTrackColor ?? this.fontSizeActiveTrackColor,
      fontSizeInactiveTrackColor:
          fontSizeInactiveTrackColor ?? this.fontSizeInactiveTrackColor,
      fontSizeIconSize: fontSizeIconSize ?? this.fontSizeIconSize,
      downloadIconColor: downloadIconColor ?? this.downloadIconColor,
      dialogHeaderBackgroundGradient:
          dialogHeaderBackgroundGradient ?? this.dialogHeaderBackgroundGradient,
      dialogHeaderTitleColor:
          dialogHeaderTitleColor ?? this.dialogHeaderTitleColor,
      dialogHeaderTitle: dialogHeaderTitle ?? this.dialogHeaderTitle,
      dialogCloseIconColor: dialogCloseIconColor ?? this.dialogCloseIconColor,
      tajweedSurahNumberErrorText:
          tajweedSurahNumberErrorText ?? this.tajweedSurahNumberErrorText,
      tajweedUnavailableText:
          tajweedUnavailableText ?? this.tajweedUnavailableText,
      tajweedDownloadText: tajweedDownloadText ?? this.tajweedDownloadText,
      tajweedDownloadingText:
          tajweedDownloadingText ?? this.tajweedDownloadingText,
      tajweedLoadErrorText: tajweedLoadErrorText ?? this.tajweedLoadErrorText,
      tajweedNoDataText: tajweedNoDataText ?? this.tajweedNoDataText,
      tajweedAyahTextStyle: tajweedAyahTextStyle ?? this.tajweedAyahTextStyle,
      tajweedMarkedTextStyle:
          tajweedMarkedTextStyle ?? this.tajweedMarkedTextStyle,
      tajweedStatusTextStyle:
          tajweedStatusTextStyle ?? this.tajweedStatusTextStyle,
      tajweedButtonTextStyle:
          tajweedButtonTextStyle ?? this.tajweedButtonTextStyle,
      tajweedProgressTextStyle:
          tajweedProgressTextStyle ?? this.tajweedProgressTextStyle,
      tajweedContentTextStyle:
          tajweedContentTextStyle ?? this.tajweedContentTextStyle,
      tabBarLabelStyle: tabBarLabelStyle ?? this.tabBarLabelStyle,
      handleWidget: handleWidget ?? this.handleWidget,
      tabBarUnselectedLabelStyle:
          tabBarUnselectedLabelStyle ?? this.tabBarUnselectedLabelStyle,
      dialogHeaderTitleTextStyle:
          dialogHeaderTitleTextStyle ?? this.dialogHeaderTitleTextStyle,
      dialogTypeTextStyle: dialogTypeTextStyle ?? this.dialogTypeTextStyle,
      tafsirTextTextStyle: tafsirTextTextStyle ?? this.tafsirTextTextStyle,
      currentTafsirTextStyle:
          currentTafsirTextStyle ?? this.currentTafsirTextStyle,
      tajweedDownloadButtonWidget:
          tajweedDownloadButtonWidget ?? this.tajweedDownloadButtonWidget,
      tafsirDropdownWidget: tafsirDropdownWidget ?? this.tafsirDropdownWidget,
      dialogBackgroundColor:
          dialogBackgroundColor ?? this.dialogBackgroundColor,
      removeTafsirIconWidget:
          removeTafsirIconWidget ?? this.removeTafsirIconWidget,
      downloadTafsirIconWidget:
          downloadTafsirIconWidget ?? this.downloadTafsirIconWidget,
    );
  }

  factory TafsirStyle.defaults(
      {required bool isDark, required BuildContext context}) {
    final bg = AppColors.getBackgroundColor(isDark);
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final onBg = isDark ? Colors.white : Colors.black87;
    final titleOnBg = primary;

    // أسماء افتراضية نصية
    const defaultTafsirName = 'التفسير';
    const defaultTranslateName = 'الترجمة';
    const defaultFootnotesName = 'الحواشي';
    const defaultEmptyNote = '\n\nتفسير هذه الآية في الأيات السابقة';

    // نصوص افتراضية لتبويب أحكام التجويد
    const tajweedSurahNumberError = 'تعذّر تحديد رقم السورة';
    const tajweedUnavailable = 'بيانات أحكام التجويد غير محمّلة.';
    const tajweedDownload = 'تحميل';
    const tajweedDownloading = 'جاري التحميل...';
    const tajweedLoadError = 'تعذّر تحميل أحكام التجويد.';
    const tajweedNoData = 'لا توجد بيانات تجويد لهذه الآية.';

    return TafsirStyle(
      // الألوان العامة
      backgroundColor: bg,
      textColor: AppColors.getTextColor(isDark),
      tafsirBackgroundColor: isDark ? const Color(0xFF151515) : Colors.white,
      dividerColor: isDark ? Colors.grey.shade600 : Colors.grey.shade400,

      // العناوين والشريط العلوي
      textTitleColor: Colors.white,
      backgroundTitleColor: primary,
      currentTafsirColor: primary,

      // ألوان عناصر الاختيار للقوائم/الأزرار داخل شاشة التفسير
      selectedTafsirColor: primary.withValues(alpha: .10),
      unSelectedTafsirColor:
          isDark ? const Color(0xFF1F1F1F) : Colors.transparent,
      selectedTafsirTextColor: onBg,
      unSelectedTafsirTextColor: onBg,
      selectedTafsirBorderColor: primary,
      unSelectedTafsirBorderColor: primary.withValues(alpha: 0.3),
      changeTafsirDialogHeight: MediaQuery.of(context).size.height * 0.7,
      changeTafsirDialogWidth: MediaQuery.of(context).size.width,

      // النصوص والأحجام
      fontSize: 18.0,
      footnotesName: defaultFootnotesName,
      tafsirIsEmptyNote: defaultEmptyNote,

      // الهوامش
      horizontalMargin: 8.0,
      verticalMargin: 4.0,

      // الحجم المقترح للـ BottomSheet
      heightOfBottomSheet: MediaQuery.of(context).size.height * 0.9,
      widthOfBottomSheet: null, // MediaQuery.of(context).size.width,

      // الأسماء
      translateName: defaultTranslateName,
      tafsirName: defaultTafsirName,

      // ودجت اسم التفسير
      tafsirNameWidget: Text(
        defaultTafsirName,
        style: QuranLibrary().cairoStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleOnBg,
            ),
      ),

      // ودجت تغيير الخط
      fontSizeWidget: const SizedBox().fontSizeDropDown(
        height: 30.0,
        isDark: isDark,
      ),

      fontSizeIconWidget: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Icon(
          Icons.text_format_outlined,
          size: 34,
          color: AppColors.getTextColor(isDark),
        ),
      ),
      fontSizeBackgroundColor: primary,
      fontSizeThumbColor: Colors.white,
      fontSizeActiveTrackColor: Colors.white,
      fontSizeInactiveTrackColor: primary.withValues(alpha: 0.5),
      fontSizeIconSize: 34.0,
      downloadIconColor: primary,

      // تبويب أحكام التجويد
      tajweedSurahNumberErrorText: tajweedSurahNumberError,
      tajweedUnavailableText: tajweedUnavailable,
      tajweedDownloadText: tajweedDownload,
      tajweedDownloadingText: tajweedDownloading,
      tajweedLoadErrorText: tajweedLoadError,
      tajweedNoDataText: tajweedNoData,
      tajweedAyahTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
        fontFamily: 'hafs',
        package: 'quran_library',
      ),
      tajweedMarkedTextStyle: const TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.w700,
      ),
      tajweedStatusTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tajweedButtonTextStyle: TextStyle(
        fontSize: 16,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tajweedProgressTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tajweedContentTextStyle: TextStyle(
        fontSize: 22,
        height: 1.7,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'naskh',
        package: 'quran_library',
      ),
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
      dialogHeaderTitle: 'تغيير التفسير',
      tabBarLabelStyle: TextStyle(
        fontFamily: 'cairo',
        package: 'quran_library',
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: AppColors.getTextColor(isDark),
      ),
      handleWidget: null,
      tabBarUnselectedLabelStyle: TextStyle(
        fontFamily: 'cairo',
        package: 'quran_library',
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: AppColors.getTextColor(isDark),
      ),
      dialogHeaderTitleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'cairo',
        height: 1.3,
        color: AppColors.getTextColor(isDark),
        package: 'quran_library',
      ),
      dialogTypeTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tafsirTextTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.getTextColor(isDark),
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      currentTafsirTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primary,
        fontFamily: 'cairo',
        package: 'quran_library',
      ),
      tajweedDownloadButtonWidget: null,
      tafsirDropdownWidget: null,
      dialogBackgroundColor: AppColors.getBackgroundColor(isDark),
      removeTafsirIconWidget: null,
      downloadTafsirIconWidget: null,
    );
  }
}
