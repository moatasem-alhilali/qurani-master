class AllahNameModel {
  final String name;
  final String text;

  AllahNameModel({
    required this.name,
    required this.text,
  });

  factory AllahNameModel.fromJson(Map<String, dynamic> json) {
    return AllahNameModel(
      name: json['name'] as String,
      text: json['text'] as String,
    );
  }
}
