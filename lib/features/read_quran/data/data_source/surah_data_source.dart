import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class SurahDataSource {
  SurahDataSource(this.fullQuranDataClient);
  final FullQuranDataClient fullQuranDataClient;
// get database
  Future<Database?> get db async {
    return fullQuranDataClient.database;
  }

  Future<List<NewSurahModel>> getAllSurahs() async =>
      (await (await db)!.query('surahs')).map(NewSurahModel.fromMap).toList();

  Future<NewSurahModel?> getSurahById(int surahId) async {
    final result =
        await (await db)!.query('surahs', where: 'id = ?', whereArgs: [surahId]);
    return result.isNotEmpty ? NewSurahModel.fromMap(result.first) : null;
  }

  Future<int> getSurahsCount() async {
    final res = await (await db)!.rawQuery('SELECT COUNT(*) as c FROM surahs');
    return res.isNotEmpty ? (res.first['c']! as int) : 0;
  }

  Future<List<NewSurahModel>> searchSurahsByName(String query) async =>
      (await (await db)!.query(
        'surahs',
        where: 'name_ar LIKE ? OR name_en LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      ))
          .map(NewSurahModel.fromMap)
          .toList();
}
