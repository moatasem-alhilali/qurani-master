class Bookmarks {
  Bookmarks({this.id, this.sorahName, this.pageNum, this.lastRead});

  Bookmarks.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    sorahName = json['sorahName'] as String?;
    pageNum = json['pageNum'] as int?;
    lastRead = json['lastRead'] as String?;
  }
  int? id;
  String? sorahName;
  int? pageNum;
  String? lastRead;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sorahName': sorahName,
      'pageNum': pageNum,
      'lastRead': lastRead,
    };
  }
}
