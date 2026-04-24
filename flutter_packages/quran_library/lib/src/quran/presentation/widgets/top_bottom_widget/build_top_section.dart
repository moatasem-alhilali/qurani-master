part of '/quran.dart';

class BuildTopSection extends StatelessWidget {
  final bool isRight;
  final String? languageCode;
  final bool isSurah;
  final int pageIndex;
  final int? surahNumber;

  BuildTopSection({
    super.key,
    required this.isRight,
    this.languageCode,
    this.isSurah = false,
    required this.pageIndex,
    this.surahNumber = 0,
  });

  final surahCtrl = SurahCtrl.instance;
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final topBottomStyle = TopBottomTheme.of(context)?.style ??
        TopBottomQuranStyle.defaults(isDark: isDark, context: context);
    final Color juzColor =
        topBottomStyle.juzTextColor ?? const Color(0xff77554B);
    final Color surahColor =
        topBottomStyle.surahNameColor ?? const Color(0xff77554B);
    final List<SurahModel> surah =
        quranCtrl.getSurahsByPageNumber(pageIndex + 1);
    final juz = quranCtrl.getJuzByPage(pageIndex);

    final Widget? effectiveTopTitleChild =
        topBottomStyle.customChildBuilder?.call(context, pageIndex) ??
            topBottomStyle.customChild;
    final String effectiveJuzName = (topBottomStyle.juzName) ?? 'الجزء';
    // final String? effectiveSurahName = topBottomStyle.surahName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: isRight
          ? Row(
              children: [
                effectiveTopTitleChild ?? const SizedBox.shrink(),
                effectiveTopTitleChild != null
                    ? const SizedBox(width: 16)
                    : const SizedBox.shrink(),
                Text(
                  '$effectiveJuzName: ${juz.juz}'.convertNumbersAccordingToLang(
                      languageCode: languageCode),
                  style: _getTextStyle(context, juzColor),
                ),
                const Spacer(),
                isSurah
                    ? Text(
                        ' surah${(surahNumber).toString().padLeft(3, '0')} ',
                        style: TextStyle(
                          color: surahColor,
                          letterSpacing: 5,
                          fontFamily: "surah-name-v4",
                          fontSize:
                              UiHelper.currentOrientation(26.0, 32.0, context),
                          package: "quran_library",
                        ),
                      )
                    : surah.isNotEmpty
                        ? Row(
                            children: List.generate(
                              surah.length,
                              (i) => Text(
                                ' surah${(surah[i].surahNumber).toString().padLeft(3, '0')} ',
                                style: TextStyle(
                                  color: surahColor,
                                  letterSpacing: 5,
                                  fontFamily: "surah-name-v4",
                                  fontSize: UiHelper.currentOrientation(
                                      26.0, 32.0, context),
                                  package: "quran_library",
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              ],
            )
          : Row(
              children: [
                isSurah
                    ? Text(
                        ' surah${(surahNumber).toString().padLeft(3, '0')} ',
                        style: TextStyle(
                          color: surahColor,
                          letterSpacing: 5,
                          fontFamily: "surah-name-v4",
                          fontSize:
                              UiHelper.currentOrientation(26.0, 32.0, context),
                          package: "quran_library",
                        ),
                      )
                    : surah.isNotEmpty
                        ? Row(
                            children: List.generate(
                              surah.length,
                              (i) => Text(
                                ' surah${(surah[i].surahNumber).toString().padLeft(3, '0')} ',
                                style: TextStyle(
                                  color: surahColor,
                                  letterSpacing: 5,
                                  fontFamily: "surah-name-v4",
                                  fontSize: UiHelper.currentOrientation(
                                      26.0, 32.0, context),
                                  package: "quran_library",
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                const Spacer(),
                Text(
                  '$effectiveJuzName: ${quranCtrl.getJuzByPage(pageIndex).juz}'
                      .convertNumbersAccordingToLang(
                          languageCode: languageCode),
                  style: _getTextStyle(context, juzColor),
                ),
                effectiveTopTitleChild != null
                    ? const SizedBox(width: 16)
                    : const SizedBox.shrink(),
                effectiveTopTitleChild ?? const SizedBox.shrink(),
              ],
            ),
    );
  }

  /// الحصول على نمط النص
  /// Get text style
  TextStyle _getTextStyle(BuildContext context, Color color) {
    return TextStyle(
      fontSize: UiHelper.currentOrientation(18.0, 22.0, context),
      fontFamily: 'naskh',
      color: color,
      package: 'quran_library',
    );
  }
}
