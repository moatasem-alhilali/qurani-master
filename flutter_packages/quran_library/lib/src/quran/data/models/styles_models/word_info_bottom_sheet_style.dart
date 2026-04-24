part of '/quran.dart';

/// Style configuration for Word Info bottom sheet.
///
/// This matches the pattern used across the library styles:
/// - nullable fields for overrides
/// - `copyWith` for partial updates
/// - `defaults` factory based on `isDark` + `context`
class WordInfoBottomSheetStyle {
  // Sheet container
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Bottom sheet constraints as factors of screen size.
  ///
  /// Example: `maxHeightFactor = 0.9` means max height is 90% of screen height.
  final double? maxHeightFactor;
  final double? maxWidthFactor;

  // Drag handle
  final double? handleWidth;
  final double? handleHeight;
  final EdgeInsetsGeometry? handleMargin;
  final double? handleBorderRadius;
  final Color? handleColor;

  // Title
  final String? titleText;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? titlePadding;
  final bool? withTitle;

  // Text overrides
  final String? tabRecitationsText;
  final String? tabTasreefText;
  final String? tabEerabText;
  final String? unavailableDataTemplate;
  final String? downloadText;
  final String? downloadingText;
  final String? loadErrorText;
  final String? noDataText;

  // Tabs
  final TextStyle? tabLabelStyle;
  final EdgeInsetsGeometry? tabIndicatorPadding;
  final double? tabIndicatorRadius;
  final Color? tabIndicatorColor;
  final Color? tabBackgroundColor;
  final double? dividerHeight;

  // Content
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? bodyTextStyle;
  final TextStyle? buttonTextStyle;
  final TextStyle? progressTextStyle;

  // Inner tab container (content card)
  final double? verticalMargin;
  final double? horizontalMargin;
  final EdgeInsetsGeometry? innerContainerPadding;
  final Color? tafsirBackgroundColor;
  final Color? textBackgroundColor;
  final double? innerContainerBorderRadius;
  final Color? innerShadowColor;
  final double? innerShadowBlurRadius;
  final Offset? innerShadowOffset;
  final Color? innerBorderColor;
  final double? innerBorderWidth;
  final Widget? handleWidget;

  // Audio buttons
  final Color? audioButtonColor;
  final Color? audioButtonActiveColor;
  final double? audioButtonSize;
  final String? playWordTooltip;
  final String? playAyahWordsTooltip;
  final bool? withWordText;
  final bool? withWordAudioButton;
  final Color? tabLabelColor;
  final Color? tabUnselectedLabelColor;
  final double? tabBarHeight;
  final List<BoxShadow>? innerContainerBoxShadow;
  final WordInfoBottomSheetStyleCustomChildBuilder? downloadButtonWidget;

  const WordInfoBottomSheetStyle({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.maxHeightFactor,
    this.maxWidthFactor,
    this.handleWidth,
    this.handleHeight,
    this.handleMargin,
    this.handleBorderRadius,
    this.handleColor,
    this.titleText,
    this.titleTextStyle,
    this.titlePadding,
    this.tabRecitationsText,
    this.tabTasreefText,
    this.tabEerabText,
    this.unavailableDataTemplate,
    this.downloadText,
    this.downloadingText,
    this.loadErrorText,
    this.noDataText,
    this.tabLabelStyle,
    this.tabIndicatorPadding,
    this.tabIndicatorRadius,
    this.tabIndicatorColor,
    this.dividerHeight,
    this.contentPadding,
    this.bodyTextStyle,
    this.buttonTextStyle,
    this.progressTextStyle,
    this.verticalMargin,
    this.horizontalMargin,
    this.innerContainerPadding,
    this.tafsirBackgroundColor,
    this.innerContainerBorderRadius,
    this.innerShadowColor,
    this.innerShadowBlurRadius,
    this.innerShadowOffset,
    this.innerBorderColor,
    this.innerBorderWidth,
    this.textBackgroundColor,
    this.handleWidget,
    this.audioButtonColor,
    this.audioButtonActiveColor,
    this.audioButtonSize,
    this.playWordTooltip,
    this.playAyahWordsTooltip,
    this.withTitle,
    this.withWordText,
    this.withWordAudioButton,
    this.tabLabelColor,
    this.tabUnselectedLabelColor,
    this.tabBackgroundColor,
    this.tabBarHeight,
    this.innerContainerBoxShadow,
    this.downloadButtonWidget,
  });

