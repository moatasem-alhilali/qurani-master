part of '/quran.dart';

class BuildBottomSection extends StatelessWidget {
  BuildBottomSection({
    super.key,
    required this.pageIndex,
    required this.isRight,
    required this.languageCode,
  });

  final bool isRight;
  final int pageIndex;
  final String languageCode;
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final topBottomStyle = TopBottomTheme.of(context)?.style ??
        TopBottomQuranStyle.defaults(isDark: isDark, context: context);
    final String effectiveSajdaName = (topBottomStyle.sajdaName) ?? 'سجدة';
    final String effectiveHizbName = topBottomStyle.hizbName ?? 'الحزب';
    final Color hizbColor =
        topBottomStyle.hizbTextColor ?? const Color(0xff77554B);
    final Color pageNumberColor =
        topBottomStyle.pageNumberColor ?? const Color(0xff77554B);
    final Color sajdaNameColor =
        topBottomStyle.sajdaNameColor ?? const Color(0xff77554B);

    return isRight
        ? Stack(
            alignment: Alignment.center,
            children: [
              // شرح: ربع الحزب (يمين)
              // Explanation: Hizb quarter (right)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    quranCtrl
                        .getHizbQuarterDisplayByPage(pageIndex + 1)
                        .replaceAll('الحزب', effectiveHizbName)
                        .convertNumbersAccordingToLang(
                            languageCode: languageCode),
                    style: _getTextStyle(context, hizbColor),
                  ),
                ),
              ),

              // شرح: رقم الصفحة (وسط)
              // Explanation: Page number (center)
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '${pageIndex + 1}'.convertNumbersAccordingToLang(
                      languageCode: languageCode),
                  style: _getPageNumberStyle(context, pageNumberColor),
                ),
              ),

              // شرح: السجدة (يسار)
              // Explanation: Sajda (left)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: showSajda(
                      context, pageIndex, effectiveSajdaName, sajdaNameColor),
                ),
              ),
            ],
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: showSajda(
                      context, pageIndex, effectiveSajdaName, sajdaNameColor),
                ),
              ),

              // شرح: رقم الصفحة (وسط)
              // Explanation: Page number (center)
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '${pageIndex + 1}'.convertNumbersAccordingToLang(
                      languageCode: languageCode),
                  style: _getPageNumberStyle(context, pageNumberColor),
                ),
              ),

              // شرح: ربع الحزب (يسار)
              // Explanation: Hizb quarter (left)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    quranCtrl
                        .getHizbQuarterDisplayByPage(pageIndex + 1)
                        .replaceAll('الحزب', effectiveHizbName)
                        .convertNumbersAccordingToLang(
                            languageCode: languageCode),
                    style: _getTextStyle(context, hizbColor),
                  ),
                ),
              ),
            ],
          );
  }

  /// الحصول على نمط رقم الصفحة
  /// Get page number style
  TextStyle _getPageNumberStyle(BuildContext context, Color color) {
    return TextStyle(
      fontSize: UiHelper.currentOrientation(20.0, 22.0, context),
      fontFamily: 'naskh',
      color: color,
      package: 'quran_library',
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
