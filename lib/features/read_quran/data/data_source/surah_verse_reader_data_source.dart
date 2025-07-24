import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class SurahVerseReaderDataSource {
  SurahVerseReaderDataSource(this.fullQuranDataClient);
  final FullQuranDataClient fullQuranDataClient;

  // get database
  Future<Database?> get db async {
    return fullQuranDataClient.database;
  }

  Future<List<SurahVerseReaderModel>> getAll() async {
    final res = await (await db)!.query(SurahVerseReaderModel.tableName);
    return res.map(SurahVerseReaderModel.fromMap).toList();
  }

  Future<SurahVerseReaderModel?> getByIdentifier(String identifier) async {
    final res = await (await db)!.query(
      SurahVerseReaderModel.tableName,
      where: 'identifier = ?',
      whereArgs: [identifier],
      limit: 1,
    );
    return res.isNotEmpty ? SurahVerseReaderModel.fromMap(res.first) : null;
  }

  Future<List<SurahVerseReaderModel>> searchByName(String query) async {
    final res = await (await db)!.query(
      SurahVerseReaderModel.tableName,
      where: 'name LIKE ? OR english_name LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return res.map(SurahVerseReaderModel.fromMap).toList();
  }
}
