part of '../../audio.dart';

class SurahPlayLandscapeWidget extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool isDark;
  final String? languageCode;

  SurahPlayLandscapeWidget(
      {super.key, this.style, this.isDark = false, this.languageCode});

  final surahCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final numberColor = style?.surahNameColor ?? AppColors.getTextColor(isDark);
    final accent =
        style?.playIconColor ?? Theme.of(context).colorScheme.primary;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        width:
            UiHelper.currentOrientation(size.width, size.width * .5, context),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioSurahNameWidget(numberColor: numberColor, size: size),
                  const SizedBox(height: 24),
                  SurahChangeSurahReader(style: style, isDark: isDark),
                ],
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // textDirection: TextDirection.rtl,
                  children: [
                    Row(
                      // textDirection: TextDirection.rtl,
                      children: [
                        SurahSkipToNext(
                            style: style, languageCode: languageCode ?? 'ar'),
                        const SizedBox(width: 16.0),
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
                      ],
                    ),
                    SurahOnlinePlayButton(style: style),
                    Row(
                      // textDirection: TextDirection.rtl,
                      children: [
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
                        const SizedBox(width: 16.0),
                        SurahSkipToPrevious(
                            style: style, languageCode: languageCode ?? 'ar'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
