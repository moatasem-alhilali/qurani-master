part of '../../quran.dart';

class GetSingleAyah extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final Color? textColor;
  final bool? isDark;
  final bool? isBold;
  final double? fontSize;
  final AyahModel? ayahs;
  final bool? isSingleAyah;
  final bool? islocalFont;
  final String? fontsName;
  final int? pageIndex;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final TextAlign? textAlign;
  final bool? enabledTajweed;

  /// تفعيل خاصية تحديد الكلمة بضغطة واحدة (يعمل مع خط QPC فقط).
  /// عند التفعيل، تُحدّد أول كلمة افتراضياً.
  final bool enableWordSelection;

  /// callback يُستدعى عند الضغط على كلمة، يعيد [WordRef] يحتوي
  /// (surahNumber, ayahNumber, wordNumber).
  final Function(WordRef wordRef)? onWordTap;

  /// لون خلفية الكلمة المحدّدة. الافتراضي: لون primary بشفافية 0.25.
  final Color? selectedWordColor;

  /// لتحديد كلمة برمجياً من الخارج. عند تمريره يُتجاهل التحديد المحلي.
  final WordRef? externalSelectedWordRef;

  /// نطاق كلمات محدّدة (شامل). مثال: `(fromWord: 1, toWord: 3)` يُظلل
  /// الكلمات 1 و2 و3. يأخذ أولوية على [externalSelectedWordRef].
  final ({int fromWord, int toWord})? selectedWordsRange;

  /// لإظهار أيقونة بجانب الآية.
  final bool? showAyahNumber;

  final double? textHeight;

  GetSingleAyah({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.textColor,
    this.isDark = false,
    this.fontSize,
    this.isBold = true,
    this.ayahs,
    this.isSingleAyah = true,
    this.islocalFont = false,
    this.fontsName,
    this.pageIndex,
    this.onAyahLongPress,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = false,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.ayahSelectedBackgroundColor,
    this.textAlign,
    this.enabledTajweed,
    this.enableWordSelection = false,
    this.onWordTap,
    this.selectedWordColor,
    this.externalSelectedWordRef,
    this.selectedWordsRange,
    this.showAyahNumber = true,
    this.textHeight,
  });

  final QuranCtrl quranCtrl = QuranCtrl.instance;

  /// حالة الكلمة المحدّدة — محلية لهذا الويدجت فقط ولا تؤثر على الحالة العامّة.
  final Rx<WordRef?> _localSelectedWord = Rx<WordRef?>(null);

  @override
  Widget build(BuildContext context) {
    QuranCtrl.instance.state.isTajweedEnabled.value = enabledTajweed ?? false;
    GetStorage().write(_StorageConstants().isTajweed,
        QuranCtrl.instance.state.isTajweedEnabled.value);
    if (surahNumber < 1 || surahNumber > 114) {
      return Text(
        'رقم السورة غير صحيح',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        textAlign: textAlign,
      );
    }
    final ayah = ayahs ??
        QuranCtrl.instance
            .getSingleAyahByAyahAndSurahNumber(ayahNumber, surahNumber);
    final pageNumber = pageIndex ??
        QuranCtrl.instance
            .getPageNumberByAyahAndSurahNumber(ayahNumber, surahNumber);
    QuranFontsService.ensurePagesLoaded(pageNumber, radius: 0).then((_) {
      // update();
      // update(['_pageViewBuild']);
      // تحميل بقية الصفحات في الخلفية
      // QuranFontsService.loadRemainingInBackground(
      //   startNearPage: pageNumber,
      //   progress: QuranCtrl.instance.state.fontsLoadProgress,
      //   ready: QuranCtrl.instance.state.fontsReady,
      // ).then((_) {
      //   // update();
      QuranCtrl.instance.update(['single_ayah_$surahNumber-$ayahNumber']);
      // });
    });
    log('surahNumber: $surahNumber, ayahNumber: $ayahNumber, pageNumber: $pageNumber');

    if (ayah.text.isEmpty) {
      return Text(
        'الآية غير موجودة',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        textAlign: textAlign,
      );
    }

    // استخدام نفس طريقة عرض PageBuild إذا كان QPC Layout مفعل
    if (quranCtrl.isQpcLayoutEnabled) {
      return GetBuilder<QuranCtrl>(
          id: 'single_ayah_$surahNumber-$ayahNumber',
          builder: (_) {
            return _buildQpcLayout(context, pageNumber, ayah);
          });
    }

    // العرض التقليدي للخطوط الأخرى
    return _buildTraditionalLayout(context, pageNumber, ayah);
  }

  /// بناء الآية باستخدام نفس طريقة PageBuild (QPC Layout)
  Widget _buildQpcLayout(BuildContext context, int pageNumber, AyahModel ayah) {
    final blocks = quranCtrl.getQpcLayoutBlocksForPageSync(pageNumber);
    if (blocks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final ayahUq = ayah.ayahUQNumber;

    // استخراج segments الخاصة بالآية المطلوبة فقط
    final List<QpcV4WordSegment> ayahSegments = [];
    for (final block in blocks) {
      if (block is QpcV4AyahLineBlock) {
        for (final seg in block.segments) {
          if (seg.surahNumber == surahNumber && seg.ayahNumber == ayahNumber) {
            ayahSegments.add(seg);
          }
        }
      }
    }

    if (ayahSegments.isEmpty) {
      // fallback للعرض التقليدي إذا لم يتم العثور على segments
      return _buildTraditionalLayout(context, pageNumber, ayah);
    }

    // عرض مع تحديد الكلمات
    if (enableWordSelection) {
      return _buildSelectableQpcWidget(context, pageNumber, ayahSegments);
    }

    // العرض الأصلي بدون تحديد الكلمات
    return GetBuilder<QuranCtrl>(
      id: 'single_ayah_$ayahUq',
      builder: (_) => LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              (fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx));

          return _buildRichTextFromSegments(
            context: context,
            segments: ayahSegments,
            fontSize: fs,
            ayahUq: ayahUq,
            pageNumber: pageNumber,
            showAyahNumber: showAyahNumber,
          );
        },
      ),
    );
  }

  /// بناء RichText من segments
  Widget _buildRichTextFromSegments({
    required BuildContext context,
    required List<QpcV4WordSegment> segments,
    required double fontSize,
    required int ayahUq,
    required int pageNumber,
    bool? showAyahNumber,
  }) {
    final wordInfoCtrl = WordInfoCtrl.instance;
    final bookmarksCtrl = BookmarksCtrl.instance;
    final bookmarks = bookmarksCtrl.bookmarks;
    final bookmarksAyahs = bookmarksCtrl.bookmarksAyahs;
    final ayahBookmarked = bookmarksAyahs.toList();
    final allBookmarksList = bookmarks.values.expand((list) => list).toList();

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.right,
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

          final ref = WordRef(
            surahNumber: seg.surahNumber,
            ayahNumber: seg.ayahNumber,
            wordNumber: seg.wordNumber,
          );

          final info = wordInfoCtrl.getRecitationsInfoSync(ref);
          final hasKhilaf = info?.hasKhilaf ?? false;

          return _qpcV4SpanSegment(
            context: context,
            pageIndex: pageNumber - 1,
            isSelected: isSelectedCombined,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            fontSize: fontSize,
            ayahUQNum: uq,
            ayahNumber: seg.ayahNumber,
            glyphs: seg.glyphs,
            showAyahNumber: (showAyahNumber ?? true) && seg.isAyahEnd,
            wordRef: ref,
            isWordKhilaf: hasKhilaf,
            textColor: textColor ?? AppColors.getTextColor(isDark ?? false),
            ayahIconColor: ayahIconColor,
            allBookmarksList: allBookmarksList,
            bookmarksAyahs: bookmarksAyahs,
            bookmarksColor: bookmarksColor,
            customBookmarksColor: customBookmarksColor,
            ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
            isFontsLocal: islocalFont ?? false,
            fontsName: fontsName ?? '',
            fontFamilyOverride: null,
            fontPackageOverride: null,
            usePaintColoring: true,
            ayahBookmarked: ayahBookmarked,
            isDark: isDark ?? false,
          );
        }),
      ),
    );
  }

  /// بناء ويدجت QPC مع دعم تحديد الكلمات — معزول تماماً
  Widget _buildSelectableQpcWidget(
    BuildContext context,
    int pageNumber,
    List<QpcV4WordSegment> segments,
  ) {
    // نطاق خارجي يأخذ أولوية → لا حاجة لحالة محلية
    if (selectedWordsRange != null) {
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx);
          return _buildSelectableRichText(
            context: context,
            segments: segments,
            fontSize: fs,
            pageNumber: pageNumber,
            selectedWord: null,
          );
        },
      );
    }

    // تهيئة الكلمة المحدّدة (وضع كلمة واحدة)
    if (externalSelectedWordRef != null) {
      _localSelectedWord.value = externalSelectedWordRef;
    } else if (_localSelectedWord.value == null && segments.isNotEmpty) {
      final first = segments.first;
      final firstWord = WordRef(
        surahNumber: first.surahNumber,
        ayahNumber: first.ayahNumber,
        wordNumber: first.wordNumber,
      );
      _localSelectedWord.value = firstWord;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onWordTap?.call(firstWord);
      });
    }

    return Obx(() {
      final currentWord = _localSelectedWord.value;
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx);
          return _buildSelectableRichText(
            context: context,
            segments: segments,
            fontSize: fs,
            pageNumber: pageNumber,
            selectedWord: currentWord,
          );
        },
      );
    });
  }

  /// بناء RichText مع دعم تحديد الكلمات — معزول عن [_buildRichTextFromSegments]
  Widget _buildSelectableRichText({
    required BuildContext context,
    required List<QpcV4WordSegment> segments,
    required double fontSize,
    required int pageNumber,
    required WordRef? selectedWord,
  }) {
    final effectiveColor = selectedWordColor ??
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.25);

    final range = selectedWordsRange;

    // جمع نطاقات أحرف الكلمات المحدّدة لرسم التظليل عبر CustomPaint
    final List<TextSelection> highlightRanges = [];
    int charOffset = 0;

    final spans = List.generate(segments.length, (i) {
      final seg = segments[i];
      final ref = WordRef(
        surahNumber: seg.surahNumber,
        ayahNumber: seg.ayahNumber,
        wordNumber: seg.wordNumber,
      );

      final span = _buildWordSelectableSpan(
        context: context,
        seg: seg,
        wordRef: ref,
        fontSize: fontSize,
        pageNumber: pageNumber,
      );

      final spanCharCount = _countCharsInSpan(span);

      // تحديد ما إذا كانت هذه الكلمة ضمن النطاق أو الكلمة الواحدة
      final bool isSelected;
      if (range != null) {
        isSelected =
            seg.wordNumber >= range.fromWord && seg.wordNumber <= range.toWord;
      } else {
        isSelected = selectedWord == ref;
      }

      if (isSelected) {
        highlightRanges.add(TextSelection(
          baseOffset: charOffset,
          extentOffset: charOffset + seg.glyphs.length,
        ));
      }
      charOffset += spanCharCount;

      return span;
    });

    final richText = RichText(
      textDirection: TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.right,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(children: spans),
    );

    // لف بـ CustomPaint لرسم تظليل الكلمات المحدّدة
    if (highlightRanges.isNotEmpty) {
      return _SingleAyahWordHighlight(
        wordSelectionRanges: highlightRanges,
        highlightColor: effectiveColor,
        isContiguous: range != null,
        child: richText,
      );
    }

    return richText;
  }

  /// بناء TextSpan لكلمة واحدة مع دعم الضغط للتحديد — معزول عن [_qpcV4SpanSegment]
  TextSpan _buildWordSelectableSpan({
    required BuildContext context,
    required QpcV4WordSegment seg,
    required WordRef wordRef,
    required double fontSize,
    required int pageNumber,
  }) {
    final pageIndex = pageNumber - 1;
    final withTajweed = QuranCtrl.instance.state.isTajweedEnabled.value;
    final isTenRecitations = WordInfoCtrl.instance.isTenRecitations;

    final info = WordInfoCtrl.instance.getRecitationsInfoSync(wordRef);
    final hasKhilaf = info?.hasKhilaf ?? false;
    final bool forceRed = hasKhilaf && !withTajweed && isTenRecitations;

    final String fontFamily;
    if (islocalFont == true) {
      fontFamily = fontsName ?? '';
    } else if (forceRed) {
      fontFamily = quranCtrl.getRedFontPath(pageIndex);
    } else {
      fontFamily = quranCtrl.getFontPath(pageIndex, isDark: isDark ?? false);
    }

    final baseTextStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: textHeight ?? 1.2,
      wordSpacing: -2,
      color: textColor ?? AppColors.getTextColor(isDark ?? false),
    );

    InlineSpan? tail;
    if (seg.isAyahEnd) {
      final hasBookmark =
          BookmarksCtrl.instance.bookmarksAyahs.contains(seg.ayahUq);

      if (hasBookmark && showAyahBookmarkedIcon && !kIsWeb) {
        tail = WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SvgPicture.asset(
              AssetsPath.assets.ayahBookmarked,
              height: 30,
              width: 30,
            ),
          ),
        );
      } else {
        tail = TextSpan(
          text:
              '${' ${seg.ayahNumber}'.convertEnglishNumbersToArabic('${seg.ayahNumber}')}\u202F\u202F',
          style: TextStyle(
            fontFamily: 'ayahNumber',
            fontSize: fontSize + 5,
            height: 1.5,
            package: 'quran_library',
            color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }

    return TextSpan(
      children: <InlineSpan>[
        TextSpan(
          text: seg.glyphs,
          style: baseTextStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _localSelectedWord.value = wordRef;
              onWordTap?.call(wordRef);
            },
        ),
        if (tail != null) tail,
      ],
    );
  }
}

