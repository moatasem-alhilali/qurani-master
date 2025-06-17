class BookmarkAyahRequest {
  BookmarkAyahRequest({
    this.id,
    this.surahName,
    this.surahNumber,
    this.pageNumber,
    this.ayahNumber,
    this.ayahUQNumber,
    this.lastRead,
  });

  final int? id;
  final String? surahName;
  final int? surahNumber;
  final int? pageNumber;
  final int? ayahNumber;
  final int? ayahUQNumber;
  final String? lastRead;

  Map<String, dynamic> toJson() => {
        'id': id,
        'sorahName': surahName,
        'sorahNum': surahNumber,
        'pageNum': pageNumber,
        'ayahNum': ayahNumber,
        'nomPageF': ayahUQNumber,
        'lastRead': lastRead,
      };
}
