class BookmarkPageRequest {
  BookmarkPageRequest({
    this.id,
    this.sorahName,
    this.pageNum,
    this.lastRead,
  });

  final int? id;
  final String? sorahName;
  final int? pageNum;
  final String? lastRead;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'sorahName': sorahName,
        'pageNum': pageNum,
        'lastRead': lastRead,
      };
}
