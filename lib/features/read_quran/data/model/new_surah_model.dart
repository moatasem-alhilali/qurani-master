import 'dart:convert';

class NewSurahModel {
  NewSurahModel({
    required this.id,
    required this.surahNumber,
    required this.nameAr,
    required this.ayahCount,
    this.nameEn,
    this.translation,
    this.revelationType,
  });

  factory NewSurahModel.fromMap(Map<String, dynamic> map) => NewSurahModel(
        id: map['id'] as int,
        surahNumber: map['number'] as int,
        nameAr: map['name_ar'] as String,
        nameEn: map['name_en'] as String?,
        translation: map['translation'] as String?,
        revelationType: map['revelation_type'] as String?,
        ayahCount: map['ayah_count'] as int,
      );
  final int id;
  final int surahNumber;
  final String nameAr;
  final String? nameEn;
  final String? translation;
  final String? revelationType;
  final int ayahCount;

  static const String tableName = 'surahs';
}

class NewAyahModel {
  NewAyahModel({
    required this.id,
    required this.surahId,
    required this.numberGlobal,
    required this.ayahNumber,
    required this.text,
    this.textEmlaey,
    this.page,
    this.pageInSurah,
    this.juz,
    this.manzil,
    this.ruku,
    this.hizb,
    this.sajda,
    this.codeV2,
    this.audio,
    this.audioSecondary,
    this.tafsir,
  });

  factory NewAyahModel.fromMap(Map<String, dynamic> map) => NewAyahModel(
        id: map['id'] as int,
        surahId: map['surah_id'] as int,
        numberGlobal: map['number_global'] as int,
        ayahNumber: map['ayah_number'] as int,
        text: map['text'] as String,
        textEmlaey: map['text_emlaey'] as String?,
        page: map['page'] as int?,
        pageInSurah: map['page_in_surah'] as int?,
        juz: map['juz'] as int?,
        manzil: map['manzil'] as int?,
        ruku: map['ruku'] as int?,
        hizb: map['hizb'] as int?,
        sajda: map['sajda'] as int?,
        codeV2: map['code_v2'] as String?,
        audio: map['audio'] as String?,
        audioSecondary: map['audio_secondary'] != null
            ? List<String>.from(
                (jsonDecode(map['audio_secondary'] as String) as List<dynamic>)
                    .map((e) => e.toString()),
              )
            : null,
        tafsir: map['tafsir'] as String?,
      );
  final int id;
  final int surahId;
  final int numberGlobal; // ترقيم عالمي لكل آية
  final int ayahNumber;
  final String text;
  final String? textEmlaey;
  final int? page;
  final int? pageInSurah;
  final int? juz;
  final int? manzil;
  final int? ruku;
  final int? hizb;
  final int? sajda;
  final String? codeV2;
  final String? audio;
  final List<String>? audioSecondary; // من JSON string
  final String? tafsir;

  static const String tableName = 'ayahs';
}

class QuranSearchResult {
  QuranSearchResult.surah(this.surahId, this.surahName)
      : isSurah = true,
        ayah = null;
  QuranSearchResult.ayah(this.ayah)
      : isSurah = false,
        surahId = null,
        surahName = null;
  final bool isSurah;
  final String? surahName;
  final int? surahId;
  final NewAyahModel? ayah;
}

class VerseReaderModel {
  VerseReaderModel({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.id,
    this.direction,
  });

  factory VerseReaderModel.fromMap(Map<String, dynamic> map) {
    return VerseReaderModel(
      id: map['id'] as int?,
      identifier: map['identifier'] as String,
      language: map['language'] as String,
      name: map['name'] as String,
      englishName: map['english_name'] as String,
      format: map['format'] as String,
      type: map['type'] as String,
      direction: map['direction'] as String?,
    );
  }
  final int? id;
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  static const String tableName = 'verse_readers';
}

class SurahVerseReaderModel {
  SurahVerseReaderModel({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.id,
    this.bitrate,
  });

  factory SurahVerseReaderModel.fromMap(Map<String, dynamic> map) {
    return SurahVerseReaderModel(
      id: map['id'] as int?,
      identifier: map['identifier'] as String,
      language: map['language'] as String,
      name: map['name'] as String,
      englishName: map['english_name'] as String,
      format: map['format'] as String,
      type: map['type'] as String,
      bitrate: map['bitrate'] as String?,
    );
  }
  final int? id;
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? bitrate;

  static const String tableName = 'surah_verse_readers';
}
