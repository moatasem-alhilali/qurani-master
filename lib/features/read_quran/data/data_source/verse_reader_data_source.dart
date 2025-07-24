import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class VerseReaderDataSource {
  VerseReaderDataSource(this.fullQuranDataClient);
  final FullQuranDataClient fullQuranDataClient;

  // get database
  Future<Database?> get db async {
    return fullQuranDataClient.database;
  }

  Future<List<VerseReaderModel>> getAll() async {
    final res = await (await db)!.query(VerseReaderModel.tableName);
    return res.map(VerseReaderModel.fromMap).toList();
  }

  Future<VerseReaderModel?> getByIdentifier(String identifier) async {
    final res = await (await db)!.query(
      VerseReaderModel.tableName,
      where: 'identifier = ?',
      whereArgs: [identifier],
      limit: 1,
    );
    return res.isNotEmpty ? VerseReaderModel.fromMap(res.first) : null;
  }

  Future<List<VerseReaderModel>> searchByName(String query) async {
    final res = await (await db)!.query(
      VerseReaderModel.tableName,
      where: 'name LIKE ? OR english_name LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return res.map(VerseReaderModel.fromMap).toList();
  }
}
