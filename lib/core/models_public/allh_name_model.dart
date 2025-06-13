class AllahNameModel {
  AllahNameModel({
    required this.title,
    required this.text,
  });

  //
  AllahNameModel.fromJson(dynamic data) {
    title = data['name'] as String?;
    text = data['text'] as String?;
  }
  String? title;
  String? text;
}
