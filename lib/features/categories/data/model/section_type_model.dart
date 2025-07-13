class SectionTypeModel {
  SectionTypeModel({
    required this.apiUrl,
    this.title,
    this.id,
    this.datatype,
    this.importanceLevel,
    this.slang,
  });

  factory SectionTypeModel.fromJson(Map<String, dynamic> json) {
    return SectionTypeModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      apiUrl: json['apiurl'] as String,
      datatype: json['datatype'] as String?,
      importanceLevel: json['importance_level'] as String?,
      slang: json['slang'] as String?,
    );
  }
  final int? id;
  final String? title;
  final String? importanceLevel;
  final String? slang;

  final String? datatype;
  final String apiUrl;
}
