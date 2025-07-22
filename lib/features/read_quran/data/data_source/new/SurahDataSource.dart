import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class SurahDataSource {
  SurahDataSource(this.db);
  final Database db;

  Future<List<NewSurahModel>> getAllSurahs() async =>
      (await db.query('surahs')).map(NewSurahModel.fromMap).toList();

  Future<NewSurahModel?> getSurahById(int surahId) async {
    final result =
        await db.query('surahs', where: 'id = ?', whereArgs: [surahId]);
    return result.isNotEmpty ? NewSurahModel.fromMap(result.first) : null;
  }

  Future<int> getSurahsCount() async {
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM surahs');
    return res.isNotEmpty ? (res.first['c']! as int) : 0;
  }

  Future<List<NewSurahModel>> searchSurahsByName(String query) async =>
      (await db.query('surahs',
              where: 'name_ar LIKE ? OR name_en LIKE ?',
              whereArgs: ['%$query%', '%$query%']))
          .map(NewSurahModel.fromMap)
          .toList();
}
