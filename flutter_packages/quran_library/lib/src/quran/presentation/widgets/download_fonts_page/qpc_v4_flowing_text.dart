part of '/quran.dart';

/// ويدجت لعرض مجموعة آيات بخط QPC V4 بتدفق حر (wrapping تلقائي).
/// يُستخدم في وضع التكبير (scaleFactor > 1.3) حيث لا نحتاج لتحديد موقع كل كلمة.
/// يستقبل segments من عدة آيات متتالية ويعرضها في RichText واحد.
class QpcV4FlowingText extends StatefulWidget {
  const QpcV4FlowingText({
    super.key,
    required this.pageIndex,
    required this.segments,
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
    required this.isFontsLocal,
    required this.fontsName,
    required this.ayahBookmarked,
    this.isAyahBookmarked,
    this.onPagePress,
  });

  final int pageIndex;
  final List<QpcV4WordSegment> segments;
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
  final bool isFontsLocal;
  final String fontsName;
  final List<int> ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final VoidCallback? onPagePress;

  @override
  State<QpcV4FlowingText> createState() => _QpcV4FlowingTextState();
}

class _QpcV4FlowingTextState extends State<QpcV4FlowingText> {
  Widget? _cachedWidget;
  int _lastFingerprint = 0;

  int _computeFingerprint() {
    final quranCtrl = QuranCtrl.instance;
    final selHash = Object.hashAll(quranCtrl.selectedAyahsByUnequeNumber);
    final extHash = Object.hashAll(quranCtrl.externallyHighlightedAyahs);
    final bmHash = Object.hashAll(widget.bookmarksAyahs);
    final abHash = Object.hashAll(widget.ayahBookmarked);
    final overrideHash = widget.isAyahBookmarked == null
        ? 0
        : Object.hashAll(
            widget.segments.map((s) => Object.hash(
                  s.ayahUq,
                  widget.isAyahBookmarked!(quranCtrl.getAyahByUq(s.ayahUq)),
                )),
          );
    final isDarkHash = widget.isDark.hashCode;
    final tajweedHash = quranCtrl.state.isTajweedEnabled.value.hashCode;
    final wordSelectedHash =
        WordInfoCtrl.instance.selectedWordRef.value.hashCode;
    final tenRecHash = WordInfoCtrl.instance.tabController.index.hashCode;
    final recitationsRevisionHash =
        WordInfoCtrl.instance.recitationsDataRevision.hashCode;
    final scaleHash = quranCtrl.state.scaleFactor.value.hashCode;

    return Object.hash(
        selHash,
        extHash,
        bmHash,
        abHash,
        isDarkHash,
        tajweedHash,
        wordSelectedHash,
        tenRecHash,
        recitationsRevisionHash,
        Object.hash(overrideHash, scaleHash));
  }

  @override
  Widget build(BuildContext context) {
    final wordInfoCtrl = WordInfoCtrl.instance;

    return GetBuilder<QuranCtrl>(
      id: 'selection_page_${widget.pageIndex}',
      builder: (_) => GetBuilder<WordInfoCtrl>(
        id: 'word_info_data',
        builder: (_) {
          final withTajweed = QuranCtrl.instance.state.isTajweedEnabled.value;
          final isTenRecitations = wordInfoCtrl.isTenRecitations;

          if (isTenRecitations &&
              !withTajweed &&
              wordInfoCtrl.isKindAvailable(WordInfoKind.recitations)) {
            final surahs = widget.segments.map((s) => s.surahNumber).toSet();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              wordInfoCtrl.prewarmRecitationsSurahs(surahs);
            });
          }

          final fp = _computeFingerprint();
          if (_cachedWidget != null && fp == _lastFingerprint) {
            return _cachedWidget!;
          }
          _lastFingerprint = fp;

          _cachedWidget = LayoutBuilder(
            builder: (ctx, constraints) {
              final base = PageFontSizeHelper.hafsFontSize(
                context: ctx,
                maxWidth: constraints.maxWidth,
              );
              final quranCtrl = QuranCtrl.instance;
              final fs = base * quranCtrl.state.scaleFactor.value;

              return _buildFlowingRichText(
                wordInfoCtrl,
                context,
                fs,
                withTajweed: withTajweed,
                isTenRecitations: isTenRecitations,
              );
            },
          );
          return _cachedWidget!;
        },
      ),
    );
  }

  Widget _buildFlowingRichText(
    WordInfoCtrl wordInfoCtrl,
    BuildContext context,
    double fs, {
    required bool withTajweed,
    required bool isTenRecitations,
  }) {
    final quranCtrl = QuranCtrl.instance;
    final bookmarksSet = widget.bookmarksAyahs.toSet();
    final allBookmarksList =
        widget.bookmarks.values.expand((list) => list).toList();
    final bookmarksAyahsList = bookmarksSet.toList();

    final spans =
        List<InlineSpan>.generate(widget.segments.length, (segmentIndex) {
      final seg = widget.segments[segmentIndex];
      final uq = seg.ayahUq;
      final isSelectedCombined =
          quranCtrl.selectedAyahsByUnequeNumber.contains(uq) ||
              quranCtrl.externallyHighlightedAyahs.contains(uq);

      final ref = WordRef(
        surahNumber: seg.surahNumber,
        ayahNumber: seg.ayahNumber,
        wordNumber: seg.wordNumber,
      );

      final info = wordInfoCtrl.getRecitationsInfoSync(ref);
      final hasKhilaf = info?.hasKhilaf ?? false;

      return _qpcV4SpanSegment(
        context: context,
        pageIndex: widget.pageIndex,
        isSelected: isSelectedCombined,
        showAyahBookmarkedIcon: widget.showAyahBookmarkedIcon,
        fontSize: fs,
        ayahUQNum: uq,
        ayahNumber: seg.ayahNumber,
        glyphs: seg.glyphs,
        showAyahNumber: seg.isAyahEnd,
        wordRef: ref,
        isWordKhilaf: hasKhilaf,
        onLongPressStart: (details) {
          final ayahModel = quranCtrl.getAyahByUq(uq);

          if (widget.onAyahLongPress != null) {
            widget.onAyahLongPress!(details, ayahModel);
            quranCtrl.toggleAyahSelection(uq);
            quranCtrl.state.isShowMenu.value = false;
            return;
          }

          int? bookmarkId;
          for (final b in allBookmarksList) {
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

          if (!context.mounted) return;
          final themedTafsirStyle = TafsirTheme.of(context)?.style;
          showAyahMenuDialog(
            context: context,
            isDark: widget.isDark,
            ayah: ayahModel,
            position: details.globalPosition,
            index: segmentIndex,
            pageIndex: widget.pageIndex,
            externalTafsirStyle: themedTafsirStyle,
          );
        },
        textColor: widget.textColor ?? AppColors.getTextColor(widget.isDark),
        ayahIconColor: widget.ayahIconColor,
        allBookmarksList: allBookmarksList,
        bookmarksAyahs: widget.isAyahBookmarked != null
            ? const <int>[]
            : bookmarksAyahsList,
        bookmarksColor: widget.bookmarksColor,
        ayahSelectedBackgroundColor: widget.ayahSelectedBackgroundColor,
        isAyahBookmarked: widget.isAyahBookmarked,
        isFontsLocal: widget.isFontsLocal,
        fontsName: widget.fontsName,
        fontFamilyOverride: null,
        fontPackageOverride: null,
        usePaintColoring: true,
        ayahBookmarked: widget.ayahBookmarked,
        isDark: widget.isDark,
        onPagePress: widget.onPagePress,
      );
    });

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(children: spans),
    );
  }
}
