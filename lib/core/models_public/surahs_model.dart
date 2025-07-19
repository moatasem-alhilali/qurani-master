class Surah {
  Surah({
    required this.surahNumber,
    required this.arabicName,
    required this.englishName,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final ayahsFromJson = json['ayahs'] as List;
    final ayahsList = ayahsFromJson
        .map((i) => AyahQuranModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return Surah(
      surahNumber: json['number'] as int,
      arabicName: json['name'] as String,
      englishName: json['englishName'] as String,
      revelationType: json['revelationType'] as String,
      ayahs: ayahsList,
    );
  }
  final int surahNumber;
  final String arabicName;
  final String englishName;
  final String revelationType;
  final List<AyahQuranModel> ayahs;
}

class AyahQuranModel {
  AyahQuranModel({
    required this.ayahUQNumber,
    required this.ayahNumber,
    required this.text,
    required this.aya_text_emlaey,
    required this.code_v2,
    required this.juz,
    required this.page,
    required this.sajda,
    required this.audio,
  });

  factory AyahQuranModel.fromJson(Map<String, dynamic> json) {
    return AyahQuranModel(
      ayahUQNumber: json['number'] as int,
      ayahNumber: json['numberInSurah'] as int,
      text: json['text'] as String,
      aya_text_emlaey: json['aya_text_emlaey'] as String,
      code_v2: json['code_v2'] as String,
      juz: json['juz'] as int,
      page: json['page'] as int,
      sajda: json['sajda'],
      audio: json['audio'] as String,
    );
  }
  final int ayahUQNumber;
  final int ayahNumber;
  final String text;
  final String aya_text_emlaey;
  final String code_v2;
  final String audio;
  final int juz;
  final int page;
  dynamic sajda;
}

class Sajda {
  Sajda({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  factory Sajda.fromJson(Map<String, dynamic> json) {
    return Sajda(
      id: json['id'] as int,
      recommended: json['recommended'] as bool,
      obligatory: json['obligatory'] as bool,
    );
  }
  final int id;
  final bool recommended;
  final bool obligatory;
}
