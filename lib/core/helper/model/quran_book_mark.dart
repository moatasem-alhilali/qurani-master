
class QuranBookMarkModel {
  int? id;
  String? nameSurah;
  int? surahNumber;
  int? verseNumber;
  int? pageNumber;

  QuranBookMarkModel({
    this.id,
    required this.verseNumber,
    required this.pageNumber,
    required this.nameSurah,
    required this.surahNumber,
  });

  QuranBookMarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameSurah = json['nameSurah'];
    verseNumber = json['verseNumber'];
    pageNumber = json['pageNumber'];
    surahNumber = json['surahNumber'];
  }

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
