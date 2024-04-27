class DoaModel {
  int? id;
  String? title;
  String? content;
  DoaModel({this.content, this.id, this.title});
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
      };
  DoaModel.fromJson(dynamic data) {
    id = data['id'];
    title = data['title'];
    content = data['content'];
  }
}
