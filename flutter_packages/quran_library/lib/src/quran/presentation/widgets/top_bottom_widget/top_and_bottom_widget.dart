part of '/quran.dart';

/// ويدجت لعرض محتوى السورة المخصصة مع المعلومات المطلوبة
/// Widget for displaying custom surah content with required information
class TopAndBottomWidget extends StatelessWidget {
  final int pageIndex;
  final bool isRight;
  final bool? isSurah;
  final int? surahNumber;
  final String? languageCode;
  final Widget child;

  TopAndBottomWidget({
    super.key,
    required this.pageIndex,
    required this.isRight,
    required this.child,
    this.languageCode,
    this.isSurah = false,
    this.surahNumber,
  });

  final surahCtrl = SurahCtrl.instance;
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return UiHelper.currentOrientation(
      // شرح: التخطيط العمودي (Portrait)
      // Explanation: Portrait layout
      Stack(
        children: [
          // شرح: العنوان العلوي
          // Explanation: Top title
          Align(
            alignment: Alignment.topCenter,
            child: BuildTopSection(
              isRight: isRight,
              languageCode: languageCode,
              pageIndex: pageIndex,
              isSurah: isSurah!,
              surahNumber: surahNumber,
            ),
          ),

          // شرح: المحتوى الرئيسي
          // Explanation: Main content
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: child,
            ),
          ),

          // شرح: القسم السفلي
          // Explanation: Bottom section
          Align(
            alignment: Alignment.bottomCenter,
            child: BuildBottomSection(
                pageIndex: pageIndex,
                isRight: isRight,
                languageCode: languageCode!),
          ),
        ],
      ),

      // شرح: التخطيط الأفقي (Landscape)
      // Explanation: Landscape layout
      Responsive.isMobile(context) ||
              Responsive.isMobileLarge(context) ||
              Responsive.isDesktop(context)
          ? Column(
              children: [
                BuildTopSection(
                  isRight: isRight,
                  languageCode: languageCode,
                  pageIndex: pageIndex,
                  isSurah: isSurah!,
                  surahNumber: surahNumber,
                ),
                Flexible(
                  child: child,
                ),
                BuildBottomSection(
                    pageIndex: pageIndex,
                    isRight: isRight,
                    languageCode: languageCode!),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  BuildTopSection(
                    isRight: isRight,
                    languageCode: languageCode,
                    pageIndex: pageIndex,
                    isSurah: isSurah!,
                    surahNumber: surahNumber,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: child,
                  ),
                  BuildBottomSection(
                      pageIndex: pageIndex,
                      isRight: isRight,
                      languageCode: languageCode!),
                ],
              ),
            ),
      context,
    );
  }
}
