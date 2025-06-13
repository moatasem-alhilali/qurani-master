class QuranReaderModel {
  QuranReaderModel({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.type,
    this.format,
  });

  QuranReaderModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'] as String?;
    language = json['language'] as String?;
    name = json['name'] as String?;
    englishName = json['englishName'] as String?;
    format = json['format'] as String?;
    type = json['type'] as String?;
  }
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
}
