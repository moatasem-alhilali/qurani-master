class SubihModel {
  int? id;
  String? count;
  String? text;
  String? date;

  SubihModel({
    this.id,
    this.count,
    this.text,
    this.date,
  });

  SubihModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    count = json['count'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'count': count,
      'text': text,
    };
  }
}
