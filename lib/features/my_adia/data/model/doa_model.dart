class DoaModel {
  DoaModel({this.content, this.id, this.title});
  DoaModel.fromJson(dynamic data) {
    id = data['id'] as int?;
    title = data['title'] as String?;
    content = data['content'] as String?;
  }
  int? id;
  String? title;
  String? content;
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
      };
}
