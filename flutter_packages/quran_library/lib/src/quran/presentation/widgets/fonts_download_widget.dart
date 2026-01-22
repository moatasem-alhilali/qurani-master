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
        ],
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
    final bool isDownloadOption = recitation.requiresDownload;

    return Obx(() {
      final bool isSelected = ctrl.state.fontsSelected.value == index;
      final bool isThisDownloading =
          ctrl.state.downloadingFontIndex.value == index;

      final bool preparing =
          isThisDownloading ? ctrl.state.isPreparingDownload.value : false;
      final bool downloading =
          isThisDownloading ? ctrl.state.isDownloadingFonts.value : false;

      final double progress = ctrl.state.fontsDownloadProgress.value;
      final bool downloaded = _isDownloaded(
        ctrl: ctrl,
        index: index,
        isFontsLocal: isFontsLocal,
        isDownloadOption: isDownloadOption,
      );

      final bool canSelect = !isDownloadOption || downloaded;
      final bool canTap = isFontsLocal || kIsWeb || canSelect;

      return ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          height: isSelected ? 65 : 55,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: BoxDecoration(
            color:
                isSelected ? accent.withValues(alpha: .05) : Colors.transparent,
            border: Border.all(color: outlineColor, width: 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _DownloadProgressBackground(
                isVisible: isDownloadOption &&
                    !isFontsLocal &&
                    !kIsWeb &&
                    (preparing || downloading),
                progress: progress,
                downloading: downloading,
                style: style,
                accent: accent,
                background: background,
              ),
              InkWell(
                onTap: canTap
                    ? () => ctrl.selectRecitation(
                          recitation,
                          isFontsLocal: isFontsLocal,
                        )
                    : null,
                child: SizedBox(
                  height: isSelected ? 65 : 55,
                  child: Row(
                    children: [
                      (isFontsLocal || kIsWeb || !isDownloadOption)
                          ? const SizedBox.shrink()
                          : _DownloadActionButton(
                              index: index,
                              ctrl: ctrl,
                              isSelected: isSelected,
                              downloaded: downloaded,
                              preparing: preparing,
                              downloading: downloading,
                              accent: accent,
                              style: style,
                            ),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12.0),
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
                                        isDownloadOption: isDownloadOption,
                                        downloading: downloading,
                                        progress: progress,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  static bool _isDownloaded({
    required QuranCtrl ctrl,
    required int index,
    required bool isFontsLocal,
    required bool isDownloadOption,
  }) {
    return isFontsLocal ||
        (kIsWeb) ||
        !isDownloadOption ||
        ctrl.state.fontsDownloadedList.contains(index) ||
        (ctrl.state.isFontDownloaded.value &&
            ctrl.state.fontsDownloadedList.isEmpty);
  }

  static String _titleText({
    required DownloadFontsDialogStyle? style,
    required bool isDownloadOption,
    required bool downloading,
    required double progress,
    required int index,
    required QuranRecitation recitation,
    required String? languageCode,
  }) {
    if (downloading && isDownloadOption) {
      return '${style?.downloadingText ?? 'جاري التحميل'} ${progress.toStringAsFixed(1)}%'
          .convertNumbersAccordingToLang(languageCode: languageCode ?? 'ar');
    }

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

class _DownloadActionButton extends StatelessWidget {
  final int index;
  final QuranCtrl ctrl;
  final bool isSelected;
  final bool downloaded;
  final bool preparing;
  final bool downloading;
  final Color accent;
  final DownloadFontsDialogStyle? style;

  const _DownloadActionButton({
    required this.index,
    required this.ctrl,
    required this.isSelected,
    required this.downloaded,
    required this.preparing,
    required this.downloading,
    required this.accent,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 55;

    return SizedBox(
      width: 40,
      height: isSelected ? 65 : buttonHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (preparing || downloading)
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: accent,
              ),
            )
          else
            IconButton(
              tooltip: downloaded ? 'حذف الخطوط' : 'تحميل الخطوط',
              onPressed: () async {
                if (downloaded) {
                  await ctrl.deleteFontsForIndex(index);
                  return;
                }

                if (!ctrl.state.isDownloadingFonts.value &&
                    !ctrl.state.isPreparingDownload.value) {
                  await ctrl.downloadAllFontsZipFile(index);
                }
              },
              icon: Icon(
                downloaded ? Icons.delete_forever : Icons.download_outlined,
                color: style?.iconColor ?? accent,
                size: style?.iconSize,
              ),
            ),
        ],
      ),
    );
  }
}

class _DownloadProgressBackground extends StatelessWidget {
  final bool isVisible;
  final double progress;
  final bool downloading;
  final DownloadFontsDialogStyle? style;
  final Color accent;
  final Color background;

  const _DownloadProgressBackground({
    required this.isVisible,
    required this.progress,
    required this.downloading,
    required this.style,
    required this.accent,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    const double buttonHeight = 55;
    const double radius = 8;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastEaseInToSlowEaseOut,
          builder: (context, value, child) => LinearProgressIndicator(
            minHeight: buttonHeight,
            value: downloading ? (value / 100).clamp(0.0, 1.0) : null,
            backgroundColor:
                (style?.linearProgressBackgroundColor ?? background)
                    .withValues(alpha: .05),
            valueColor: AlwaysStoppedAnimation<Color>(
              (style?.linearProgressColor ?? accent).withValues(alpha: .25),
            ),
          ),
        ),
      ),
    );
  }
}
