part of '../audio.dart';

class AyahsAudioWidget extends StatelessWidget {
  final AyahAudioStyle? style;
  final AyahDownloadManagerStyle? downloadManagerStyle;
  final bool? isDark;
  final String? languageCode;

  AyahsAudioWidget(
      {super.key,
      this.style,
      this.downloadManagerStyle,
      this.isDark = false,
      this.languageCode});
  final quranCtrl = QuranCtrl.instance;
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final bool dark = isDark ?? false;
    final AyahAudioStyle effectiveStyle =
        style ?? AyahAudioStyle.defaults(isDark: dark, context: context);
    // sliderCtrl.updateBottomVisibility(isVisible);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Align(
          alignment: kIsWeb ? Alignment.bottomLeft : Alignment.bottomCenter,
          // لا داعي لاستخدام Obx هنا لأن bottomSlideAnim ليس Rx ولا متغير ملاحظ
          // No need for Obx here, bottomSlideAnim is not Rx and not observable
          child: GestureDetector(
            // عند السحب للأعلى يفتح السلايدر، وعند السحب للأسفل يغلق
            // On vertical drag: up opens, down closes
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null) {
                if (details.primaryDelta! < -8) {
                  // سحب للأعلى: فتح السلايدر
                  // Drag up: open
                  Future.delayed(
                    const Duration(milliseconds: 10),
                    () => QuranCtrl.instance.state.isPlayExpanded.value = true,
                  );
                } else if (details.primaryDelta! > 8) {
                  // سحب للأسفل: إغلاق السلايدر
                  // Drag down: close

                  QuranCtrl.instance.state.isPlayExpanded.value = false;
                }
              }
            },

            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: effectiveStyle.backgroundColor!,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -5), // changes position of shadow
                    ),
                  ],
                ),
                child: Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ====== Handle للسحب ======
                        // ====== Drag Handle ======
                        Container(
                          width: 70,
                          height: 8,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          alignment: AlignmentGeometry.bottomCenter,
                          child: AnimatedCrossFade(
                            // مطابقة مدة الأنيميشن مع السلايدر لتجنب overflow
                            // Match animation duration with slider to avoid overflow
                            duration: const Duration(milliseconds: 200),
                            reverseDuration: const Duration(milliseconds: 200),
                            secondCurve: Curves.linear,
                            firstChild: Container(
                              height: 60,
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width * .5
                                  : MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  PlayAyahWidget(
                                      style: effectiveStyle,
                                      dark: isDark ?? false),
                                  AyahChangeReader(
                                      style: effectiveStyle,
                                      isDark: isDark,
                                      downloadManagerStyle:
                                          downloadManagerStyle),
                                ],
                              ),
                            ),
                            secondChild: GetBuilder<AudioCtrl>(
                                id: 'audio_seekBar_id',
                                builder: (c) {
                                  return LayoutBuilder(
                                      builder: (context, constraints) {
                                    // تحديد الارتفاع بناءً على المساحة المتاحة مع حد أدنى وأقصى
                                    // Determine height based on available space with min/max limits
                                    final availableHeight =
                                        constraints.maxHeight;
                                    final targetHeight =
                                        availableHeight.clamp(80.0, 175.0);

                                    return SizedBox(
                                        width: Responsive.isDesktop(context)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5
                                            : MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // تقليل المسافات عند المساحة المحدودة
                                            // Reduce spacing when space is limited
                                            SizedBox(
                                                height: targetHeight > 120
                                                    ? 12
                                                    : 2),
                                            AyahChangeReader(
                                                style: effectiveStyle,
                                                isDark: isDark,
                                                downloadManagerStyle:
                                                    downloadManagerStyle),
                                            // SizedBox(height: 4),
                                            // جعل الـ Slider مرن ليأخذ المساحة المتبقية
                                            // Make slider flexible to take remaining space
                                            _AyahSliderWidget(
                                              audioCtrl: audioCtrl,
                                              effectiveStyle: effectiveStyle,
                                              languageCode: languageCode,
                                              c: c,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  AyahSkipToPrevious(
                                                      style: effectiveStyle),
                                                  PlayAyahWidget(
                                                      style: effectiveStyle,
                                                      dark: isDark ?? false),
                                                  AyahSkipToNext(
                                                      style: effectiveStyle),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ));
                                  });
                                }),
                            crossFadeState: quranCtrl.state.isPlayExpanded.value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                        ),
                      ],
                    ))),
          ),
        ));
  }
}

class _AyahSliderWidget extends StatelessWidget {
  const _AyahSliderWidget({
    required this.audioCtrl,
    required this.effectiveStyle,
    required this.languageCode,
    required this.c,
  });

  final AudioCtrl audioCtrl;
  final AyahAudioStyle effectiveStyle;
  final String? languageCode;
  final AudioCtrl c;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetBuilder<AudioCtrl>(
          id: 'surahDownloadManager_id',
          builder: (c) => c.state.isDownloading.value
              ? PackageSliderWidget.downloading(
                  currentPosition: c.state.downloadProgress.value.toInt(),
                  filesCount: audioCtrl.state.fileSize.value,
                  activeTrackColor: effectiveStyle.seekBarActiveTrackColor!,
                  inactiveTrackColor: effectiveStyle.seekBarInactiveTrackColor!,
                  thumbColor: effectiveStyle.seekBarThumbColor!,
                  horizontalPadding: effectiveStyle.seekBarHorizontalPadding!,
                  timeContainerColor: effectiveStyle.seekBarTimeContainerColor!,
                )
              : StreamBuilder<PackagePositionData>(
                  stream: audioCtrl.positionDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final positionData = snapshot.data;
                      return PackageSliderWidget.player(
                        horizontalPadding:
                            effectiveStyle.seekBarHorizontalPadding!,
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        activeTrackColor:
                            effectiveStyle.seekBarActiveTrackColor!,
                        inactiveTrackColor:
                            effectiveStyle.seekBarInactiveTrackColor!,
                        thumbColor: effectiveStyle.seekBarThumbColor!,
                        onChangeEnd: audioCtrl.state.audioPlayer.seek,
                        timeContainerColor:
                            effectiveStyle.seekBarTimeContainerColor!,
                        languageCode: languageCode ?? 'ar',
                        // sliderHeight: 20,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
        ),
      ),
    );
  }
}
