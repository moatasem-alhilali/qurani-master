part of '/quran.dart';

enum WordInfoKind {
  recitations,
  tasreef,
  eerab,
}

class WordRef {
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;

  const WordRef({
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is WordRef &&
            other.surahNumber == surahNumber &&
            other.ayahNumber == ayahNumber &&
            other.wordNumber == wordNumber);
  }

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber, wordNumber);
}

class QiraatWordInfo {
  final int suraNumber;
  final String? suraName;
  final int ayaNumber;
  final int wordNumber;
  final String word;
  final String content;
  final bool hasKhilaf;

  const QiraatWordInfo({
    required this.suraNumber,
    required this.suraName,
    required this.ayaNumber,
    required this.wordNumber,
    required this.word,
    required this.content,
    required this.hasKhilaf,
  });

  factory QiraatWordInfo.fromJson(Map<String, dynamic> json) {
    return QiraatWordInfo(
      suraNumber: (json['sura_number'] as num?)?.toInt() ??
          int.tryParse(json['sura_number']?.toString() ?? '') ??
          0,
      suraName: json['sura_name']?.toString(),
      ayaNumber: (json['aya_number'] as num?)?.toInt() ??
          int.tryParse(json['aya_number']?.toString() ?? '') ??
          0,
      wordNumber: (json['word_number'] as num?)?.toInt() ??
          int.tryParse(json['word_number']?.toString() ?? '') ??
          0,
      word: (json['word'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      hasKhilaf: (json['has_khilaf'] as bool?) ??
          (json['has_khilaf']?.toString() == 'true'),
    );
  }
}

class QiraatAyahWords {
  final int ayaNumber;
  final List<QiraatWordInfo> words;

  const QiraatAyahWords({
    required this.ayaNumber,
    required this.words,
  });

  factory QiraatAyahWords.fromJson(Map<String, dynamic> json) {
    final rawWords = (json['words'] as List?) ?? const [];
    return QiraatAyahWords(
      ayaNumber: (json['aya_number'] as num?)?.toInt() ??
          int.tryParse(json['aya_number']?.toString() ?? '') ??
          0,
      words: rawWords
          .whereType<Map>()
          .map((e) => QiraatWordInfo.fromJson(e.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }

  QiraatWordInfo? wordByNumber(int wordNumber) {
    return words.firstWhereOrNull((w) => w.wordNumber == wordNumber);
  }
}

class QiraatSurahWords {
  final int surahNumber;
  final Map<int, QiraatAyahWords> ayahsByNumber;

  const QiraatSurahWords({
    required this.surahNumber,
    required this.ayahsByNumber,
  });

  factory QiraatSurahWords.fromJson({
    required int surahNumber,
    required List<dynamic> jsonList,
  }) {
    final map = <int, QiraatAyahWords>{};
    for (final item in jsonList) {
      if (item is! Map) continue;
      final ayah = QiraatAyahWords.fromJson(item.cast<String, dynamic>());
      if (ayah.ayaNumber != 0) {
        map[ayah.ayaNumber] = ayah;
      }
    }

    return QiraatSurahWords(
      surahNumber: surahNumber,
      ayahsByNumber: map,
    );
  }

  QiraatWordInfo? lookup(WordRef ref) {
    final ayah = ayahsByNumber[ref.ayahNumber];
    return ayah?.wordByNumber(ref.wordNumber);
  }
}
