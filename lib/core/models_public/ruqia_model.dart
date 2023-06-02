class RuqiaModel {
  String? title;
  String? zekr;
  String? reference;
  RuqiaModel(
      {required this.title, required this.zekr, required this.reference});

  //
  RuqiaModel.fromJson(dynamic data) {
    title = data['category'];
    zekr = data['zekr'];
    reference = data['reference'];
  }
}
