part of '/quran.dart';

class SurahNamesModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int ayahsNumber;
  final String surahInfo;
  final String surahInfoFromBook;
  final String surahNames;
  final String surahNamesFromBook;

  SurahNamesModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahsNumber,
    required this.surahInfo,
    required this.surahInfoFromBook,
    required this.surahNames,
    required this.surahNamesFromBook,
  });

  factory SurahNamesModel.fromJson(Map<String, dynamic> json) {
    return SurahNamesModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      ayahsNumber: json['ayahsNumber'],
      surahInfo: json['surahInfo'],
      surahInfoFromBook: json['surahInfoFromBook'],
      surahNames: json['surahNames'],
      surahNamesFromBook: json['surahNamesFromBook'],
    );
  }
}

class SurahResponseModel {
  final int code;
  final String status;
  final List<SurahNamesModel> surahs;

  SurahResponseModel({
    required this.code,
    required this.status,
    required this.surahs,
  });

  factory SurahResponseModel.fromJson(Map<String, dynamic> json) {
    return SurahResponseModel(
      code: json['code'],
      status: json['status'],
      surahs: List<SurahNamesModel>.from(
        json['data']['surahs'].map((x) => SurahNamesModel.fromJson(x)),
      ),
    );
  }
}
