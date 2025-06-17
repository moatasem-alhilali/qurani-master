import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';

class DatabaseSabihService {
  static final _db = DatabaseService();

  static const String subih = 'subihTable';
  static const String subihLogs = 'subihLogsTable';
  static const String subihSummary = 'subihSummaryTable';

  // ───────────── إنشاء الجداول ─────────────
  static String subihTable = '''
 CREATE TABLE $subih (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_custom INTEGER DEFAULT 0,
  created_at TEXT NOT NULL
);
''';

  static String subihLogsTable = '''
CREATE TABLE $subihLogs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subih_id INTEGER NOT NULL,
  timestamp TEXT NOT NULL
);
''';

  static String subihSummaryTable = '''
CREATE TABLE $subihSummary (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subih_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0
);
''';

  // ───────────── CRUD للأذكار ─────────────

  static Future<int> addSubihItem(SubihRequest request) {
    return _db.insert(subih, request.toJson());
  }

  static Future<int> deleteSubihItem(SubihRequest request) {
    return _db.delete(subih, request.id!);
  }

  static Future<int> updateSubihItem(int id, SubihRequest request) {
    return _db.update(subih, request.toJson(), id);
  }

  static Future<List<SubihModel>> getAllSubihItems() async {
    final rows = await _db.get(subih);
    return rows.map(SubihModel.fromJson).toList();
  }

  // ───────────── تسجيل التسبيحات ─────────────

  static Future<int> logSubihTap(int subihId) {
    return _db.insert(subihLogs, {
      'subih_id': subihId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<SubihLogModel>> getAllLogs() async {
    final rows = await _db.get(subihLogs);
    return rows.map(SubihLogModel.fromJson).toList();
  }

  static Future<int> getCountBySubih({
    required int subihId,
    required DateTime from,
    required DateTime to,
  }) async {
    final result = await _db.rawQuery(
      '''
      SELECT COUNT(*) as total FROM $subihLogs
      WHERE subih_id = ? AND timestamp BETWEEN ? AND ?
      ''',
      [subihId, from.toIso8601String(), to.toIso8601String()],
    );
    return (result.isNotEmpty ? result.first['total'] as int? : 0) ?? 0;
  }

  static Future<Map<int, int>> getCountsGrouped({
    required DateTime from,
    required DateTime to,
  }) async {
    final result = await _db.rawQuery(
      '''
      SELECT subih_id, COUNT(*) as total FROM $subihLogs
      WHERE timestamp BETWEEN ? AND ?
      GROUP BY subih_id
      ''',
      [from.toIso8601String(), to.toIso8601String()],
    );
    return {
      for (final row in result) row['subih_id']! as int: row['total']! as int,
    };
  }

  // ───────────── ملخصات التسبيح اليومية ─────────────

  static Future<void> upsertSummary(int subihId, DateTime date) async {
    final dateStr = DateTime(date.year, date.month, date.day).toIso8601String();
    final existing = await _db.rawQuery(
      '''
      SELECT id, count FROM $subihSummary
      WHERE subih_id = ? AND date = ?
      ''',
      [subihId, dateStr],
    );
    if (existing.isNotEmpty) {
      final id = existing.first['id']! as int;
      final count = existing.first['count']! as int;
      await _db.update(subihSummary, {'count': count + 1}, id);
    } else {
      await _db.insert(subihSummary, {
        'subih_id': subihId,
        'date': dateStr,
        'count': 1,
      });
    }
  }

  static Future<Map<int, int>> getSummaryCounts({
    required DateTime from,
    required DateTime to,
  }) async {
    final result = await _db.rawQuery(
      '''
      SELECT subih_id, SUM(count) as total FROM $subihSummary
      WHERE date BETWEEN ? AND ?
      GROUP BY subih_id
      ''',
      [
        DateTime(from.year, from.month, from.day).toIso8601String(),
        DateTime(to.year, to.month, to.day).toIso8601String(),
      ],
    );
    return {
      for (final row in result)
        row['subih_id']! as int: (row['total'] as int?) ?? 0,
    };
  }

  // ───────────── دالة موحدة للتسجيل + ملخص ─────────────

  static Future<void> performSubihTap(int subihId) async {
    await logSubihTap(subihId);
    await upsertSummary(subihId, DateTime.now());
  }
}