/// ويدجت رسم محلي لتظليل الكلمات المحدّدة — معزول عن [_AyahSelectionWidget]
class _SingleAyahWordHighlight extends SingleChildRenderObjectWidget {
  final List<TextSelection> wordSelectionRanges;
  final Color highlightColor;

  /// عند `true` يُرسم النطاق كشريط متصل مع borderRadius على أول/آخر حافة فقط.
  final bool isContiguous;

  const _SingleAyahWordHighlight({
    required this.wordSelectionRanges,
    required this.highlightColor,
    this.isContiguous = false,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SingleAyahWordHighlightRenderBox(
      wordRanges: wordSelectionRanges,
      highlightColor: highlightColor,
      isContiguous: isContiguous,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _SingleAyahWordHighlightRenderBox renderObject) {
    renderObject
      ..wordRanges = wordSelectionRanges
      ..highlightColor = highlightColor
      ..isContiguous = isContiguous;
  }
}

class _SingleAyahWordHighlightRenderBox extends RenderProxyBox {
  _SingleAyahWordHighlightRenderBox({
    required List<TextSelection> wordRanges,
    required Color highlightColor,
    required bool isContiguous,
  })  : _wordRanges = wordRanges,
        _highlightColor = highlightColor,
        _isContiguous = isContiguous;

  List<TextSelection> _wordRanges;
  set wordRanges(List<TextSelection> value) {
    if (listEquals(_wordRanges, value)) return;
    _wordRanges = value;
    markNeedsPaint();
  }

  Color _highlightColor;
  set highlightColor(Color value) {
    if (_highlightColor == value) return;
    _highlightColor = value;
    markNeedsPaint();
  }

  bool _isContiguous;
  set isContiguous(bool value) {
    if (_isContiguous == value) return;
    _isContiguous = value;
    markNeedsPaint();
  }

  static const _radius = Radius.circular(16);
  static const _padding =
      EdgeInsets.only(left: 4, right: 4, top: 0, bottom: -6);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child is RenderParagraph && _wordRanges.isNotEmpty) {
      final paragraph = child! as RenderParagraph;
      final paint = Paint()..color = _highlightColor;

      if (_isContiguous) {
        _paintContiguous(paragraph, context, offset, paint);
      } else {
        _paintIndividual(paragraph, context, offset, paint);
      }
    }
    super.paint(context, offset);
  }

