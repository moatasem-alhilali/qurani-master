import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_customization_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_settings_model.dart';
import 'package:sqflite/sqflite.dart';

class DailyWirdDatabaseService {
  DailyWirdDatabaseService();

  final DatabaseService _db = DatabaseService();

  static const String settingsTable = 'daily_wird_settings';
  static const String customizationsTable = 'daily_wird_customizations';
  static const String programsTable = 'daily_wird_programs';
  static const String programItemsTable = 'daily_wird_program_items';

  static const String settingsTableSql = '''
CREATE TABLE IF NOT EXISTS $settingsTable (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  selected_preset_id TEXT,
  onboarding_completed INTEGER NOT NULL DEFAULT 0,
  morning_reminder_enabled INTEGER NOT NULL DEFAULT 1,
  morning_reminder_time TEXT NOT NULL DEFAULT '07:00',
  evening_reminder_enabled INTEGER NOT NULL DEFAULT 1,
  evening_reminder_time TEXT NOT NULL DEFAULT '17:30',
  night_reminder_enabled INTEGER NOT NULL DEFAULT 1,
  night_reminder_time TEXT NOT NULL DEFAULT '21:00',
  end_of_day_summary_enabled INTEGER NOT NULL DEFAULT 1,
  end_of_day_summary_time TEXT NOT NULL DEFAULT '22:30',
  updated_at TEXT NOT NULL
);
''';

  static const String customizationsTableSql = '''
CREATE TABLE IF NOT EXISTS $customizationsTable (
  item_id TEXT PRIMARY KEY,
  is_hidden INTEGER NOT NULL DEFAULT 0,
  custom_count_required INTEGER,
  order_index INTEGER,
  updated_at TEXT NOT NULL
);
''';

  static const String programsTableSql = '''
CREATE TABLE IF NOT EXISTS $programsTable (
  date TEXT PRIMARY KEY,
  preset_id TEXT NOT NULL,
  completion_percentage REAL NOT NULL DEFAULT 0,
  is_completed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
''';

  static const String programItemsTableSql = '''
CREATE TABLE IF NOT EXISTS $programItemsTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  program_date TEXT NOT NULL,
  item_id TEXT NOT NULL,
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  content_text TEXT NOT NULL,
  count_required INTEGER,
  count_completed INTEGER NOT NULL DEFAULT 0,
  has_counter INTEGER NOT NULL DEFAULT 0,
  has_audio INTEGER NOT NULL DEFAULT 0,
  audio_url TEXT,
  time_category TEXT NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
  order_index INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  content_entries_json TEXT,
  fadhl TEXT,
  source TEXT,
  count_unit TEXT,
  UNIQUE(program_date, item_id)
);
''';

  Future<DailyWirdSettings?> getSettings() async {
    final rows = await _db.get(settingsTable, limit: 1);
    if (rows.isEmpty) {
      return null;
    }
    return DailyWirdSettings.fromMap(rows.first);
  }

  Future<void> upsertSettings(DailyWirdSettings settings) async {
    final db = await _db.database;
    await db.insert(
      settingsTable,
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DailyWirdCustomization>> getCustomizations() async {
    final rows = await _db.get(customizationsTable);
    return rows.map(DailyWirdCustomization.fromMap).toList();
  }

  Future<void> upsertCustomization(DailyWirdCustomization customization) async {
    final db = await _db.database;
    await db.insert(
      customizationsTable,
      customization.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveProgram(DailyWirdProgram program) async {
    final db = await _db.database;
    final dateKey = _dateKey(program.date);

    await db.transaction((txn) async {
      await txn.insert(
        programsTable,
        {
          'date': dateKey,
          'preset_id': program.presetId,
          'completion_percentage': program.completionPercentage,
          'is_completed': program.isCompleted ? 1 : 0,
          'created_at': program.createdAt.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        programItemsTable,
        where: 'program_date = ?',
        whereArgs: [dateKey],
      );

      for (final item in program.items) {
        await txn.insert(
          programItemsTable,
          item.toMap(dateKey),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<DailyWirdProgram?> getProgram(DateTime date) async {
    final dateKey = _dateKey(date);
    final rows = await _db.get(
      programsTable,
      where: 'date = ?',
      whereArgs: [dateKey],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    final itemRows = await _db.get(
      programItemsTable,
      where: 'program_date = ?',
      whereArgs: [dateKey],
      orderBy: 'order_index ASC, id ASC',
    );

    final row = rows.first;
    return DailyWirdProgram(
      date: DateTime.tryParse('${row['date']}T00:00:00') ?? date,
      items: itemRows.map(DailyWirdItem.fromMap).toList(),
      completionPercentage:
          (row['completion_percentage'] as num?)?.toDouble() ?? 0,
      presetId: row['preset_id'] as String? ?? '',
      createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Future<List<DailyWirdProgram>> getProgramsBetween({
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await _db.get(
      programsTable,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [_dateKey(start), _dateKey(end)],
      orderBy: 'date DESC',
    );

    final programs = <DailyWirdProgram>[];
    for (final row in rows) {
      final dateKey = row['date'] as String? ?? '';
      final itemRows = await _db.get(
        programItemsTable,
        where: 'program_date = ?',
        whereArgs: [dateKey],
        orderBy: 'order_index ASC, id ASC',
      );
      programs.add(
        DailyWirdProgram(
          date: DateTime.tryParse('${row['date']}T00:00:00') ?? start,
          items: itemRows.map(DailyWirdItem.fromMap).toList(),
          completionPercentage:
              (row['completion_percentage'] as num?)?.toDouble() ?? 0,
          presetId: row['preset_id'] as String? ?? '',
          createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
              DateTime.now(),
        ),
      );
    }
    return programs;
  }

  Future<void> deleteProgram(DateTime date) async {
    final dateKey = _dateKey(date);
    final db = await _db.database;
    await db.transaction((txn) async {
      await txn.delete(
        programItemsTable,
        where: 'program_date = ?',
        whereArgs: [dateKey],
      );
      await txn.delete(
        programsTable,
        where: 'date = ?',
        whereArgs: [dateKey],
      );
    });
  }

  static String _dateKey(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }
}
