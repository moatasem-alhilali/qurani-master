
import 'package:quran_app/core/local_database/database_service.dart';

class SearchEngineService {
  final _db = DatabaseService();

  Future<int> addEntry({
    required String question,
    required String answer,
  }) async {
    return await _db.insert(DatabaseTables.searchEngine, {
      "question": question,
      "answer": answer,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllEntries() async {
    return await _db.get(DatabaseTables.searchEngine);
  }

  Future<int> clearAll() async {
    final all = await getAllEntries();
    int deleted = 0;
    for (final row in all) {
      deleted += await _db.delete(DatabaseTables.searchEngine, row['id']);
    }
    return deleted;
  }
}
