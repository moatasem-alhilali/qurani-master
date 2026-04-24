part of '/quran.dart';

Future<void> showWordInfoBottomSheet({
  required BuildContext context,
  required WordRef ref,
  WordInfoKind initialKind = WordInfoKind.recitations,
  required bool isDark,
  WordInfoBottomSheetStyle? wordInfoStyle,
}) async {
  final ctrl = WordInfoCtrl.instance;
  ctrl.setSelectedKind(initialKind);

  final WordInfoBottomSheetStyle defaults = wordInfoStyle ??
      WordInfoBottomSheetTheme.of(context)?.style ??
      WordInfoBottomSheetStyle.defaults(isDark: isDark, context: context);
  final size = MediaQuery.sizeOf(context);
  // final maxHFactor = (defaults.maxHeightFactor ?? 0.9).clamp(0.0, 1.0);
  final maxWFactor = (defaults.maxWidthFactor ?? 1.0).clamp(0.0, 1.0);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    constraints: BoxConstraints(
      maxHeight: size.height * .9,
      maxWidth: size.width * maxWFactor,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext modalContext) {
      return WordInfoWidget(
        ref: ref,
        initialKind: initialKind,
        ctrl: ctrl,
        isDark: isDark,
        defaults: defaults,
      );
    },
  );
}

class WordInfoWidget extends StatelessWidget {
  const WordInfoWidget({
    super.key,
    required this.ref,
    required this.initialKind,
    required this.ctrl,
    required this.isDark,
    required this.defaults,
  });

