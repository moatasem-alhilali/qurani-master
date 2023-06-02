class AdeiaModel {
  String? title;
  String? zekr;
  AdeiaModel({required this.title, required this.zekr});

  //
  AdeiaModel.fromJson(dynamic data) {
    title = data['category'];
    zekr = data['zekr'];
  }
}
