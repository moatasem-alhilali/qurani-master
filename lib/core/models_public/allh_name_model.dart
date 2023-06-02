class AllahNameModel {
  String? title;
  String? text;
  AllahNameModel({
    required this.title,
    required this.text,
  });

  //
  AllahNameModel.fromJson(dynamic data) {
    title = data['name'];
    text = data['text'];
  }
}