  final WordRef ref;
  final WordInfoKind initialKind;
  final WordInfoCtrl ctrl;
  final bool isDark;
  final WordInfoBottomSheetStyle defaults;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(text: defaults.tabRecitationsText ?? 'القراءات'),
      Tab(text: defaults.tabTasreefText ?? 'التصريف'),
      Tab(text: defaults.tabEerabText ?? 'الإعراب'),
    ];

    return Container(
      padding: defaults.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: defaults.backgroundColor ?? AppColors.getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(defaults.borderRadius ?? 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // خط فاصل جمالي
          defaults.handleWidget ??
              Container(
                width: defaults.handleWidth ?? 60,
                height: defaults.handleHeight ?? 5,
                margin: defaults.handleMargin ??
                    const EdgeInsets.only(bottom: 8, top: 8),
                decoration: BoxDecoration(
                  color: defaults.handleColor ?? Colors.grey.shade500,
                  borderRadius:
                      BorderRadius.circular(defaults.handleBorderRadius ?? 3),
                ),
              ),
          if (defaults.withTitle ?? true)
            Text(
              defaults.titleText ?? 'عن الكلمة',
              style: defaults.titleTextStyle ??
                  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextColor(isDark),
                    fontFamily: 'cairo',
                    package: 'quran_library',
                  ),
            ),
          // أزرار تشغيل صوت الكلمة والآية
          if (ctrl.isWordAudioInitialized &&
              (defaults.withWordAudioButton ?? true)) ...[
            _WordAudioButtons(
              ref: ref,
              ctrl: ctrl,
              isDark: isDark,
              style: defaults,
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: GetBuilder<WordInfoCtrl>(
              id: 'word_info_kind',
              builder: (_) {
                return DefaultTabController(
                  length: tabs.length,
                  initialIndex: initialKind.index,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: defaults.tabBarHeight ?? 40,
                        margin: EdgeInsets.symmetric(
                          horizontal: defaults.horizontalMargin ?? 8,
                        ),
                        decoration: BoxDecoration(
                          color: (defaults.tabBackgroundColor ??
                                  Theme.of(context).colorScheme.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          onTap: (index) {
                            ctrl.setSelectedKind(WordInfoKind.values[index]);
                          },
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: defaults.tabLabelStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(isDark),
                                fontFamily: 'cairo',
                                package: 'quran_library',
                              ),
                          unselectedLabelStyle: defaults.tabLabelStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(isDark),
                                fontFamily: 'cairo',
                                package: 'quran_library',
                              ),
                          indicator: BoxDecoration(
                            color: defaults.tabIndicatorColor ??
                                (Theme.of(context).colorScheme.primary)
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                                defaults.tabIndicatorRadius ?? 10),
                          ),
                          labelColor: defaults.tabLabelColor ??
                              AppColors.getTextColor(isDark),
                          unselectedLabelColor:
                              defaults.tabUnselectedLabelColor ??
                                  AppColors.getTextColor(isDark)
                                      .withValues(alpha: 0.6),
                          indicatorPadding: defaults.tabIndicatorPadding ??
                              const EdgeInsets.all(4),
                          tabs: tabs,
                        ),
                      ),
                      Flexible(
                        child: TabBarView(
                          children: [
                            WordInfoKindTab(
                              kind: WordInfoKind.recitations,
                              kindLabelAr:
                                  defaults.tabRecitationsText ?? 'القراءات',
                              ref: ref,
                              ctrl: ctrl,
                              isDark: isDark,
                              style: defaults,
                            ),
                            WordInfoKindTab(
                              kind: WordInfoKind.tasreef,
                              kindLabelAr: defaults.tabTasreefText ?? 'التصريف',
                              ref: ref,
                              ctrl: ctrl,
                              isDark: isDark,
                              style: defaults,
                            ),
                            WordInfoKindTab(
                              kind: WordInfoKind.eerab,
                              kindLabelAr: defaults.tabEerabText ?? 'الإعراب',
                              ref: ref,
                              ctrl: ctrl,
                              isDark: isDark,
                              style: defaults,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WordInfoKindTab extends StatelessWidget {
  const WordInfoKindTab({
    super.key,
    required this.kind,
    required this.kindLabelAr,
    required this.ref,
    required this.ctrl,
    required this.isDark,
    required this.style,
  });

  final WordInfoKind kind;
  final String kindLabelAr;
  final WordRef ref;
  final WordInfoCtrl ctrl;
  final bool isDark;
  final WordInfoBottomSheetStyle style;

  @override
  Widget build(BuildContext context) {
    final unavailableTemplate =
        style.unavailableDataTemplate ?? 'بيانات {kind} غير محمّلة على الجهاز.';
    final unavailableText =
        unavailableTemplate.replaceAll('{kind}', kindLabelAr);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: style.verticalMargin ?? 8,
        horizontal: style.horizontalMargin ?? 8,
      ),
      padding: style.innerContainerPadding ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: style.textBackgroundColor ??
            style.backgroundColor ??
            AppColors.getBackgroundColor(isDark),
        borderRadius:
            BorderRadius.circular(style.innerContainerBorderRadius ?? 16),
        boxShadow: style.innerContainerBoxShadow ??
            [
              BoxShadow(
                color: style.innerShadowColor ??
                    Colors.grey.withValues(alpha: 0.1),
                blurRadius: style.innerShadowBlurRadius ?? 8,
                offset: style.innerShadowOffset ?? const Offset(0, 0),
              ),
            ],
        border: Border.symmetric(
          horizontal: BorderSide(
            color:
                style.tabIndicatorColor ?? Colors.grey.withValues(alpha: 0.3),
            width: style.innerBorderWidth ?? 1.2,
          ),
        ),
      ),
      child: GetBuilder<WordInfoCtrl>(
        id: 'word_info_download',
        builder: (ctrl) {
          final isAvailable = ctrl.isKindAvailable(kind);
          final isDownloading =
              ctrl.isDownloading.value && ctrl.downloadingKind.value == kind;

          if (!isAvailable) {
            return Padding(
              padding: style.contentPadding ?? const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    unavailableText,
                    style: style.bodyTextStyle ??
                        TextStyle(
                          fontSize: 16,
                          color: AppColors.getTextColor(isDark),
                          fontFamily: 'cairo',
                          package: 'quran_library',
                        ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  if (style.downloadButtonWidget != null)
                    style.downloadButtonWidget!(context, kind)
                  else
                    DownloadButtonWidget(
                      onTap: () async {
                        isDownloading ? null : await ctrl.downloadKind(kind);
                      },
                      isVisible: true,
                      isSelected: false,
                      downloaded: false,
                      background: Colors.teal.withValues(alpha: 0.1),
                      valueColor: Colors.teal,
                      borderColor: Colors.teal,
                      downloading:
                          isDownloading || ctrl.isPreparingDownload.value,
                      preparing:
                          isDownloading || ctrl.isPreparingDownload.value,
                      progress: ctrl.downloadProgress.value,
                      children: [
                        Text(
                          isDownloading
                              ? (style.downloadingText ?? 'جاري التحميل...')
                              : (style.downloadText ?? 'تحميل'),
                          style: style.buttonTextStyle ??
                              TextStyle(
                                fontSize: 16,
                                color: AppColors.getTextColor(isDark),
                                fontFamily: 'cairo',
                                package: 'quran_library',
                              ),
                        ),
                        if (isDownloading ||
                            ctrl.isPreparingDownload.value) ...[
                          const SizedBox(width: 12),
                          Text(
                            '${ctrl.downloadProgress.value.toStringAsFixed(0)}%',
                            style: style.progressTextStyle ??
                                TextStyle(
                                  fontSize: 16,
                                  color: AppColors.getTextColor(isDark),
                                  fontFamily: 'cairo',
                                  package: 'quran_library',
                                ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            );
          }

          return GetBuilder<WordInfoCtrl>(
            id: 'word_info_data',
            builder: (ctrl) {
              final f = ctrl.getWordInfo(kind: kind, ref: ref);
              return FutureBuilder<QiraatWordInfo?>(
                future: f,
                builder: (ctx, snap) {
                  // if (snap.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //       child: CircularProgressIndicator.adaptive());
                  // }

                  if (snap.hasError) {
                    return Padding(
                      padding: style.contentPadding ?? const EdgeInsets.all(16),
                      child: Text(
                        '${style.loadErrorText ?? 'تعذّر تحميل بيانات هذه الكلمة.'}\n${snap.error}',
                        style: style.bodyTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              color: AppColors.getTextColor(isDark),
                              fontFamily: 'cairo',
                              package: 'quran_library',
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }

                  final data = snap.data;
                  if (data == null) {
                    return Padding(
                      padding: style.contentPadding ?? const EdgeInsets.all(16),
                      child: Text(
                        style.noDataText ?? 'لا توجد بيانات لهذه الكلمة.',
                        style: style.bodyTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              color: AppColors.getTextColor(isDark),
                              fontFamily: 'cairo',
                              package: 'quran_library',
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }

                  final wordColor =
                      (kind == WordInfoKind.recitations && data.hasKhilaf)
                          ? Colors.red
                          : AppColors.getTextColor(isDark);
                  return SingleChildScrollView(
                    padding: style.contentPadding ?? const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (style.withWordText ?? true) ...[
                          Text(
                            data.word,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: wordColor,
                              fontFamily: 'naskh',
                              package: 'quran_library',
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SelectableText.rich(
                          buildMarkedContentSpan(
                            content: data.content,
                            baseStyle: TextStyle(
                              fontSize: 22,
                              height: 1.5,
                              color: AppColors.getTextColor(isDark),
                              fontFamily: 'naskh',
                              package: 'quran_library',
                            ),
                            markedStyle: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// أزرار تشغيل صوت الكلمة وكلمات الآية.
class _WordAudioButtons extends StatelessWidget {
  const _WordAudioButtons({
    required this.ref,
    required this.ctrl,
    required this.isDark,
    required this.style,
  });

  final WordRef ref;
  final WordInfoCtrl ctrl;
  final bool isDark;
  final WordInfoBottomSheetStyle style;

  @override
  Widget build(BuildContext context) {
    final svc = WordAudioService.instance;

    return Obx(() {
      final playing = svc.isPlaying.value;
      final loading = svc.isLoading.value;
      final currentRef = svc.currentPlayingRef.value;
      final isAyahMode = svc.isPlayingAyahWords.value;

      final isWordPlaying = playing && !isAyahMode && currentRef == ref;
      final isAyahPlaying = playing &&
          isAyahMode &&
          currentRef?.surahNumber == ref.surahNumber &&
          currentRef?.ayahNumber == ref.ayahNumber;

      final isWordLoading = loading && !isAyahMode && currentRef == ref;
      final isAyahLoading = loading &&
          isAyahMode &&
          currentRef?.surahNumber == ref.surahNumber &&
          currentRef?.ayahNumber == ref.ayahNumber;

      final buttonColor = style.audioButtonColor ?? Colors.teal;
      final activeColor = style.audioButtonActiveColor ?? Colors.teal.shade700;
      final iconSize = style.audioButtonSize ?? 22.0;

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر تشغيل الكلمة
            _buildButton(
              tooltip: style.playWordTooltip ?? 'تشغيل الكلمة',
              icon:
                  isWordPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
              isActive: isWordPlaying,
              isLoading: isWordLoading,
              color: buttonColor,
              activeColor: activeColor,
              iconSize: iconSize,
              onTap: () => ctrl.playWordAudio(ref),
            ),
            const SizedBox(width: 16),
            // زر تشغيل كلمات الآية
            _buildButton(
              tooltip: style.playAyahWordsTooltip ?? 'تشغيل كلمات الآية',
              icon: isAyahPlaying
                  ? Icons.stop_rounded
                  : Icons.playlist_play_rounded,
              isActive: isAyahPlaying,
              isLoading: isAyahLoading,
              color: buttonColor,
              activeColor: activeColor,
              iconSize: iconSize,
              onTap: () => ctrl.playAyahWordsAudio(ref),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildButton({
    required String tooltip,
    required IconData icon,
    required bool isActive,
    required bool isLoading,
    required Color color,
    required Color activeColor,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    if (isLoading) {
      return SizedBox(
        width: iconSize + 12,
        height: iconSize + 12,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color:
            isActive ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: iconSize,
              color: isActive ? activeColor : color,
            ),
          ),
        ),
      ),
    );
  }
}
