import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class SubihRequest {
  SubihRequest({
    this.id,
    this.title,
    this.content,
    bool? isCustom,
    DateTime? createdAt,
  })  : isCustom = isCustom ?? true,
        createdAt = createdAt ?? DateTime.now();

  factory SubihRequest.fromModel(SubihModel model) {
    return SubihRequest(
      id: model.id,
      title: model.title,
      content: model.content,
      isCustom: model.isCustom,
      createdAt: model.createdAt,
    );
  }

  SubihRequest.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        content = json['content'] as String?,
        isCustom = json['is_custom'] == 1,
        createdAt = json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now();

  int? id;
  String? title;
  String? content;
  final bool isCustom;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'is_custom': isCustom ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
