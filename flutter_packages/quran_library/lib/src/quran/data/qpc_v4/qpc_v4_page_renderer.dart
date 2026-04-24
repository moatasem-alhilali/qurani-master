part of '/quran.dart';

typedef QpcV4AyahUqResolver = int Function({
  required int surahNumber,
  required int ayahNumber,
});

typedef QpcV4WordTextResolver = String? Function(QpcV4Word word);

class QpcV4PageRenderer {
  const QpcV4PageRenderer({
    required this.store,
    required this.ayahUqResolver,
    this.wordTextResolver,
    this.insertWordSeparatorBetweenWords = false,
  });

  final QpcV4AssetsStore store;
  final QpcV4AyahUqResolver ayahUqResolver;
  final QpcV4WordTextResolver? wordTextResolver;
  final bool insertWordSeparatorBetweenWords;

  // static const int _ornamentHizbMark = 0x06DE; // ۞

  List<QpcV4RenderBlock> buildPage({required int pageNumber}) {
    final lines = store.linesByPage[pageNumber];
    if (lines == null || lines.isEmpty) return const <QpcV4RenderBlock>[];

    final endMaps = _buildAyahEndMaps(lines);
    final endWordIdByAyahKey = endMaps.endWordIdByAyahKey;
    final maxWordIndexByAyahKey = endMaps.maxWordIndexByAyahKey;

    final blocks = <QpcV4RenderBlock>[];
    var needsSingleSpaceAtPageStart = true;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      switch (line.lineType) {
        case QpcV4LineType.surahName:
          if (line.surahNumber != null) {
            blocks.add(QpcV4SurahHeaderBlock(line.surahNumber!));
          }
          break;

        case QpcV4LineType.basmallah:
          final inferred = _inferBasmalahSurahNumber(lines: lines, index: i);
          if (inferred != null) {
            blocks.add(QpcV4BasmallahBlock(inferred));
          }
          break;

        case QpcV4LineType.ayah:
          final rangeStart = line.firstWordId;
          final rangeEnd = line.lastWordId;
          if (rangeStart == null || rangeEnd == null) break;

          final result = _buildAyahSegmentsForLine(
            rangeStart: rangeStart,
            rangeEnd: rangeEnd,
            endWordIdByAyahKey: endWordIdByAyahKey,
            maxWordIndexByAyahKey: maxWordIndexByAyahKey,
            addSingleSpaceBetweenFirstTwoWords: needsSingleSpaceAtPageStart,
          );
          final segments = result.segments;
          if (segments.isNotEmpty) {
            blocks.add(QpcV4AyahLineBlock(
                isCentered: line.isCentered, segments: segments));
          }
          if (result.didInsertSingleSpaceBetweenFirstTwoWords) {
            needsSingleSpaceAtPageStart = false;
          }
          break;
      }
    }

