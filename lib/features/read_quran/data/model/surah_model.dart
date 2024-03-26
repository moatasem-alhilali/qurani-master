class SurahModel {
  String? place;
  String? type;
  int? count;
  String? title;
  String? titleAr;
  String? index;
  String? pages;
  SurahModel.fromJson(Map data) {
    place = data['place'];
    type = data['type'];
    count = data['count'];
    title = data['title'];
    titleAr = data['titleAr'];
    index = data['index'];
    pages = data['pages'];
  }
}
