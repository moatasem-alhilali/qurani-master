class SurahModel {
  SurahModel.fromJson(Map<String, dynamic> data) {
    place = data['place'] as String?;
    type = data['type'] as String?;
    count = data['count'] as int?;
    title = data['title'] as String?;
    titleAr = data['titleAr'] as String?;
    index = data['index'] as String?;
    pages = data['pages'] as String?;
  }
  String? place;
  String? type;
  int? count;
  String? title;
  String? titleAr;
  String? index;
  String? pages;
}
