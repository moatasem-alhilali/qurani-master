class HisnMuslimModel {
  final String title;
  final List<String> text;
  final List<String> footnote;

  HisnMuslimModel({
    required this.title,
    required this.text,
    required this.footnote,
  });

  factory HisnMuslimModel.fromJson(String title, Map<String, dynamic> json) {
    return HisnMuslimModel(
      title: title,
      text: List<String>.from(json['text']),
      footnote: List<String>.from(json['footnote']),
    );
  }
}
