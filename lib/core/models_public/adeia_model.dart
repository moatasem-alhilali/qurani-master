class AdeiaModel {
  AdeiaModel({required this.title, required this.zekr});

  //
  AdeiaModel.fromJson(dynamic data) {
    title = data['category'] as String?;
    zekr = data['zekr'] as String?;
  }
  String? title;
  String? zekr;
}
