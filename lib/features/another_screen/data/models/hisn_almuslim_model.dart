class HisnMuslimModel {
  HisnMuslimModel({
    required this.title,
    required this.text,
    required this.footnote,
  });

  factory HisnMuslimModel.fromJson(String title, Map<String, dynamic> json) {
    return HisnMuslimModel(
      title: title,
      text: List<String>.from(json['text'] as Iterable<dynamic>),
      footnote: List<String>.from(json['footnote'] as Iterable<dynamic>),
    );
  }
  final String title;
  final List<String> text;
  final List<String> footnote;
}
