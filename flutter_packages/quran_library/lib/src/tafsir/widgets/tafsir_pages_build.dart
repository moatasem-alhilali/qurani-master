part of '../tafsir.dart';

class TafsirPagesBuild extends StatelessWidget {
  final int pageIndex;
  final int ayahUQNumber;
  final TafsirStyle? tafsirStyle;
  final bool isDark;

  TafsirPagesBuild({
    super.key,
    required this.pageIndex,
    required this.ayahUQNumber,
    this.tafsirStyle,
    required this.isDark,
  });

  final quranCtrl = QuranCtrl.instance;
  final tafsirCtrl = TafsirCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.maybeOf(context)?.size.width ?? 400;
    final pageAyahs = quranCtrl.getPageAyahsByIndex(pageIndex);
    final selectedAyahIndexInFullPage =
        pageAyahs.indexWhere((ayah) => ayah.ayahUQNumber == ayahUQNumber);
    return FutureBuilder<void>(
      future: _initializeTafsirData(
        ayahUQNum: ayahUQNumber,
        pageIndex: pageIndex,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          // عرض مؤشر التحميل أثناء تحميل البيانات
          // Show loading indicator while data is loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // عرض واجهة التفسير بعد تحميل البيانات
        // Show tafsir interface after data loading
        if ((tafsirCtrl.tafseerList.isEmpty &&
            tafsirCtrl.translationList.isEmpty)) {
          return const SizedBox.shrink();
        }
        return PageView.builder(
          controller: PageController(initialPage: selectedAyahIndexInFullPage),
          itemCount: pageAyahs.length,
          itemBuilder: (context, i) {
            final ayahs = pageAyahs[i];
            int ayahIndex = pageAyahs.first.ayahUQNumber + i;
            final tafsir = tafsirCtrl.tafseerList.firstWhere(
              (element) => element.id == ayahIndex,
              orElse: () => const TafsirTableData(
                  id: 0, tafsirText: '', ayahNum: 0, pageNum: 0, surahNum: 0),
            );
            final surahs =
                QuranCtrl.instance.getCurrentSurahByPageNumber(ayahs.page);
            return Container(
              width: width,
              margin: EdgeInsets.symmetric(
                  vertical: tafsirStyle?.verticalMargin ?? 8,
                  horizontal: tafsirStyle?.horizontalMargin ?? 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tafsirStyle?.tafsirBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: tafsirStyle?.unSelectedTafsirBorderColor ??
                        (tafsirStyle?.dividerColor ??
                            Colors.grey.withValues(alpha: 0.3)),
                    width: 1.2,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: GetBuilder<TafsirCtrl>(
                  id: 'change_font_size',
                  builder: (tafsirCtrl) => ActualTafsirWidget(
                      isDark: isDark,
                      tafsirStyle: tafsirStyle ??
                          TafsirStyle.defaults(
                              isDark: isDark, context: context),
                      context: context,
                      ayahIndex: ayahIndex,
                      tafsir: tafsir,
                      ayahs: ayahs,
                      surahs: surahs,
                      pageIndex: pageIndex,
                      isTafsir: tafsirCtrl.selectedTafsir.isTafsir,
                      translationList: tafsirCtrl.translationList,
                      fontSizeArabic: tafsirCtrl.fontSizeArabic.value,
                      language: tafsirCtrl
                          .tafsirAndTranslationsItems[
                              tafsirCtrl.radioValue.value]
                          .name),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
