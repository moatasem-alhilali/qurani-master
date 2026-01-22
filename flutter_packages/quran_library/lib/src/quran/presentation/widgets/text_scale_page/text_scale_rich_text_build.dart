part of '/quran.dart';

class TextScaleRichTextBuild extends StatelessWidget {
  TextScaleRichTextBuild({
    super.key,
    required this.textColor,
    required this.isDark,
    required this.ayahs,
    required this.bookmarks,
    required this.pageIndex,
    required this.ayahBookmarked,
    required this.onAyahLongPress,
    required this.bookmarkList,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.bookmarksAyahs,
    required this.bookmarksColor,
    required this.ayahSelectedBackgroundColor,
    required this.languageCode,
  });

  final Color? textColor;
  final bool isDark;
  final List<AyahModel> ayahs;
  final Map<int, List<BookmarkModel>> bookmarks;
  final int pageIndex;
  final List<int> ayahBookmarked;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final List? bookmarkList;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final List<int> bookmarksAyahs;
  final Color? bookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final String? languageCode;
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      id: 'selection_page_',
      builder: (_) => LayoutBuilder(
        builder: (ctx, constraints) {
          final base = PageFontSizeHelper.hafsFontSize(
            context: ctx,
            maxWidth: constraints.maxWidth,
          );
          final fs = base * quranCtrl.state.scaleFactor.value;
          return RichText(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'hafs',
                fontSize: fs,
                height: 1.7,
                // letterSpacing: 2,
                // fontWeight: FontWeight.bold,
                color: textColor ?? (AppColors.getTextColor(isDark)),
                // shadows: [
                //   Shadow(
                //     blurRadius: 0.5,
                //     color: quranCtrl.state.isBold.value == 0
                //         ? Colors.black
                //         : Colors.transparent,
                //     offset: const Offset(0.5, 0.5),
                //   ),
                // ],
                package: 'quran_library',
              ),
              children: List.generate(ayahs.length, (ayahIndex) {
                final allBookmarks =
                    bookmarks.values.expand((list) => list).toList();
                final isSelectedCombined = quranCtrl.selectedAyahsByUnequeNumber
                        .contains(ayahs[ayahIndex].ayahUQNumber) ||
                    quranCtrl.externallyHighlightedAyahs
                        .contains(ayahs[ayahIndex].ayahUQNumber);
                return _customSpan(
                  context: context,
                  text: ayahs[ayahIndex].text,
                  isDark: isDark,
                  pageIndex: pageIndex,
                  isSelected: isSelectedCombined,
                  fontSize: fs,
                  surahNum: quranCtrl
                      .getCurrentSurahByPageNumber(pageIndex + 1)
                      .surahNumber,
                  ayahUQNum: ayahs[ayahIndex].ayahUQNumber,
                  hasBookmark:
                      ayahBookmarked.contains(ayahs[ayahIndex].ayahUQNumber),
                  onLongPressStart: (details) {
                    if (onAyahLongPress != null) {
                      onAyahLongPress!(details, ayahs[ayahIndex]);
                      quranCtrl
                          .toggleAyahSelection(ayahs[ayahIndex].ayahUQNumber);
                      QuranCtrl.instance.state.isShowMenu.value = false;
                    } else {
                      final bookmarkId = allBookmarks.any((bookmark) =>
                              bookmark.ayahId == ayahs[ayahIndex].ayahUQNumber)
                          ? allBookmarks
                              .firstWhere((bookmark) =>
                                  bookmark.ayahId ==
                                  ayahs[ayahIndex].ayahUQNumber)
                              .id
                          : null;
                      if (bookmarkId != null) {
                        BookmarksCtrl.instance.removeBookmark(bookmarkId);
                      } else {
                        // حدث التحديد (متعدد أو عادي)
                        if (quranCtrl.isMultiSelectMode.value) {
                          quranCtrl.toggleAyahSelectionMulti(
                              ayahs[ayahIndex].ayahUQNumber);
                        } else {
                          quranCtrl.toggleAyahSelection(
                              ayahs[ayahIndex].ayahUQNumber);
                        }
                        QuranCtrl.instance.state.isShowMenu.value = false;

                        final themedTafsirStyle =
                            TafsirTheme.of(context)?.style;
                        showAyahMenuDialog(
                          context: context,
                          isDark: isDark,
                          ayah: ayahs[ayahIndex],
                          position: details.globalPosition,
                          index: ayahIndex,
                          pageIndex: pageIndex,
                          externalTafsirStyle: themedTafsirStyle,
                        );
                      }
                    }
                  },
                  bookmarkList: bookmarkList,
                  textColor: textColor ?? (AppColors.getTextColor(isDark)),
                  ayahIconColor:
                      ayahIconColor ?? Theme.of(context).colorScheme.primary,
                  showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                  bookmarks: bookmarks,
                  bookmarksAyahs: bookmarksAyahs,
                  bookmarksColor: bookmarksColor,
                  ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                  ayahNumber: ayahs[ayahIndex].ayahNumber,
                  languageCode: languageCode,
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
