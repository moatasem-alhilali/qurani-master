part of '/quran.dart';

enum QpcV4LineType {
  surahName,
  basmallah,
  ayah;

  static QpcV4LineType fromJson(dynamic value) {
    final v = (value ?? '').toString();
    switch (v) {
      case 'surah_name':
        return QpcV4LineType.surahName;
      case 'basmallah':
        return QpcV4LineType.basmallah;
      case 'ayah':
        return QpcV4LineType.ayah;
      default:
        throw FormatException('Unsupported line_type: $v');
    }
  }
}

int? _qpcTryParseOptionalInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  final s = value.toString().trim();
  if (s.isEmpty) return null;
  return int.tryParse(s);
}

class QpcV4AyahInfoLine {
  final int pageNumber;
  final int lineNumber;
  final QpcV4LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final int? firstWordId;
  final int? lastWordId;

  const QpcV4AyahInfoLine({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.firstWordId,
    required this.lastWordId,
  });

  factory QpcV4AyahInfoLine.fromJson(Map<String, dynamic> json) {
    return QpcV4AyahInfoLine(
      pageNumber: (json['page_number'] as num).toInt(),
      lineNumber: (json['line_number'] as num).toInt(),
      lineType: QpcV4LineType.fromJson(json['line_type']),
      isCentered: ((json['is_centered'] as num?)?.toInt() ?? 0) == 1,
      surahNumber: _qpcTryParseOptionalInt(json['surah_number']),
      firstWordId: _qpcTryParseOptionalInt(json['first_word_id']),
      lastWordId: _qpcTryParseOptionalInt(json['last_word_id']),
    );
  }
}

class QpcV4Word {
  final int id;
  final int surah;
  final int ayah;
  final int wordIndex;
  final String text;

  const QpcV4Word({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.wordIndex,
    required this.text,
  });

  factory QpcV4Word.fromJson(Map<String, dynamic> json) {
    return QpcV4Word(
      id: (json['id'] as num).toInt(),
      surah: int.parse(json['surah'].toString()),
      ayah: int.parse(json['ayah'].toString()),
      wordIndex: int.parse(json['word'].toString()),
      text: (json['text'] ?? '').toString(),
    );
  }
}

sealed class QpcV4RenderBlock {
  const QpcV4RenderBlock();
}

class QpcV4SurahHeaderBlock extends QpcV4RenderBlock {
  final int surahNumber;

  const QpcV4SurahHeaderBlock(this.surahNumber);
}

class QpcV4BasmallahBlock extends QpcV4RenderBlock {
  final int surahNumber;

  const QpcV4BasmallahBlock(this.surahNumber);
}

class QpcV4AyahSegment {
  final int ayahUq;
  final int surahNumber;
  final int ayahNumber;
  final String glyphs;
  final bool isAyahEnd;

  const QpcV4AyahSegment({
    required this.ayahUq,
    required this.surahNumber,
    required this.ayahNumber,
    required this.glyphs,
    required this.isAyahEnd,
  });
}

class QpcV4AyahLineBlock extends QpcV4RenderBlock {
  final bool isCentered;
  final List<QpcV4AyahSegment> segments;

  const QpcV4AyahLineBlock({
    required this.isCentered,
    required this.segments,
  });
}
