class QuranReaderModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;

  QuranReaderModel({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.type,
    this.format,
  });

  QuranReaderModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    language = json['language'];
    name = json['name'];
    englishName = json['englishName'];
    format = json['format'];
    type = json['type'];
  }
}
