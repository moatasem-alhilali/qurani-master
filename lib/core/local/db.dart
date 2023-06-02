import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/offline_audio/model/quran_audio_offline.dart';
import 'package:quran_app/features/sabih/model/subih_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperAudio {
  static Database? _db;
  static const int _version = 1;
  static const String quran_table = 'quran_audios';
  static const String bookmark_table = 'bookmark_table';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = '${await getDatabasesPath()}qurans';

      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          //first table
          await db.execute('''
      CREATE TABLE $quran_table(
        id INTEGER PRIMARY KEY,
        nameSurah TEXT NOT NULL,
        nameReader TEXT NOT NULL,
        audio_path TEXT NOT NULL UNIQUE,
        count_verse TEXT NOT NULL,
        image TEXT NOT NULL
      )
      ''');
        },
      );
    } catch (e) {
      print(e);
    }
  }

//==============================audio====================
  static Future<List<Map<String, dynamic>>> getAllAudio() async {
    print("query function called");
    return _db!.query(quran_table);
  }

  static Future<int> addAudio(QuranAudioModel quranAudio) async {
    print("insert");
    return await _db!.insert(quran_table, quranAudio.toJson());
  }

  //==============================tusbih====================

  static Future<List<Map<String, dynamic>>> getAllTusbih() async {
    print("query function called");
    final dataList = await _db!.query(bookmark_table);
    dataList.forEach((element) {
      //
      tusbihData.add(SubihModel.fromJson(element));
    });
    return _db!.query(bookmark_table);
  }

  static Future<int> addTasbih(SubihModel subihModel) async {
    print("insert");
    return await _db!.insert(bookmark_table, subihModel.toJson());
  }
}
