part of '/quran.dart';

class DefaultFontsBuild extends StatelessWidget {
  DefaultFontsBuild(
    this.context,
    this.line,
    this.bookmarksAyahs,
    this.bookmarks, {
    super.key,
    this.boxFit = BoxFit.fill,
    this.onDefaultAyahLongPress,
    this.bookmarksColor,
    this.textColor,
    this.ayahSelectedBackgroundColor,
    this.bookmarkList,
    required this.pageIndex,
    required this.ayahBookmarked,
    this.ayahSelectedFontColor,
    required this.isDark,
    this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
  });

  final quranCtrl = QuranCtrl.instance;

  final BuildContext context;
  final LineModel line;
  final List<int> bookmarksAyahs;
  final Map<int, List<BookmarkModel>> bookmarks;
  final BoxFit boxFit;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onDefaultAyahLongPress;
  final Color? bookmarksColor;
  final Color? textColor;
  final Color? ayahSelectedBackgroundColor;
  final Color? ayahSelectedFontColor;
  final List? bookmarkList;
  final int pageIndex;
  final List<int> ayahBookmarked;
  final bool isDark;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      id: 'selection_page_',
      builder: (quranCtrl) {
        return FittedBox(
          fit: boxFit,
          child: RichText(
            text: TextSpan(
              children: () {
                final reversedAyahs = line.ayahs.reversed.toList();
                return List.generate(reversedAyahs.length, (i) {
                  final ayah = reversedAyahs[i];
                  final isUserSelected = quranCtrl.selectedAyahsByUnequeNumber
                      .contains(ayah.ayahUQNumber);
                  final isExternallyHighlighted = quranCtrl
                      .externallyHighlightedAyahs
                      .contains(ayah.ayahUQNumber);
                  quranCtrl.isAyahSelected =
                      isUserSelected || isExternallyHighlighted;
                  final allBookmarks =
                      bookmarks.values.expand((list) => list).toList();
                  ayahBookmarked.isEmpty
                      ? (bookmarksAyahs.contains(ayah.ayahUQNumber)
                          ? true
                          : false)
                      : ayahBookmarked;

                  // فصل رقم الآية من النص الأصلي لإتاحة تلوينه بشكل مستقل
                  final parts = _splitAyahTail(ayah.text);
                  return WidgetSpan(
                    child: GestureDetector(
                      onLongPressStart: (details) {
                        if (onDefaultAyahLongPress != null) {
                          onDefaultAyahLongPress!(details, ayah);
                          quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
                        } else {
                          final bookmarkId = allBookmarks.any((bookmark) =>
                                  bookmark.ayahId == ayah.ayahUQNumber)
                              ? allBookmarks
                                  .firstWhere((bookmark) =>
                                      bookmark.ayahId == ayah.ayahUQNumber)
                                  .id
                              : null;
                          if (bookmarkId != null) {
                            BookmarksCtrl.instance.removeBookmark(bookmarkId);
                          } else {
                            // تحديث التحديد
                            if (quranCtrl.isMultiSelectMode.value) {
                              quranCtrl
                                  .toggleAyahSelectionMulti(ayah.ayahUQNumber);
                            } else {
                              quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
                            }
                            // التقاط النمط مبكرًا من سياق تحت QuranLibraryTheme
                            final themedTafsirStyle =
                                TafsirTheme.of(context)?.style;
                            showAyahMenuDialog(
                              context: context,
                              isDark: isDark,
                              ayah: ayah,
                              position: details.globalPosition,
                              index: ayah.ayahNumber,
                              pageIndex: pageIndex,
                              externalTafsirStyle: themedTafsirStyle,
                            );
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: ayahBookmarked.contains(ayah.ayahUQNumber)
                              ? bookmarksColor
                              : (bookmarksAyahs.contains(ayah.ayahUQNumber)
                                  ? Color(
                                      allBookmarks
                                          .firstWhere((b) =>
                                              b.ayahId == ayah.ayahUQNumber)
                                          .colorCode,
                                    ).withValues(alpha: .30)
                                  : quranCtrl.isAyahSelected
                                      ? ayahSelectedBackgroundColor ??
                                          const Color(0xffCDAD80)
                                              .withValues(alpha: .25)
                                      : null),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color:
                                  textColor ?? AppColors.getTextColor(isDark),
                              fontSize: pageIndex == 0 || pageIndex == 1
                                  ? 22.55.sp
                                  : null,
                              fontFamily: quranCtrl.currentFontFamily,
                              height: 1.4,
                              package: 'quran_library',
                            ),
                            children: [
                              TextSpan(text: parts.body),
                              if (parts.tail.isNotEmpty)
                                (ayahBookmarked.contains(ayah.ayahUQNumber) ||
                                            bookmarksAyahs
                                                .contains(ayah.ayahUQNumber)) &&
                                        showAyahBookmarkedIcon
                                    ? WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SvgPicture.asset(
                                            AssetsPath.assets.ayahBookmarked,
                                            height: 22.55,
                                          ),
                                        ))
                                    : TextSpan(
                                        text: ' ${parts.tail}',
                                        style: TextStyle(
                                          color: ayahIconColor ??
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          fontSize:
                                              pageIndex == 0 || pageIndex == 1
                                                  ? 22.55.sp
                                                  : 16,
                                          fontFamily: 'ayahNumber',
                                          package: 'quran_library',
                                        ),
                                      ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              }(),
              // style: TextStyle(
              //   color: textColor ?? AppColors.getTextColor(isDark),
              //   // fontSize: 22.55,
              //   fontFamily: 'hafs',
              //   // height: 1.3,
              //   package: 'quran_library',
              // ),
            ),
          ),
        );
      },
    );
  }

  // يُعيد جزئين: body (النص دون الذيل) و tail (علامة نهاية الآية + الرقم)
  _AyahParts _splitAyahTail(String input) {
    // نلتقط الذيل في المجموعة الأولى للحفاظ عليه كما هو لخط حفص
    final reg = RegExp(
        r'((?:\s*[\u06DD]\s*)?(?:\s*[﴿\uFD3F]\s*)?[\u0660-\u0669\u06F0-\u06F9]+\s*(?:[﴾\uFD3E])?)\s*$');
    final m = reg.firstMatch(input);
    if (m == null) {
      return _AyahParts(input, '');
    }
    final start = m.start;
    final body = input.substring(0, start).trimRight();
    final tail = m.group(1) ?? '';
    return _AyahParts(body, tail);
  }

  String stripAyahNumber(String s) {
    // أنماط محتملة في المصاحف:
    // - U+06DD ARABIC END OF AYAH + أرقام
    // - أقواس زخرفية ﴿ ﴾ (FD3F, FD3E) + أرقام
    final endPattern = RegExp(
        r'(?:\s*[\u06DD]\s*)?(?:\s*[﴿\uFD3F]\s*)?\s*[\u0660-\u0669\u06F0-\u06F9]+\s*(?:[﴾\uFD3E])?\s*$');
    return s.replaceAll(endPattern, '').trimRight();
  }
}

class _AyahParts {
  final String body;
  final String tail;
  const _AyahParts(this.body, this.tail);
}
