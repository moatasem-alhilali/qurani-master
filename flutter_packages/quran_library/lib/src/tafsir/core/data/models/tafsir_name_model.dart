part of '../../../tafsir.dart';

enum TafsirFileType { json }

class TafsirNameModel {
  final String name;
  final String fileName;
  final String bookName;
  final String
      databaseName; // for defaults this is filename, for custom this can be filename in app dir
  final bool isCustom;
  final bool isTranslation;
  final TafsirFileType? type;

  bool get isTafsir => !isTranslation;

  TafsirNameModel({
    required this.name,
    required this.fileName,
    required this.bookName,
    required this.databaseName,
    this.isCustom = false,
    this.isTranslation = false,
    this.type,
  });

  factory TafsirNameModel.fromJson(Map<String, dynamic> j) => TafsirNameModel(
        name: j['name'] as String,
        fileName: j['fileName'] as String,
        bookName: j['bookName'] as String,
        databaseName: j['databaseName'] as String,
        isCustom: j['isCustom'] == true,
        type: j['type'] == null ? null : TafsirFileType.json,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'fileName': fileName,
        'bookName': bookName,
        'databaseName': databaseName,
        'isCustom': isCustom,
        'type': type == null ? null : 'json',
      };
}