  /// رسم نطاق متصل — كل سطر مستطيل واحد، borderRadius على الحواف الخارجية فقط.
  void _paintContiguous(
    RenderParagraph paragraph,
    PaintingContext context,
    Offset offset,
    Paint paint,
  ) {
    // جمع كل boxes من كل النطاقات في قائمة واحدة
    final allBoxes = <TextBox>[];
    for (final range in _wordRanges) {
      allBoxes.addAll(paragraph.getBoxesForSelection(
        range,
        boxHeightStyle: BoxHeightStyle.max,
      ));
    }
    if (allBoxes.isEmpty) return;

    // دمج المستطيلات على نفس السطر
    final lineRects = <Rect>[];
    Rect? current;
    double? currentTop;
    const lineTolerance = 2.0;

    for (final box in allBoxes) {
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
        lineRects.add(current);
        current = rect;
        currentTop = rect.top;
      }
    }
    if (current != null) lineRects.add(current);

    // رسم كل سطر: borderRadius على الحواف الخارجية فقط
    for (int i = 0; i < lineRects.length; i++) {
      final padded = _padding.inflateRect(lineRects[i]).shift(offset);
      final bool isFirst = i == 0;
      final bool isLast = i == lineRects.length - 1;

      // النص RTL: أول سطر حوافه اليمنى مستديرة، آخر سطر حوافه اليسرى
      // لسطر واحد: كل الحواف مستديرة
      final RRect rRect;
      if (lineRects.length == 1) {
        rRect = RRect.fromRectAndRadius(padded, _radius);
      } else if (isFirst) {
        // أول سطر في RTL: حواف يمنى مستديرة (topRight, bottomRight)
        rRect = RRect.fromRectAndCorners(
          padded,
          topRight: _radius,
          bottomRight: _radius,
        );
      } else if (isLast) {
        // آخر سطر في RTL: حواف يسرى مستديرة (topLeft, bottomLeft)
        rRect = RRect.fromRectAndCorners(
          padded,
          topLeft: _radius,
          bottomLeft: _radius,
        );
      } else {
        // أسطر وسطى: بدون borderRadius
        rRect = RRect.fromRectAndRadius(padded, Radius.zero);
      }

      context.canvas.drawRRect(rRect, paint);
    }
  }

  /// رسم كل كلمة بشكل منفصل مع borderRadius على كل مستطيل.
  void _paintIndividual(
    RenderParagraph paragraph,
    PaintingContext context,
    Offset offset,
    Paint paint,
  ) {
    for (final range in _wordRanges) {
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
        final padded = _padding.inflateRect(rect).shift(offset);
        context.canvas.drawRRect(
          RRect.fromRectAndRadius(padded, _radius),
          paint,
        );
      }
    }
  }
}

/// العرض التقليدي للخطوط غير QPC — يظل داخل [GetSingleAyah]
extension _GetSingleAyahTraditional on GetSingleAyah {
  Widget _buildTraditionalLayout(
      BuildContext context, int pageNumber, AyahModel ayah) {
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(
        style: TextStyle(
          fontFamily: islocalFont == true
              ? fontsName
              : QuranCtrl.instance
                  .getFontPath(pageNumber - 1, isDark: isDark ?? false),
          package: 'quran_library',
          fontSize: fontSize ?? 22,
          height: 2.0,
          fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        children: [
          TextSpan(
            text: '${ayah.text.replaceAll('\n', '').split(' ').join(' ')} ',
          ),
          TextSpan(
            text: '${ayah.ayahNumber}'
                .convertEnglishNumbersToArabic('${ayah.ayahNumber}'),
            style: TextStyle(
              fontFamily: 'ayahNumber',
              package: 'quran_library',
              color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
