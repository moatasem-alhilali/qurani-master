import 'package:sqflite/sqflite.dart';

class DBHelperQuran {
  static Database? _db;
  static const int _version = 1;
  static const String bookmark_table = 'bookmark_table';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = '${await getDatabasesPath()}quranBookMarkes';

      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          //first table
          await db.execute('''
      CREATE TABLE $bookmark_table(
        id INTEGER PRIMARY KEY,
        nameSurah TEXT NOT NULL,
        pageNumber INTEGER NOT NULL,
        verseNumber INTEGER NOT NULL ,
        surahNumber INTEGER NOT NULL 
      )
      ''');
        },
      );
    } catch (e) {
      print(e);
    }
  }

//==============================audio====================
  static Future<List<Map<String, dynamic>>> getAllBookMark() async {
    print("query function called");
    return _db!.query(bookmark_table);
  }

  static Future<int> addBookMark(QuranBookMarkModel quranBookMarkModel) async {
    print("insert");
    return await _db!.insert(bookmark_table, quranBookMarkModel.toJson());
  }
}

//model

class QuranBookMarkModel {
  int? id;
  String? nameSurah;
  int? surahNumber;
  int? verseNumber;
  int? pageNumber;

  QuranBookMarkModel({
    this.id,
    required this.verseNumber,
    required this.pageNumber,
    required this.nameSurah,
    required this.surahNumber,
  });

  QuranBookMarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameSurah = json['nameSurah'];
    verseNumber = json['verseNumber'];
    pageNumber = json['pageNumber'];
    surahNumber = json['surahNumber'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameSurah': nameSurah,
      'verseNumber': verseNumber,
      'pageNumber': pageNumber,
      'surahNumber': surahNumber,
    };
  }
}
