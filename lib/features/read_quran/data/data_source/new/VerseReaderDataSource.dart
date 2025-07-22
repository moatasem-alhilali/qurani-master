import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class VerseReaderDataSource {
  VerseReaderDataSource(this.db);
  final Database db;

  Future<List<VerseReaderModel>> getAll() async {
    final res = await db.query(VerseReaderModel.tableName);
    return res.map(VerseReaderModel.fromMap).toList();
  }

  Future<VerseReaderModel?> getByIdentifier(String identifier) async {
    final res = await db.query(
      VerseReaderModel.tableName,
      where: 'identifier = ?',
      whereArgs: [identifier],
      limit: 1,
    );
    return res.isNotEmpty ? VerseReaderModel.fromMap(res.first) : null;
  }

  Future<List<VerseReaderModel>> searchByName(String query) async {
    final res = await db.query(
      VerseReaderModel.tableName,
      where: 'name LIKE ? OR english_name LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return res.map(VerseReaderModel.fromMap).toList();
  }
}
