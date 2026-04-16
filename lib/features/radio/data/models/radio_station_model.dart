import 'dart:convert';

class RadioStationModel {
  const RadioStationModel({
    required this.id,
    required this.name,
    required this.streamUrl,
    required this.imageUrl,
  });

  factory RadioStationModel.fromMap(Map<String, dynamic> map) {
    return RadioStationModel(
      id: (map['id'] as num).toInt(),
      name: (map['name'] as String?)?.trim() ?? '',
      streamUrl: (map['url'] as String?)?.trim() ?? '',
      imageUrl: (map['img'] as String?)?.trim() ?? '',
    );
  }

  factory RadioStationModel.fromJson(String source) =>
      RadioStationModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final int id;
  final String name;
  final String streamUrl;
  final String imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': streamUrl,
      'img': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());
}
