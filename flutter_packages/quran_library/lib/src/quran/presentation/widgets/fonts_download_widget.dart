part of '/quran.dart';

class FontsDownloadWidget extends StatelessWidget {
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final String? languageCode;
  final bool isDark;
  final bool isFontsLocal;
  final QuranCtrl? ctrl;

  const FontsDownloadWidget({
    super.key,
    this.downloadFontsDialogStyle,
    this.languageCode,
    this.isDark = false,
    this.isFontsLocal = false,
    this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final QuranCtrl effectiveCtrl = ctrl ?? QuranCtrl.instance;

    final Color accent = downloadFontsDialogStyle?.linearProgressColor ??
        Theme.of(context).colorScheme.primary;

    final Color background = downloadFontsDialogStyle?.backgroundColor ??
        AppColors.getBackgroundColor(isDark);

    final Color textColor =
        downloadFontsDialogStyle?.titleColor ?? AppColors.getTextColor(isDark);
    final Color notesColor =
        downloadFontsDialogStyle?.notesColor ?? AppColors.getTextColor(isDark);
    final Color dividerColor = downloadFontsDialogStyle?.dividerColor ?? accent;

    final Color outlineColor =
        (downloadFontsDialogStyle?.downloadButtonBackgroundColor != null)
            ? downloadFontsDialogStyle!.downloadButtonBackgroundColor!
                .withValues(alpha: .2)
            : isDark
                ? accent.withValues(alpha: .35)
                : accent.withValues(alpha: .2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderDialogWidget(
            isDark: isDark,
            title: downloadFontsDialogStyle?.headerTitle ?? 'الخطوط',
            titleColor: downloadFontsDialogStyle?.titleColor,
            closeIconColor: downloadFontsDialogStyle?.closeIconColor,
            backgroundGradient: downloadFontsDialogStyle?.backgroundGradient,
          ),
          const SizedBox(height: 8.0),
          context.horizontalDivider(
            width: MediaQuery.sizeOf(context).width * .5,
            color: dividerColor,
          ),
          const SizedBox(height: 10.0),
          Text(
            downloadFontsDialogStyle?.notes ??
                'لجعل مظهر المصحف مشابه لمصحف المدينة يمكنك تحميل خطوط المصحف',
            style: downloadFontsDialogStyle?.notesStyle ??
                TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'cairo',
                  color: notesColor,
                  height: 1.5,
                  package: 'quran_library',
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(
              QuranRecitation.values.length,
              (i) => _FontsRecitationTile(
                recitation: QuranRecitation.values[i],
                ctrl: effectiveCtrl,
                languageCode: languageCode,
                isDark: isDark,
                isFontsLocal: isFontsLocal,
                style: downloadFontsDialogStyle,
                accent: accent,
                background: background,
                outlineColor: outlineColor,
                textColor: textColor,
              ),
            ),
          ),
          TajweedButtonWidget(
              background: background,
              outlineColor: outlineColor,
              downloadFontsDialogStyle: downloadFontsDialogStyle,
              textColor: textColor,
              accent: accent),
          AutoScrollSettingsWidget(
            isDark: isDark,
            accent: accent,
            outlineColor: outlineColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}

class TajweedButtonWidget extends StatelessWidget {
  const TajweedButtonWidget({
    super.key,
    required this.background,
    required this.outlineColor,
    required this.downloadFontsDialogStyle,
    required this.textColor,
    required this.accent,
  });

  final Color background;
  final Color outlineColor;
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final Color textColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final fontsSelected = QuranCtrl.instance.state.fontsSelected.value == 0;
    final isTajweed = QuranCtrl.instance.state.isTajweedEnabled.value == true;
    String tajweedNames =
        downloadFontsDialogStyle?.tajweedOptionNames ?? 'مع التجويد';
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: !fontsSelected
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  onTap: () {
                    QuranCtrl.instance.state.isTajweedEnabled.toggle();
                    GetStorage().write(_StorageConstants().isTajweed,
                        QuranCtrl.instance.state.isTajweedEnabled.value);
                    Get.forceAppUpdate();
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: AnimatedContainer(
                    height: isTajweed ? 55 : 45,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: isTajweed
                          ? outlineColor.withValues(alpha: .05)
                          : Colors.transparent,
                      border: Border.all(color: outlineColor, width: 1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tajweedNames,
                          style: downloadFontsDialogStyle?.fontNameStyle ??
                              TextStyle(
                                height: 1.3,
                                fontSize: 16,
                                fontFamily: 'cairo',
                                color: textColor,
                                package: 'quran_library',
                              ),
                        ),
                        Icon(
                          isTajweed
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: accent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _FontsRecitationTile extends StatelessWidget {
  final QuranRecitation recitation;
  final QuranCtrl ctrl;
  final DownloadFontsDialogStyle? style;
  final String? languageCode;
  final bool isDark;
  final bool isFontsLocal;
  final Color accent;
  final Color background;
  final Color outlineColor;
  final Color textColor;

  const _FontsRecitationTile({
    required this.recitation,
    required this.ctrl,
    required this.style,
    required this.languageCode,
    required this.isDark,
    required this.isFontsLocal,
    required this.accent,
    required this.background,
    required this.outlineColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final int index = recitation.recitationIndex;

    return Obx(() {
      final bool isSelected = ctrl.state.fontsSelected.value == index;

      // Hafs دائمًا جاهزة؛ خطوط التجويد تحتاج تحميل ديناميكي
      final bool downloaded = index == 0 || ctrl.state.fontsReady.value;
      final bool loading =
          index == 1 && isSelected && !ctrl.state.fontsReady.value;
      final double progress = ctrl.state.fontsLoadProgress.value * 100;

      return DownloadButtonWidget(
        onTap: () => ctrl.selectRecitation(
          recitation,
          isFontsLocal: isFontsLocal,
        ),
        preparing: false,
        downloading: loading,
        progress: progress,
        isSelected: isSelected,
        downloaded: downloaded,
        borderColor: outlineColor,
        valueColor: style?.linearProgressColor ?? accent,
        isVisible: loading,
        background: (style?.linearProgressBackgroundColor ?? background)
            .withValues(alpha: .05),
        children: [
          const SizedBox.shrink(),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _titleText(
                            style: style,
                            isDownloadOption: false,
                            downloading: false,
                            progress: 100.0,
                            index: index,
                            recitation: recitation,
                            languageCode: languageCode,
                          ),
                          style: style?.fontNameStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontFamily: 'cairo',
                                color: textColor,
                                package: 'quran_library',
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // Widget downloadButtonWidget(
  //     bool isDownloadOption,
  //     bool preparing,
  //     bool downloading,
  //     double progress,
  //     bool canTap,
  //     bool isSelected,
  //     int index,
  //     bool downloaded) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       _DownloadProgressBackground(
  //         isVisible: isDownloadOption &&
  //             !isFontsLocal &&
  //             !kIsWeb &&
  //             (preparing || downloading),
  //         progress: progress,
  //         downloading: downloading,
  //         style: style,
  //         accent: accent,
  //         background: background,
  //       ),
  //       InkWell(
  //         onTap: canTap
  //             ? () => ctrl.selectRecitation(
  //                   recitation,
  //                   isFontsLocal: isFontsLocal,
  //                 )
  //             : null,
  //         child: SizedBox(
  //           height: isSelected ? 65 : 55,
  //           child: Row(
  //             children: [
  //               (isFontsLocal || kIsWeb || !isDownloadOption)
  //                   ? const SizedBox.shrink()
  //                   : _DownloadActionButton(
  //                       index: index,
  //                       ctrl: ctrl,
  //                       isSelected: isSelected,
  //                       downloaded: downloaded,
  //                       preparing: preparing,
  //                       downloading: downloading,
  //                       accent: accent,
  //                       style: style,
  //                     ),
  //               Expanded(
  //                 flex: 9,
  //                 child: Padding(
  //                   padding:
  //                       const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 9,
  //                         child: Align(
  //                           alignment: AlignmentDirectional.centerStart,
  //                           child: FittedBox(
  //                             fit: BoxFit.scaleDown,
  //                             child: Text(
  //                               _titleText(
  //                                 style: style,
  //                                 isDownloadOption: isDownloadOption,
  //                                 downloading: downloading,
  //                                 progress: progress,
  //                                 index: index,
  //                                 recitation: recitation,
  //                                 languageCode: languageCode,
  //                               ),
  //                               style: style?.fontNameStyle ??
  //                                   TextStyle(
  //                                     fontSize: 16,
  //                                     fontFamily: 'cairo',
  //                                     color: textColor,
  //                                     package: 'quran_library',
  //                                   ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Icon(
  //                           isSelected
  //                               ? Icons.radio_button_checked
  //                               : Icons.radio_button_unchecked,
  //                           color: accent,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  static String _titleText({
    required DownloadFontsDialogStyle? style,
    required bool isDownloadOption,
    required bool downloading,
    required double progress,
    required int index,
    required QuranRecitation recitation,
    required String? languageCode,
  }) {
    final names = style?.recitationNames;
    if (names != null) {
      final int listIndex = QuranRecitation.values.indexOf(recitation);
      if (listIndex >= 0 && listIndex < names.length) {
        final String candidate = names[listIndex];
        if (candidate.trim().isNotEmpty) return candidate;
      }
    }

    // Backward compatibility for older style fields.
    if (index == 0 && style?.defaultFontText != null) {
      return style!.defaultFontText!;
    }
    if (index != 0 && style?.downloadedFontsText != null) {
      return style!.downloadedFontsText!;
    }

    return recitation.arabicName;
  }
}
