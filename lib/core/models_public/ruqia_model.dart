class RuqiaModel {
  RuqiaModel({
    required this.title,
    required this.zekr,
    required this.reference,
  });

  //
  RuqiaModel.fromJson(dynamic data) {
    title = data['category'] as String?;
    zekr = data['zekr'] as String?;
    reference = data['reference'] as String?;
  }
  String? title;
  String? zekr;
  String? reference;
}
