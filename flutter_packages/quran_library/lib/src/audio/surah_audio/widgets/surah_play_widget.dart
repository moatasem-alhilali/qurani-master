part of '../../audio.dart';

class PlaySurahsWidget extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool isDark;
  final String? languageCode;

  PlaySurahsWidget(
      {super.key, this.style, this.isDark = false, this.languageCode});

  final surahCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final handleColor = Colors.grey.withValues(alpha: .6);
    final numberColor = style?.surahNameColor ?? AppColors.getTextColor(isDark);
    final accent =
        style?.playIconColor ?? Theme.of(context).colorScheme.primary;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            _PanelHandle(color: handleColor),
            const SizedBox(height: 24),
            UiHelper.currentOrientation(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AudioSurahNameWidget(numberColor: numberColor, size: size),
                    SurahChangeSurahReader(style: style, isDark: isDark),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AudioSurahNameWidget(
                          numberColor: numberColor, size: size),
                      SurahChangeSurahReader(style: style, isDark: isDark),
                    ],
                  ),
                ),
                context),
            // const SizedBox(height: 16),
            SurahSeekBar(style: style),
            // const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                kIsWeb
                    ? const SizedBox.shrink()
                    : Obx(
                        () => surahCtrl.state
                                .isSurahDownloadedByNumber(surahCtrl
                                    .state.currentAudioListSurahNum.value)
                                .value
                            ? const SizedBox.shrink()
                            : SurahDownloadPlayButton(
                                style: style,
                                surahNumber: surahCtrl
                                    .state.currentAudioListSurahNum.value),
                      ),
                const SizedBox(width: 8),
                SurahRepeatWidget(style: style)
              ],
            ),
            // const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // إزالة Expanded لأنه ليس ابن مباشر لـ Flex مما سبب الخطأ.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        SurahSkipToNext(
                            style: style, languageCode: languageCode ?? 'ar'),
                        const SizedBox(width: 24),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: GestureDetector(
                            onTap: () => surahCtrl.state.audioPlayer.seek(
                                Duration(
                                    seconds: surahCtrl
                                        .state.seekNextSeconds.value += 5)),
                            child: SvgPicture.asset(
                              AssetsPath.assets.rewind,
                              colorFilter:
                                  ColorFilter.mode(accent, BlendMode.srcIn),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    SurahOnlinePlayButton(style: style),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: GestureDetector(
                            onTap: () {
                              surahCtrl.state.audioPlayer.seek(Duration(
                                  seconds: surahCtrl
                                      .state.seekNextSeconds.value -= 5));
                            },
                            child: SvgPicture.asset(
                              AssetsPath.assets.backward,
                              colorFilter:
                                  ColorFilter.mode(accent, BlendMode.srcIn),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        SurahSkipToPrevious(
                            style: style, languageCode: languageCode ?? 'ar'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioSurahNameWidget extends StatelessWidget {
  const AudioSurahNameWidget({
    super.key,
    required this.numberColor,
    required this.size,
  });

  final Color numberColor;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCtrl>(
      id: 'CollSurahName',
      builder: (audioCtrl) => Text(
        audioCtrl.state.currentAudioListSurahNum.value.toString(),
        style: TextStyle(
          color: numberColor,
          fontFamily: "surahName",
          fontSize: size.height * 0.1,
          package: "quran_library",
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
