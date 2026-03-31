part of '../../../tafsir.dart';

// enum MufaserName {
//   ibnkatheer,
//   baghawy,
//   qurtubi,
//   saadi,
//   tabari,
// }

// enum MufaserNameV2 {
//   ibnkatheerV2,
//   baghawyV2,
//   qurtubiV2,
//   saadi,
//   tabariV2,
// }

// List<String> tafsirDBName = [
//   'ibnkatheerV3.sqlite',
//   'baghawyV3.db',
//   'qurtubiV3.db',
//   'saadiV4.db',
//   'tabariV3.db',
// ];

class TafsirTableData {
  final int id;
  final int surahNum;
  final int ayahNum;
  final String tafsirText;
  final int pageNum;

  const TafsirTableData({
    required this.id,
    required this.surahNum,
    required this.ayahNum,
    required this.tafsirText,
    required this.pageNum,
  });

  factory TafsirTableData.fromJson(Map<String, dynamic> json) {
    return TafsirTableData(
      id: json["id"] as int,
      surahNum: json["surahNum"] as int,
      ayahNum: json["ayahNum"] as int,
      tafsirText: json["tafsirText"] as String,
      pageNum: json["pageNum"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "surahNum": surahNum,
      "ayahNum": ayahNum,
      "tafsirText": tafsirText,
      "pageNum": pageNum,
    };
  }

  TafsirTableData copyWith({
    int? id,
    int? surahNum,
    int? ayahNum,
    String? tafsirText,
    int? pageNum,
  }) {
    return TafsirTableData(
      id: id ?? this.id,
      surahNum: surahNum ?? this.surahNum,
      ayahNum: ayahNum ?? this.ayahNum,
      tafsirText: tafsirText ?? this.tafsirText,
      pageNum: pageNum ?? this.pageNum,
    );
  }

  @override
  String toString() {
    return 'Tafsir(id: $id, surahNum: $surahNum, ayahNum: $ayahNum, tafsirText: $tafsirText, pageNum: $pageNum)';
  }

  @override
  int get hashCode => Object.hash(id, surahNum, ayahNum, tafsirText, pageNum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TafsirTableData &&
          other.id == id &&
          other.surahNum == surahNum &&
          other.ayahNum == ayahNum &&
          other.tafsirText == tafsirText &&
          other.pageNum == pageNum);
}
