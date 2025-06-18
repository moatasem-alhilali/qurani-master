class QuranReaderModel {
  QuranReaderModel({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.type,
    this.format,
    this.image,
  });

  QuranReaderModel.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'] as String?,
        language = json['language'] as String?,
        name = json['name'] as String?,
        englishName = json['englishName'] as String?,
        format = json['format'] as String?,
        type = json['type'] as String?,
        image = json['image'] as String?;

  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;
  final String? image;

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'language': language,
      'name': name,
      'englishName': englishName,
      'format': format,
      'type': type,
      'image': image,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuranReaderModel &&
        other.identifier == identifier &&
        other.language == language &&
        other.name == name &&
        other.englishName == englishName &&
        other.format == format &&
        other.type == type &&
        other.image == image;
  }

  @override
  int get hashCode {
    return Object.hash(
      identifier,
      language,
      name,
      englishName,
      format,
      type,
      image,
    );
  }

  @override
  String toString() {
    return 'QuranReaderModel(identifier: $identifier, language: $language, name: $name, englishName: $englishName, format: $format, type: $type, image: $image)';
  }
}
