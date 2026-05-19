part of '/quran.dart';

class QpcV4RichTextLine extends StatefulWidget {
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
    this.customBookmarksColor,
    required this.ayahSelectedBackgroundColor,
    required this.context,
    required this.quranCtrl,
    required this.segments,
    required this.isFontsLocal,
    required this.fontsName,
    this.fontFamilyOverride,
    this.fontPackageOverride,
    this.usePaintColoring = true,
    required this.ayahBookmarked,
    this.isAyahBookmarked,
    required this.isCentered,
    this.onPagePress,
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
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final BuildContext context;
  final QuranCtrl quranCtrl;
  final List<QpcV4WordSegment> segments;
  final bool isFontsLocal;
  final String fontsName;
  final String? fontFamilyOverride;
  final String? fontPackageOverride;
  final bool usePaintColoring;
  final List<int> ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final bool isCentered;
  final VoidCallback? onPagePress;

  @override
  State<QpcV4RichTextLine> createState() => _QpcV4RichTextLineState();
}

class _QpcV4RichTextLineState extends State<QpcV4RichTextLine> {
  /// كاش الويدجت المبني — يُعاد بناؤه فقط عند تغيّر selection/bookmarks/word_info
  Widget? _cachedWidget;

  /// بصمة البيانات المؤثرة على البناء — عند تغيّرها يُبطل الكاش
  int _lastFingerprint = 0;

