class SubihModel {
  SubihModel({
    this.id,
    this.count,
    this.text,
    this.date,
  });

  SubihModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    date = json['date'] as String?;
    count = json['count'] as String?;
    text = json['text'] as String?;
  }
  int? id;
  String? count;
  String? text;
  String? date;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'count': count,
      'text': text,
    };
  }
}
