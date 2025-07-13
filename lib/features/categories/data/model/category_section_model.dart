class CategorySectionModel {
  CategorySectionModel({
    required this.apiUrl,
    this.title,
    this.type,
    this.itemsCount,
    this.id,
    this.dataType,
  });

  factory CategorySectionModel.fromJson(Map<String, dynamic> json) {
    return CategorySectionModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      itemsCount: json['items_count'] as int?,
      apiUrl: json['api_url'] as String,
      dataType: json['datatype'] as String?,
    );
  }
  final int? id;
  final String? title;

  final String? type;
  final String? dataType;
  final int? itemsCount;
  final String apiUrl;
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'type': type,
      'items_count': itemsCount,
      'api_url': apiUrl,
      'datatype': dataType,
    };
  }
}
