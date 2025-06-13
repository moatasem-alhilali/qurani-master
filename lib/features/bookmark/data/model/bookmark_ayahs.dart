class BookmarksAyahs {
  BookmarksAyahs(
    this.id,
    this.surahName,
    this.surahNumber,
    this.pageNumber,
    this.ayahNumber,
    this.ayahUQNumber,
    this.lastRead,
  );

  BookmarksAyahs.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    surahName = json['sorahName'] as String?;
    surahNumber = json['sorahNum'] as int?;
    pageNumber = json['pageNum'] as int?;
    ayahNumber = json['ayahNum'] as int?;
    ayahUQNumber = json['nomPageF'] as int?;
    lastRead = json['lastRead'] as String?;
  }
  int? id;
  String? surahName;
  int? surahNumber;
  int? pageNumber;
  int? ayahNumber;
  int? ayahUQNumber;
  String? lastRead;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': surahName,
      'sorahNum': surahNumber,
      'pageNum': pageNumber,
      'ayahNum': ayahNumber,
      'nomPageF': ayahUQNumber,
      'lastRead': lastRead,
    };
  }
}
