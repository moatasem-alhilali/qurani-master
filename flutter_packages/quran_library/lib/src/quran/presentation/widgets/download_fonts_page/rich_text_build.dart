part of '/quran.dart';

class QpcV4RichTextLine extends StatelessWidget {
  const QpcV4RichTextLine({
    super.key,
    required this.pageIndex,
    required this.textColor,
    required this.isDark,
    required this.bookmarks,
    required this.onAyahLongPress,
    required this.bookmarkList,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.bookmarksAyahs,
    required this.bookmarksColor,
    required this.ayahSelectedBackgroundColor,
    required this.context,
    required this.quranCtrl,
    required this.segments,
    required this.isFontsLocal,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.isCentered,
  });

  final int pageIndex;
  final Color? textColor;
  final bool isDark;
  final Map<int, List<BookmarkModel>> bookmarks;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final List? bookmarkList;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final List<int> bookmarksAyahs;
  final Color? bookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final BuildContext context;
  final QuranCtrl quranCtrl;
  final List<QpcV4AyahSegment> segments;
  final bool isFontsLocal;
  final String fontsName;
  final List<int> ayahBookmarked;
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    final bookmarksSet = bookmarksAyahs.toSet();

    return GetBuilder<QuranCtrl>(
      id: 'selection_page_',
      builder: (_) => LayoutBuilder(
        builder: (ctx, constraints) {
          final fs = PageFontSizeHelper.qcfFontSize(
            context: ctx,
            pageIndex: pageIndex,
            maxWidth: constraints.maxWidth,
          );

          return RichText(
            textDirection: TextDirection.rtl,
            textAlign: isCentered ? TextAlign.center : TextAlign.justify,
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: null,
            text: TextSpan(
              children: List.generate(segments.length, (segmentIndex) {
                final seg = segments[segmentIndex];
                final uq = seg.ayahUq;
                final isSelectedCombined =
                    quranCtrl.selectedAyahsByUnequeNumber.contains(uq) ||
                        quranCtrl.externallyHighlightedAyahs.contains(uq);

                return _qpcV4SpanSegment(
                  context: context,
                  pageIndex: pageIndex,
                  isSelected: isSelectedCombined,
                  showAyahBookmarkedIcon: showAyahBookmarkedIcon,
                  fontSize: fs,
                  ayahUQNum: uq,
                  ayahNumber: seg.ayahNumber,
                  glyphs: seg.glyphs,
                  showAyahNumber: seg.isAyahEnd,
                  onLongPressStart: (details) {
                    final ayahModel = quranCtrl.getAyahByUq(uq);

                    if (onAyahLongPress != null) {
                      onAyahLongPress!(details, ayahModel);
                      quranCtrl.toggleAyahSelection(uq);
                      quranCtrl.state.isShowMenu.value = false;
                      return;
                    }

                    int? bookmarkId;
                    for (final b in bookmarks.values.expand((list) => list)) {
                      if (b.ayahId == uq) {
                        bookmarkId = b.id;
                        break;
                      }
                    }

                    if (bookmarkId != null) {
                      BookmarksCtrl.instance.removeBookmark(bookmarkId);
                      return;
                    }

                    if (quranCtrl.isMultiSelectMode.value) {
                      quranCtrl.toggleAyahSelectionMulti(uq);
                    } else {
                      quranCtrl.toggleAyahSelection(uq);
                    }
                    quranCtrl.state.isShowMenu.value = false;

                    final themedTafsirStyle = TafsirTheme.of(context)?.style;
                    showAyahMenuDialog(
                      context: context,
                      isDark: isDark,
                      ayah: ayahModel,
                      position: details.globalPosition,
                      index: segmentIndex,
                      pageIndex: pageIndex,
                      externalTafsirStyle: themedTafsirStyle,
                    );
                  },
                  textColor: textColor ?? (AppColors.getTextColor(isDark)),
                  ayahIconColor: ayahIconColor,
                  bookmarks: bookmarks,
                  bookmarksAyahs: bookmarksSet.toList(),
                  bookmarksColor: bookmarksColor,
                  ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
                  isFontsLocal: isFontsLocal,
                  fontsName: fontsName,
                  ayahBookmarked: ayahBookmarked,
                  isDark: isDark,
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