    return blocks;
  }

  ({Map<int, int> endWordIdByAyahKey, Map<int, int> maxWordIndexByAyahKey})
      _buildAyahEndMaps(List<QpcV4AyahInfoLine> lines) {
    final lastWordIdSeenByAyahKey = <int, int>{};
    final maxWordIndexByAyahKey = <int, int>{};

    for (final line in lines) {
      if (line.lineType != QpcV4LineType.ayah) continue;
      final start = line.firstWordId;
      final end = line.lastWordId;
      if (start == null || end == null) continue;

      for (var wordId = start; wordId <= end; wordId++) {
        final w = store.wordsById[wordId];
        if (w == null) continue;
        final key = _ayahKey(w.surah, w.ayah);
        lastWordIdSeenByAyahKey[key] = wordId;
        final prevMax = maxWordIndexByAyahKey[key];
        if (prevMax == null || w.wordIndex > prevMax) {
          maxWordIndexByAyahKey[key] = w.wordIndex;
        }
      }
    }

    // ملفات QPC غالباً تضيف عنصراً أخيراً داخل نفس (سورة/آية) يمثل رقم الآية.
    // نعتبره أعلى wordIndex داخل الآية، ونحدد نهاية الآية على آخر كلمة حقيقية.
    final endWordIdByAyahKey = <int, int>{};
    for (final entry in lastWordIdSeenByAyahKey.entries) {
      final key = entry.key;
      final lastWordId = entry.value;
      final maxIndex = maxWordIndexByAyahKey[key];
      if (maxIndex == null) {
        endWordIdByAyahKey[key] = lastWordId;
        continue;
      }

      var effectiveEnd = lastWordId;
      while (effectiveEnd > 0) {
        final w = store.wordsById[effectiveEnd];
        if (w == null) break;
        if (_ayahKey(w.surah, w.ayah) != key) break;
        if (w.wordIndex != maxIndex) break;
        effectiveEnd -= 1;
      }

      endWordIdByAyahKey[key] = effectiveEnd > 0 ? effectiveEnd : lastWordId;
    }

    return (
      endWordIdByAyahKey: endWordIdByAyahKey,
      maxWordIndexByAyahKey: maxWordIndexByAyahKey,
    );
  }

  ({
    List<QpcV4WordSegment> segments,
    bool didInsertSingleSpaceBetweenFirstTwoWords,
  }) _buildAyahSegmentsForLine({
    required int rangeStart,
    required int rangeEnd,
    required Map<int, int> endWordIdByAyahKey,
    required Map<int, int> maxWordIndexByAyahKey,
    required bool addSingleSpaceBetweenFirstTwoWords,
  }) {
    final segments = <QpcV4WordSegment>[];
    var didInsertSingleSpaceBetweenFirstTwoWords = false;

    var realWordsWritten = 0;

    for (var wordId = rangeStart; wordId <= rangeEnd; wordId++) {
      final w = store.wordsById[wordId];
      if (w == null) continue;
      final key = _ayahKey(w.surah, w.ayah);

      // تجاهل عنصر "رقم الآية" الموجود كآخر wordIndex في qpc-v4.json.
      final maxIndex = maxWordIndexByAyahKey[key];
      if (maxIndex != null && w.wordIndex == maxIndex) {
        continue;
      }

      final uq = ayahUqResolver(surahNumber: w.surah, ayahNumber: w.ayah);
      if (uq == 0) {
        continue;
      }

      final endWordId = endWordIdByAyahKey[key];
      final isAyahEnd = endWordId != null && wordId == endWordId;

      final resolvedText =
          (wordTextResolver != null) ? wordTextResolver!(w) : w.text;
      if (resolvedText == null || resolvedText.isEmpty) {
        continue;
      }

      // حل مستهدف: المشكلة عندك فقط بين أول وثاني كلمة في الصفحة.
      // لذلك نضيف فاصلًا مرة واحدة فقط قبل الكلمة الثانية الفعلية في أول سطر آيات.
      // استخدمنا No‑Break Space لتجنب التفاف/كسر السطر.

      // بعض العلامات (مثل زخرفة ۞) تكون "ملتصقة" بالكلمة التالية داخل نفس word
      // (مثال: text="ﱁﱂ"). في هذه الحالة نُدخل الفاصل داخل النص بين أول محرف
      // وباقي النص، ونعتبر أننا عالجنا فاصل بداية الصفحة.
      if (addSingleSpaceBetweenFirstTwoWords && realWordsWritten == 0) {
        final runes = resolvedText.runes.toList(growable: false);
        // if (runes.length > 1 && runes.first == _ornamentHizbMark) {
        final glyphs =
            '${String.fromCharCode(runes.first)}\u202F${String.fromCharCodes(runes.skip(1))}';
        didInsertSingleSpaceBetweenFirstTwoWords = true;
        segments.add(
          QpcV4WordSegment(
            wordId: w.id,
            ayahUq: uq,
            surahNumber: w.surah,
            ayahNumber: w.ayah,
            wordNumber: w.wordIndex,
            glyphs: glyphs,
            isAyahEnd: isAyahEnd,
          ),
        );
        realWordsWritten += 2;
        continue;
        // }
      }

      var glyphs = resolvedText;
      final shouldPrefixWordSep =
          insertWordSeparatorBetweenWords && realWordsWritten > 0;
      if (addSingleSpaceBetweenFirstTwoWords && realWordsWritten == 1) {
        glyphs = '\u202F$glyphs';
        didInsertSingleSpaceBetweenFirstTwoWords = true;
      } else if (shouldPrefixWordSep) {
        glyphs = '\u202F$glyphs';
      }

      segments.add(
        QpcV4WordSegment(
          wordId: w.id,
          ayahUq: uq,
          surahNumber: w.surah,
          ayahNumber: w.ayah,
          wordNumber: w.wordIndex,
          glyphs: glyphs,
          isAyahEnd: isAyahEnd,
        ),
      );
      realWordsWritten++;
    }
    return (
      segments: segments,
      didInsertSingleSpaceBetweenFirstTwoWords:
          didInsertSingleSpaceBetweenFirstTwoWords,
    );
  }

  int? _inferBasmalahSurahNumber({
    required List<QpcV4AyahInfoLine> lines,
    required int index,
  }) {
    for (var i = index + 1; i < lines.length; i++) {
      final next = lines[i];
      if (next.lineType != QpcV4LineType.ayah) continue;
      final start = next.firstWordId;
      if (start == null) continue;
      final word = store.wordsById[start];
      return word?.surah;
    }
    return null;
  }

  int _ayahKey(int surah, int ayah) => surah * 1000 + ayah;
}
