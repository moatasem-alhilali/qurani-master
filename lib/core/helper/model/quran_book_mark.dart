class QuranBookMarkModel {
  QuranBookMarkModel({
    required this.verseNumber,
    required this.pageNumber,
    required this.nameSurah,
    required this.surahNumber,
    this.id,
  });

  QuranBookMarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    nameSurah = json['nameSurah'] as String?;
    verseNumber = json['verseNumber'] as int?;
    pageNumber = json['pageNumber'] as int?;
    surahNumber = json['surahNumber'] as int?;
  }
  int? id;
  String? nameSurah;
  int? surahNumber;
  int? verseNumber;
  int? pageNumber;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameSurah': nameSurah,
      'verseNumber': verseNumber,
      'pageNumber': pageNumber,
      'surahNumber': surahNumber,
    };
  }
}
