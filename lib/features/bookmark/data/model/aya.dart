class Aya {
  static String tableName = 'Quran';
  late int id;
  late int surahNum;
  late int ayaNum;
  dynamic pageNum;
  late String sorahName;
  late String sorahNameEn;
  late String text;
  late String SearchText;
  late String soraNameSearch;
  late int partNum;

  static final columns = [
    'ID',
    'SoraNum',
    'AyaNum',
    'PageNum',
    'SoraName_ar',
    'SoraName_En',
    'SoraNameSearch',
    'AyaDiac',
    'SearchText',
    'PartNum',
  ];

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'SoraNum': surahNum,
      'AyaNum': ayaNum,
      'PageNum': pageNum,
      'SoraName_ar': sorahName,
      'SoraName_En': sorahNameEn,
      'AyaDiac': text,
      'SearchText': SearchText,
      'SoraNameSearch': soraNameSearch,
      'PartNum': partNum,
    };

    map['ID'] = id;

    return map;
  }

  static Aya fromMap(Map<String, dynamic> map) {
    final aya = Aya();
    aya.id = map['ID'] as int;
    aya.sorahName = map['SoraName_ar'] as String;
    aya.sorahNameEn = map['SoraName_En'] as String;
    aya.ayaNum = map['AyaNum'] as int;
    aya.surahNum = map['SoraNum'] as int;
    aya.text = map['AyaDiac'] as String;
    aya.SearchText = map['SearchText'] as String;
    aya.soraNameSearch = map['SoraNameSearch'] as String;
    aya.partNum = map['PartNum'] as int;
    aya.pageNum = map['PageNum'] as int;
    return aya;
  }
}