  /// حساب بصمة سريعة للبيانات التي تؤثر فعلياً على شكل الويدجت
  int _computeFingerprint() {
    final quranCtrl = widget.quranCtrl;
    // الآيات المحددة + الآيات المظللة برمجياً
    final selHash = Object.hashAll(quranCtrl.selectedAyahsByUnequeNumber);
    final extHash = Object.hashAll(quranCtrl.externallyHighlightedAyahs);
    // bookmarks المؤثرة على هذا السطر
    final bmHash = Object.hashAll(widget.bookmarksAyahs);
    final abHash = Object.hashAll(widget.ayahBookmarked);
    final overrideHash = widget.isAyahBookmarked == null
        ? 0
        : Object.hashAll(
            widget.segments.map(
              (s) => Object.hash(
                s.ayahUq,
                widget.isAyahBookmarked!(quranCtrl.getAyahByUq(s.ayahUq)),
              ),
            ),
          );
    // إعدادات العرض
    final isDarkHash = widget.isDark.hashCode;
    final tajweedHash =
        QuranCtrl.instance.state.isTajweedEnabled.value.hashCode;
    final wordSelectedHash =
        WordInfoCtrl.instance.selectedWordRef.value.hashCode;
    // حالة تبويب القراءات العشر
    final tenRecHash = WordInfoCtrl.instance.tabController.index.hashCode;
    // تغيّر بيانات القراءات (عند اكتمال prewarm)
    final recitationsRevisionHash =
        WordInfoCtrl.instance.recitationsDataRevision.hashCode;

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
        overrideHash);
  }

  @override
  Widget build(BuildContext context) {
    final wordInfoCtrl = WordInfoCtrl.instance;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // GetBuilder بمعرّف خاص بالصفحة — لا يُعاد بناؤه من update() بدون id
    return GetBuilder<QuranCtrl>(
      id: 'selection_page_${widget.pageIndex}',
      builder: (_) => GetBuilder<WordInfoCtrl>(
        id: 'word_info_data',
        builder: (_) {
          // قراءة القيم داخل الـ builder حتى تعكس آخر حالة عند كل rebuild
          final withTajweed = QuranCtrl.instance.state.isTajweedEnabled.value;
          final isTenRecitations = wordInfoCtrl.isTenRecitations;

          // prewarm القراءات في خلفية
          if (isTenRecitations &&
              !withTajweed &&
              wordInfoCtrl.isKindAvailable(WordInfoKind.recitations)) {
            final surahs = widget.segments.map((s) => s.surahNumber).toSet();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              wordInfoCtrl.prewarmRecitationsSurahs(surahs);
            });
          }

          // فحص البصمة: إذا لم تتغيّر البيانات الفعلية → أعد الكاش
          final fp = _computeFingerprint();
          if (_cachedWidget != null && fp == _lastFingerprint) {
            return _cachedWidget!;
          }
          _lastFingerprint = fp;

          _cachedWidget = LayoutBuilder(
            builder: (ctx, constraints) {
              final fs = isLandscape
                  ? 100.0
                  : PageFontSizeHelper.getFontSize(
                      widget.pageIndex,
                      ctx,
                    ).h;

              return _buildRichText(
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

  Widget _buildRichText(
    WordInfoCtrl wordInfoCtrl,
    BuildContext context,
    double fs, {
    required bool withTajweed,
    required bool isTenRecitations,
  }) {
    final bookmarksSet = widget.bookmarksAyahs.toSet();
    final ayahCharRanges = <int, TextSelection>{};
    final bookmarkCharRanges = <int, _ColoredTextRange>{};
    TextSelection? wordSelectionRange;
    int charOffset = 0;

    final bookmarksAyahsList = bookmarksSet.toList();
    final allBookmarksList =
        widget.bookmarks.values.expand((list) => list).toList();
    final ayahBookmarkedSet = widget.ayahBookmarked.toSet();

    final spans =
        List<InlineSpan>.generate(widget.segments.length, (segmentIndex) {
      final seg = widget.segments[segmentIndex];
      final uq = seg.ayahUq;
      final isSelectedCombined =
          widget.quranCtrl.selectedAyahsByUnequeNumber.contains(uq) ||
              widget.quranCtrl.externallyHighlightedAyahs.contains(uq);

      final ref = WordRef(
        surahNumber: seg.surahNumber,
        ayahNumber: seg.ayahNumber,
        wordNumber: seg.wordNumber,
      );

      final info = wordInfoCtrl.getRecitationsInfoSync(ref);
      final hasKhilaf = info?.hasKhilaf ?? false;

      final span = _qpcV4SpanSegment(
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
          final ayahModel = widget.quranCtrl.getAyahByUq(uq);

          if (widget.onAyahLongPress != null) {
            widget.onAyahLongPress!(details, ayahModel);
            widget.quranCtrl.toggleAyahSelection(uq);
            widget.quranCtrl.state.isShowMenu.value = false;
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

          if (widget.quranCtrl.isMultiSelectMode.value) {
            widget.quranCtrl.toggleAyahSelectionMulti(uq);
          } else {
            widget.quranCtrl.toggleAyahSelection(uq);
          }
          widget.quranCtrl.state.isShowMenu.value = false;

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
        textColor: widget.textColor ?? (AppColors.getTextColor(widget.isDark)),
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
        fontFamilyOverride: widget.fontFamilyOverride,
        fontPackageOverride: widget.fontPackageOverride,
        usePaintColoring: widget.usePaintColoring,
        ayahBookmarked: widget.ayahBookmarked,
        isDark: widget.isDark,
        onPagePress: widget.onPagePress,
      );

      final spanStart = charOffset;
      charOffset += _countCharsInSpan(span);

      // تتبع نطاق الكلمة المحددة
      if (wordInfoCtrl.selectedWordRef.value == ref) {
        wordSelectionRange = TextSelection(
          baseOffset: spanStart,
          extentOffset: charOffset,
        );
      }

      if (isSelectedCombined) {
        if (ayahCharRanges.containsKey(uq)) {
          ayahCharRanges[uq] = TextSelection(
            baseOffset: ayahCharRanges[uq]!.baseOffset,
            extentOffset: charOffset,
          );
        } else {
          ayahCharRanges[uq] = TextSelection(
            baseOffset: spanStart,
            extentOffset: charOffset,
          );
        }
      }

      // تتبع نطاقات العلامات المرجعية (bookmarks)
      final isBookmarked = widget.isAyahBookmarked != null
          ? widget.isAyahBookmarked!(widget.quranCtrl.getAyahByUq(uq))
          : (ayahBookmarkedSet.contains(uq) || bookmarksSet.contains(uq));
      if (isBookmarked) {
        final ayah = widget.quranCtrl.getAyahByUq(uq);
        Color bmColor;
        if (widget.customBookmarksColor != null) {
          bmColor = widget.customBookmarksColor!(ayah) ??
              widget.bookmarksColor ??
              const Color(0xffCDAD80).withValues(alpha: 0.3);
        } else if (widget.isAyahBookmarked != null) {
          bmColor = widget.bookmarksColor ??
              const Color(0xffCDAD80).withValues(alpha: 0.3);
        } else if (widget.bookmarksColor != null) {
          bmColor = widget.bookmarksColor!;
        } else if (ayahBookmarkedSet.contains(uq) &&
            widget.bookmarksColor != null) {
          bmColor = widget.bookmarksColor!;
        } else {
          final bm = allBookmarksList.cast<BookmarkModel?>().firstWhere(
                (b) => b!.ayahId == uq,
                orElse: () => null,
              );
          bmColor = bm != null
              ? Color(bm.colorCode).withValues(alpha: 0.3)
              : const Color(0xffCDAD80).withValues(alpha: 0.3);
        }

        if (bookmarkCharRanges.containsKey(uq)) {
          bookmarkCharRanges[uq] = _ColoredTextRange(
            range: TextSelection(
              baseOffset: bookmarkCharRanges[uq]!.range.baseOffset,
              extentOffset: charOffset,
            ),
            color: bmColor,
          );
        } else {
          bookmarkCharRanges[uq] = _ColoredTextRange(
            range: TextSelection(
              baseOffset: spanStart,
              extentOffset: charOffset,
            ),
            color: bmColor,
          );
        }
      }

      return span;
    });

    final richText = RichText(
      textDirection: TextDirection.rtl,
      textAlign: widget.isCentered ? TextAlign.center : TextAlign.justify,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(children: spans),
    );

    final hasSelection = ayahCharRanges.isNotEmpty;
    final hasBookmarks = bookmarkCharRanges.isNotEmpty;
    final hasWordSelection = wordSelectionRange != null;

    if (!hasSelection && !hasBookmarks && !hasWordSelection) {
      return richText;
    }

    return _AyahSelectionWidget(
      selectedRanges: ayahCharRanges.values.toList(),
      selectionColor: widget.ayahSelectedBackgroundColor ??
          const Color(0xffCDAD80).withValues(alpha: 0.25),
      bookmarkRanges: bookmarkCharRanges.values.toList(),
      wordSelectionRange: wordSelectionRange,
      child: richText,
    );
  }
}

/// يعدّ عدد الأحرف في [InlineSpan] بشكل تسلسلي (بما في ذلك [WidgetSpan] كحرف واحد).
int _countCharsInSpan(InlineSpan span) {
  if (span is TextSpan) {
    int count = span.text?.length ?? 0;
    if (span.children != null) {
      for (final child in span.children!) {
        count += _countCharsInSpan(child);
      }
    }
    return count;
  }
  if (span is WidgetSpan) {
    return 1;
  }
  return 0;
}

/// نموذج يحمل نطاق نصي مع لون مخصص.
class _ColoredTextRange {
  final TextSelection range;
  final Color color;
  const _ColoredTextRange({required this.range, required this.color});
}

/// ويدجت يرسم خلفية التحديد والعلامات المرجعية خلف النص القرآني لكل آية على حدة.
class _AyahSelectionWidget extends SingleChildRenderObjectWidget {
  final List<TextSelection> selectedRanges;
  final Color selectionColor;
  final List<_ColoredTextRange> bookmarkRanges;
  final TextSelection? wordSelectionRange;

  const _AyahSelectionWidget({
    required this.selectedRanges,
    required this.selectionColor,
    this.bookmarkRanges = const [],
    this.wordSelectionRange,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _AyahSelectionRenderBox(
      selectedRanges: selectedRanges,
      selectionColor: selectionColor,
      bookmarkRanges: bookmarkRanges,
      wordSelectionRange: wordSelectionRange,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _AyahSelectionRenderBox renderObject) {
    renderObject
      ..selectedRanges = selectedRanges
      ..selectionColor = selectionColor
      ..bookmarkRanges = bookmarkRanges
      ..wordSelectionRange = wordSelectionRange;
  }
}

/// [RenderProxyBox] يرسم مستطيلات مستديرة خلف نطاقات الآيات المحددة
/// باستخدام [RenderParagraph.getBoxesForSelection].
class _AyahSelectionRenderBox extends RenderProxyBox {
  _AyahSelectionRenderBox({
    required List<TextSelection> selectedRanges,
    required Color selectionColor,
    List<_ColoredTextRange> bookmarkRanges = const [],
    TextSelection? wordSelectionRange,
  })  : _selectedRanges = selectedRanges,
        _selectionColor = selectionColor,
        _bookmarkRanges = bookmarkRanges,
        _wordSelectionRange = wordSelectionRange;

  static const _wordSelectionColor =
      Color(0xffCDAD80); // بدون alpha — يُطبّق عند الرسم

  List<TextSelection> _selectedRanges;
  set selectedRanges(List<TextSelection> value) {
    if (listEquals(_selectedRanges, value)) return;
    _selectedRanges = value;
    markNeedsPaint();
  }

  Color _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor == value) return;
    _selectionColor = value;
    markNeedsPaint();
  }

  List<_ColoredTextRange> _bookmarkRanges;
  set bookmarkRanges(List<_ColoredTextRange> value) {
    _bookmarkRanges = value;
    markNeedsPaint();
  }

  TextSelection? _wordSelectionRange;
  set wordSelectionRange(TextSelection? value) {
    if (_wordSelectionRange == value) return;
    _wordSelectionRange = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child is RenderParagraph) {
      // 1) علامات مرجعية (أسفل طبقة)
      if (_bookmarkRanges.isNotEmpty) {
        _paintColoredRanges(context, offset, _bookmarkRanges);
      }
      // 2) تحديد الكلمة
      if (_wordSelectionRange != null) {
        final paint = Paint()
          ..color = _wordSelectionColor.withValues(alpha: 0.25);
        _paintMergedBoxes(
          child! as RenderParagraph,
          context,
          offset,
          [_wordSelectionRange!],
          paint,
        );
      }
      // 3) تحديد الآية (أعلى طبقة)
      if (_selectedRanges.isNotEmpty) {
        _paintSelectionBackgrounds(context, offset);
      }
    }
    super.paint(context, offset);
  }

  /// رسم خلفيات التحديد خلف الآيات المحدّدة.
  void _paintSelectionBackgrounds(PaintingContext context, Offset offset) {
    final paragraph = child! as RenderParagraph;
    final bgPaint = Paint()..color = _selectionColor;
    _paintMergedBoxes(paragraph, context, offset, _selectedRanges, bgPaint);
  }

  /// رسم خلفيات العلامات المرجعية - كل نطاق بلونه الخاص.
  void _paintColoredRanges(
      PaintingContext context, Offset offset, List<_ColoredTextRange> ranges) {
    final paragraph = child! as RenderParagraph;
    for (final cr in ranges) {
      final paint = Paint()..color = cr.color;
      _paintMergedBoxes(paragraph, context, offset, [cr.range], paint);
    }
  }

  /// دمج المستطيلات على نفس السطر ورسم RRect مستدير.
  void _paintMergedBoxes(
    RenderParagraph paragraph,
    PaintingContext context,
    Offset offset,
    List<TextSelection> ranges,
    Paint bgPaint,
  ) {
    const padding = EdgeInsets.only(right: 4, top: 0, bottom: -6);

    for (final range in ranges) {
      final boxes = paragraph.getBoxesForSelection(
        range,
        boxHeightStyle: BoxHeightStyle.max,
      );
      if (boxes.isEmpty) continue;

      final mergedRects = <Rect>[];
      Rect? current;
      double? currentTop;
      const lineTolerance = 2.0;

      for (final box in boxes) {
        final rect = box.toRect();
        if (current == null) {
          current = rect;
          currentTop = rect.top;
        } else if ((rect.top - currentTop!).abs() < lineTolerance) {
          current = Rect.fromLTRB(
            math.min(current.left, rect.left),
            math.min(current.top, rect.top),
            math.max(current.right, rect.right),
            math.max(current.bottom, rect.bottom),
          );
        } else {
          mergedRects.add(current);
          current = rect;
          currentTop = rect.top;
        }
      }
      if (current != null) mergedRects.add(current);

      for (final rect in mergedRects) {
        final padded = padding.inflateRect(rect).shift(offset);
        context.canvas.drawRRect(
          RRect.fromRectAndRadius(padded, const Radius.circular(16)),
          bgPaint,
        );
      }
    }
  }
}