  WordInfoBottomSheetStyle copyWith({
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? maxHeightFactor,
    double? maxWidthFactor,
    double? handleWidth,
    double? handleHeight,
    EdgeInsetsGeometry? handleMargin,
    double? handleBorderRadius,
    Color? handleColor,
    String? titleText,
    TextStyle? titleTextStyle,
    EdgeInsetsGeometry? titlePadding,
    String? tabRecitationsText,
    String? tabTasreefText,
    String? tabEerabText,
    String? unavailableDataTemplate,
    String? downloadText,
    String? downloadingText,
    String? loadErrorText,
    String? noDataText,
    TextStyle? tabLabelStyle,
    EdgeInsetsGeometry? tabIndicatorPadding,
    double? tabIndicatorRadius,
    Color? tabIndicatorColor,
    double? dividerHeight,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? bodyTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? progressTextStyle,
    double? verticalMargin,
    double? horizontalMargin,
    EdgeInsetsGeometry? innerContainerPadding,
    Color? tafsirBackgroundColor,
    double? innerContainerBorderRadius,
    Color? innerShadowColor,
    double? innerShadowBlurRadius,
    Offset? innerShadowOffset,
    Color? innerBorderColor,
    double? innerBorderWidth,
    Color? textBackgroundColor,
    Widget? handleWidget,
    Color? audioButtonColor,
    Color? audioButtonActiveColor,
    double? audioButtonSize,
    String? playWordTooltip,
    String? playAyahWordsTooltip,
    bool? withTitle,
    bool? withWordText,
    bool? withWordAudioButton,
    Color? tabLabelColor,
    Color? tabUnselectedLabelColor,
    Color? tabBackgroundColor,
    double? tabBarHeight,
    List<BoxShadow>? innerContainerBoxShadow,
    WordInfoBottomSheetStyleCustomChildBuilder? downloadButtonWidget,
  }) {
    return WordInfoBottomSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxHeightFactor: maxHeightFactor ?? this.maxHeightFactor,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      handleMargin: handleMargin ?? this.handleMargin,
      handleBorderRadius: handleBorderRadius ?? this.handleBorderRadius,
      handleColor: handleColor ?? this.handleColor,
      titleText: titleText ?? this.titleText,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      titlePadding: titlePadding ?? this.titlePadding,
      tabRecitationsText: tabRecitationsText ?? this.tabRecitationsText,
      tabTasreefText: tabTasreefText ?? this.tabTasreefText,
      tabEerabText: tabEerabText ?? this.tabEerabText,
      unavailableDataTemplate:
          unavailableDataTemplate ?? this.unavailableDataTemplate,
      downloadText: downloadText ?? this.downloadText,
      downloadingText: downloadingText ?? this.downloadingText,
      loadErrorText: loadErrorText ?? this.loadErrorText,
      noDataText: noDataText ?? this.noDataText,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      tabIndicatorPadding: tabIndicatorPadding ?? this.tabIndicatorPadding,
      tabIndicatorRadius: tabIndicatorRadius ?? this.tabIndicatorRadius,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      contentPadding: contentPadding ?? this.contentPadding,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      progressTextStyle: progressTextStyle ?? this.progressTextStyle,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      innerContainerPadding:
          innerContainerPadding ?? this.innerContainerPadding,
      tafsirBackgroundColor:
          tafsirBackgroundColor ?? this.tafsirBackgroundColor,
      innerContainerBorderRadius:
          innerContainerBorderRadius ?? this.innerContainerBorderRadius,
      innerShadowColor: innerShadowColor ?? this.innerShadowColor,
      innerShadowBlurRadius:
          innerShadowBlurRadius ?? this.innerShadowBlurRadius,
      innerShadowOffset: innerShadowOffset ?? this.innerShadowOffset,
      innerBorderColor: innerBorderColor ?? this.innerBorderColor,
      innerBorderWidth: innerBorderWidth ?? this.innerBorderWidth,
      textBackgroundColor: textBackgroundColor ?? this.textBackgroundColor,
      handleWidget: handleWidget ?? this.handleWidget,
      audioButtonColor: audioButtonColor ?? this.audioButtonColor,
      audioButtonActiveColor:
          audioButtonActiveColor ?? this.audioButtonActiveColor,
      audioButtonSize: audioButtonSize ?? this.audioButtonSize,
      playWordTooltip: playWordTooltip ?? this.playWordTooltip,
      playAyahWordsTooltip: playAyahWordsTooltip ?? this.playAyahWordsTooltip,
      withTitle: withTitle ?? this.withTitle,
      withWordText: withWordText ?? this.withWordText,
      withWordAudioButton: withWordAudioButton ?? this.withWordAudioButton,
      tabLabelColor: tabLabelColor ?? this.tabLabelColor,
      tabUnselectedLabelColor:
          tabUnselectedLabelColor ?? this.tabUnselectedLabelColor,
      tabBackgroundColor: tabBackgroundColor ?? this.tabBackgroundColor,
      tabBarHeight: tabBarHeight ?? this.tabBarHeight,
      innerContainerBoxShadow:
          innerContainerBoxShadow ?? this.innerContainerBoxShadow,
      downloadButtonWidget: downloadButtonWidget ?? this.downloadButtonWidget,
    );
  }

  factory WordInfoBottomSheetStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = AppColors.getTextColor(isDark);

    const fontFamily = 'cairo';

    return WordInfoBottomSheetStyle(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      maxHeightFactor: 0.9,
      maxWidthFactor: 1.0,
      handleWidth: 60,
      handleHeight: 5,
      handleMargin: const EdgeInsets.only(bottom: 8),
      handleBorderRadius: 3,
      handleColor: Colors.grey.shade500,
      titleText: 'عن الكلمة',
      tabRecitationsText: 'القراءات',
      tabTasreefText: 'التصريف',
      tabEerabText: 'الإعراب',
      unavailableDataTemplate: 'بيانات {kind} غير محمّلة على الجهاز.',
      downloadText: 'تحميل',
      downloadingText: 'جاري التحميل...',
      loadErrorText: 'تعذّر تحميل بيانات هذه الكلمة.',
      noDataText: 'لا توجد بيانات لهذه الكلمة.',
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: fontFamily,
        package: 'quran_library',
      ),
      titlePadding: EdgeInsets.zero,
      tabLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: fontFamily,
        package: 'quran_library',
      ),
      tabIndicatorPadding: const EdgeInsets.all(4),
      tabIndicatorRadius: 10,
      tabIndicatorColor: scheme.primary.withValues(alpha: 0.2),
      dividerHeight: 1,
      contentPadding: const EdgeInsets.all(16),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: fontFamily,
        package: 'quran_library',
      ),
      buttonTextStyle: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: fontFamily,
        package: 'quran_library',
      ),
      progressTextStyle: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: fontFamily,
        package: 'quran_library',
      ),
      verticalMargin: 8,
      horizontalMargin: 8,
      innerContainerPadding: const EdgeInsets.all(0),
      tafsirBackgroundColor: AppColors.getBackgroundColor(isDark),
      innerContainerBorderRadius: 16,
      innerShadowColor: Colors.grey.withValues(alpha: 0.1),
      innerShadowBlurRadius: 8,
      innerShadowOffset: const Offset(0, 0),
      innerBorderColor: Colors.grey.withValues(alpha: 0.3),
      innerBorderWidth: 1.2,
      textBackgroundColor: isDark ? const Color(0xFF151515) : Colors.white,
      handleWidget: null,
      audioButtonColor: Colors.teal,
      audioButtonActiveColor: Colors.teal.shade700,
      audioButtonSize: 22,
      playWordTooltip: 'تشغيل الكلمة',
      playAyahWordsTooltip: 'تشغيل كلمات الآية',
      withTitle: true,
      withWordText: true,
      withWordAudioButton: true,
      tabLabelColor: textColor,
      tabUnselectedLabelColor: textColor.withValues(alpha: 0.6),
      tabBackgroundColor: Colors.teal.withValues(alpha: 0.1),
      tabBarHeight: 48,
      innerContainerBoxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 0),
        ),
      ],
      downloadButtonWidget: null,
    );
  }
}

typedef WordInfoBottomSheetStyleCustomChildBuilder = Widget Function(
  BuildContext context,
  WordInfoKind kind,
);
