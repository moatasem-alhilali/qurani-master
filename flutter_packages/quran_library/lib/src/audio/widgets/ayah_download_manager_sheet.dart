part of '../audio.dart';

/// BottomSheet احترافي لإدارة تحميل/حذف آيات السور حسب القارئ الحالي
class AyahDownloadManagerSheet extends StatelessWidget {
  final Future<void> Function(int surahNumber) onRequestDownload;
  final Future<void> Function(int surahNumber) onRequestDelete;
  final Future<bool> Function(int surahNumber) isSurahDownloadedChecker;
  final int? initialSurahToFocus;
  final AyahDownloadManagerStyle? style;
  final bool? isDark;
  final String? language;
  final AyahAudioStyle? ayahStyle;
  final bool? isInChangeReaderDialog;

  const AyahDownloadManagerSheet({
    super.key,
    required this.onRequestDownload,
    required this.onRequestDelete,
    required this.isSurahDownloadedChecker,
    this.initialSurahToFocus,
    this.style,
    this.isDark = false,
    this.language,
    this.ayahStyle,
    this.isInChangeReaderDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioCtrl.instance;
    final surahs = QuranCtrl.instance.surahs;
    final controller = ScrollController();
    final bool dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final effectiveStyle = style ??
        AyahDownloadManagerStyle.defaults(isDark: dark, context: context);

    // مفاتيح لكل عنصر لضمان تمرير scroll دقيق للعنصر المطلوب
    final Map<int, GlobalKey> itemKeys = {
      for (final s in surahs) s.surahNumber: GlobalKey()
    };

    // تنفيذ التمرير إلى السورة المطلوبة بعد أول frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (initialSurahToFocus != null) {
        final key = itemKeys[initialSurahToFocus!];
        final ctx = key?.currentContext;
        if (ctx != null) {
          await Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            alignment: 0.2,
            curve: Curves.easeInOut,
          );
        } else if (controller.hasClients) {
          final index =
              surahs.indexWhere((s) => s.surahNumber == initialSurahToFocus);
          if (index >= 0) {
            await controller.animateTo(
              (index * 78).toDouble(),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });

    return SizedBox(
      height: context.height * 0.8,
      child: Column(
        children: [
          isInChangeReaderDialog!
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    HeaderBuild(
                        style: effectiveStyle,
                        isDark: dark,
                        ayahStyle: ayahStyle),
                    const SizedBox(height: 12),
                  ],
                ),
          Expanded(
            child: Obx(() {
              final isBusy = audioCtrl.state.isDownloading.value;
              return ListView.separated(
                controller: controller,
                padding: const EdgeInsets.only(
                    bottom: 16, top: 8, left: 16, right: 16),
                itemCount: surahs.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: effectiveStyle.separatorColor,
                ),
                itemBuilder: (context, index) {
                  final s = surahs[index];
                  final itemKey = itemKeys[s.surahNumber]!;

                  return KeyedSubtree(
                    key: itemKey,
                    child: GetBuilder<AudioCtrl>(
                      id: 'ayahDownloadManager',
                      builder: (audioCtrl) {
                        // حساب عدد الآيات المحمّلة لهذه السورة
                        int downloaded = 0;
                        for (final ayah in s.ayahs) {
                          if (audioCtrl.state
                                  .ayahsDownloadStatus[ayah.ayahUQNumber] ==
                              true) {
                            downloaded++;
                          }
                        }
                        final total = s.ayahs.length;
                        final progress = total == 0 ? 0.0 : downloaded / total;
                        final fullyDownloaded =
                            total > 0 && downloaded == total;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            ProgressIndicatorWidget(
                                style: effectiveStyle,
                                progress: progress,
                                fullyDownloaded: fullyDownloaded),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal:
                                    effectiveStyle.itemHorizontalPadding ?? 16,
                                vertical:
                                    effectiveStyle.itemVerticalPadding ?? 8,
                              ),
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor: fullyDownloaded
                                    ? (effectiveStyle.avatarDownloadedColor ??
                                        Theme.of(context).colorScheme.primary)
                                    : (effectiveStyle.avatarUndownloadedColor ??
                                            Theme.of(context)
                                                .colorScheme
                                                .primary)
                                        .withValues(alpha: .4),
                                child: Text(
                                  s.surahNumber
                                      .toString()
                                      .convertNumbersAccordingToLang(
                                          languageCode: language ?? 'ar'),
                                  style: effectiveStyle.avatarTextStyle ??
                                      QuranLibrary().cairoStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    s.surahNumber.toString(),
                                    style: effectiveStyle.surahTitleStyle ??
                                        TextStyle(
                                          color: AppColors.getTextColor(dark),
                                          fontFamily: "surahName",
                                          fontSize:
                                              effectiveStyle.surahNameSize ??
                                                  30,
                                          height: 1.2,
                                          package: "quran_library",
                                        ),
                                  ),
                                  DownloadedTextWidget(
                                    style: effectiveStyle,
                                    downloaded: downloaded,
                                    total: total,
                                    language: language,
                                  ),
                                ],
                              ),
                              trailing: DownloadedAndDeleteWidget(
                                fullyDownloaded: fullyDownloaded,
                                style: effectiveStyle,
                                isBusy: isBusy,
                                onRequestDelete: onRequestDelete,
                                s: s,
                                onRequestDownload: onRequestDownload,
                                audioCtrl: audioCtrl,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DownloadedAndDeleteWidget extends StatelessWidget {
  const DownloadedAndDeleteWidget({
    super.key,
    required this.fullyDownloaded,
    required this.style,
    required this.isBusy,
    required this.onRequestDelete,
    required this.s,
    required this.onRequestDownload,
    required this.audioCtrl,
  });

  final bool fullyDownloaded;
  final AyahDownloadManagerStyle? style;
  final bool isBusy;
  final Future<void> Function(int surahNumber) onRequestDelete;
  final SurahModel s;
  final Future<void> Function(int surahNumber) onRequestDownload;
  final AudioCtrl audioCtrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCtrl>(
      id: 'ayahDownloadManager',
      builder: (audioCtrl) => Wrap(
        spacing: 8,
        children: [
          // if (fullyDownloaded)
          //   IconButton(
          //     tooltip: style?.deleteTooltipText ?? 'حذف السورة',
          //     icon: Icon(
          //       style?.deleteIcon ?? Icons.delete_outline,
          //       color: style?.deleteIconColor ?? Colors.red,
          //     ),
          //     onPressed: isBusy ? null : () => onRequestDelete(s.surahNumber),
          //   ),
          Obx(() {
            final isDownloading = audioCtrl.state.isDownloading.value;
            final currentDownloadingSurah =
                audioCtrl.state.currentDownloadingAyahSurahNumber.value;
            final isThisItemDownloading =
                isDownloading && currentDownloadingSurah == s.surahNumber;

            if (isThisItemDownloading) {
              // زر الإيقاف يظهر فقط للسورة الجاري تحميلها الآن
              return FilledButton(
                onPressed: () {
                  audioCtrl.state.cancelRequested.value = true;
                  AudioCtrl.instance.cancelDownload();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      style?.stopButtonBackground ??
                          Theme.of(context).colorScheme.primary),
                  foregroundColor: WidgetStatePropertyAll(
                      style?.stopButtonForeground ?? Colors.white),
                ),
                child:
                    Icon(style?.stopButtonIcon ?? Icons.stop_circle_outlined),
              );
            }

            // إذا لم يكن هذا العنصر هو الجاري تحميله حاليًا، أظهر زر تحميل/إعادة
            return SizedBox(
              height: 30,
              width: 60,
              child: FilledButton(
                onPressed: isDownloading
                    ? null
                    : () => fullyDownloaded
                        ? onRequestDelete(s.surahNumber)
                        : onRequestDownload(s.surahNumber),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(fullyDownloaded
                      ? (style?.deleteIconColor ?? Colors.red)
                      : (style?.downloadBackground ??
                          Theme.of(context).colorScheme.primary)),
                  foregroundColor: WidgetStatePropertyAll(
                      style?.downloadForeground ??
                          Theme.of(context).colorScheme.primary),
                ),
                child: Icon(
                  fullyDownloaded
                      ? (style?.deleteIcon ?? Icons.delete_outline)
                      : (style?.downloadIcon ?? Icons.download),
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DownloadedTextWidget extends StatelessWidget {
  const DownloadedTextWidget({
    super.key,
    required this.style,
    required this.downloaded,
    required this.total,
    required this.language,
  });

  final AyahDownloadManagerStyle? style;
  final int downloaded;
  final int total;
  final String? language;

  @override
  Widget build(BuildContext context) {
    return Text(
      style?.countTextBuilder?.call(downloaded, total) ??
          'تم تحميل $downloaded/$total آية'
              .convertNumbersAccordingToLang(languageCode: language ?? 'ar'),
      style: style?.surahSubtitleStyle ??
          QuranLibrary().cairoStyle.copyWith(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.2,
              ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.style,
    required this.progress,
    required this.fullyDownloaded,
  });

  final AyahDownloadManagerStyle? style;
  final double progress;
  final bool fullyDownloaded;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(style?.progressRadius ?? 8),
      child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0.0,
            end: progress,
          ),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastEaseInToSlowEaseOut,
          builder: (context, value, child) => LinearProgressIndicator(
                minHeight: style?.progressHeight ?? 70,
                // Use the animated value provided by TweenAnimationBuilder
                value: value,
                backgroundColor:
                    style?.progressBackgroundColor ?? Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                    (style?.progressColor ??
                            Theme.of(context).colorScheme.primary)
                        .withValues(alpha: .25)),
              )),
    );
  }
}

class HeaderBuild extends StatelessWidget {
  const HeaderBuild({
    super.key,
    required this.style,
    this.isDark = false,
    required this.ayahStyle,
  });

  final AyahDownloadManagerStyle? style;
  final AyahAudioStyle? ayahStyle;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    final bool dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final AyahAudioStyle effectiveAyahStyle =
        ayahStyle ?? AyahAudioStyle.defaults(isDark: dark, context: context);

    return Column(
      children: [
        style?.headerIcon ??
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: style?.handleColor ?? Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(style?.handleRadius ?? 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    style?.titleText ?? 'إدارة تحميل آيات السور',
                    style: style?.titleTextStyle ??
                        QuranLibrary().cairoStyle.copyWith(
                              fontSize: 18,
                              color: AppColors.getTextColor(isDark ?? false),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                  ),
                ],
              ),
            ),
        style?.changeReaderWidget ??
            AyahChangeReader(
                style: effectiveAyahStyle,
                isDark: isDark,
                downloadManagerStyle: style),
      ],
    );
  }
}
