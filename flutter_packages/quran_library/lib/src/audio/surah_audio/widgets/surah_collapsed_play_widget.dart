part of '../../audio.dart';

class SurahCollapsedPlayWidget extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool isDark;
  final String? languageCode;

  const SurahCollapsedPlayWidget(
      {super.key, this.style, this.isDark = false, this.languageCode});

  @override
  Widget build(BuildContext context) {
    final handleColor = Colors.grey.withValues(alpha: .6);
    final textColor = style?.surahNameColor ?? AppColors.getTextColor(isDark);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          _PanelHandle(color: handleColor),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // textDirection: TextDirection.rtl,
                      children: [
                        SurahSkipToNext(
                            style: style, languageCode: languageCode ?? 'ar'),
                        SurahOnlinePlayButton(style: style),
                        SurahSkipToPrevious(
                            style: style, languageCode: languageCode ?? 'ar'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => Text(
                      AudioCtrl.instance.state.currentAudioListSurahNum.value
                          .toString(),
                      style: TextStyle(
                        color: textColor,
                        fontFamily: "surahName",
                        fontSize: 42.sp.clamp(32, 42),
                        package: "quran_library",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelHandle extends StatelessWidget {
  final Color color;
  const _PanelHandle({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
