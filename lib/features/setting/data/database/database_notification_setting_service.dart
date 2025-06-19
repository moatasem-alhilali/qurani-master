import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseNotificationSettingService {
  factory DatabaseNotificationSettingService() => _instance;
  DatabaseNotificationSettingService._internal();
  static final DatabaseNotificationSettingService _instance =
      DatabaseNotificationSettingService._internal();

  final _db = DatabaseService();
  static const table = 'notification_settings';

  static const String notificationSettings = '''
CREATE TABLE $table (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT NOT NULL UNIQUE,
  value INTEGER NOT NULL DEFAULT 0,   -- enabled/disabled
  label TEXT,
  updated_at TEXT,
  schedule_type TEXT,                 -- daily/hourly/weekly/etc
  hour INTEGER,
  minute INTEGER,
  interval_minutes INTEGER,
  weekdays TEXT,                      -- json-encoded [1,5,7]
  custom_dates TEXT                   -- json-encoded ["2025-07-01T10:00:00",...]
);
''';

  /// Upsert: add or update a notification setting (with full scheduling info)
  Future<void> upsert(NotificationSettingModel setting) async {
    await _db.insert(
      table,
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get a single notification setting by key
  Future<NotificationSettingModel?> getByKey(String key) async {
    final rows = await _db.get(
      table,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      return NotificationSettingModel.fromMap(rows.first);
    }
    return null;
  }

  /// Get all notification settings (for settings page/list)
  Future<List<NotificationSettingModel>> getAll() async {
    final rows = await _db.get(table);
    return rows.map(NotificationSettingModel.fromMap).toList();
  }

  /// Update the enabled/disabled value only
  Future<void> updateValue(String key, bool value) async {
    final setting = await getByKey(key);
    if (setting != null) {
      await upsert(setting.copyWith(enabled: value));
    }
  }

  /// Update the schedule only (and keep other fields)
  Future<void> updateSchedule(
    String key,
    NotificationSettingModel updatedSchedule,
  ) async {
    final setting = await getByKey(key);
    if (setting != null) {
      // copy label, key, enabled from the existing one; schedule info from updatedSchedule
      await upsert(
        updatedSchedule.copyWith(
          id: setting.id,
          key: setting.key,
          label: setting.label,
          enabled: setting.enabled,
        ),
      );
    }
  }

  /// Get only the enabled/disabled value by key (for quick toggles)
  Future<bool> getValue(String key, {bool fallback = false}) async {
    final result = await getByKey(key);
    return result?.enabled ?? fallback;
  }

  /// Delete notification setting by key
  Future<void> deleteByKey(String key) async {
    final db = await _db.database;
    await db.delete(table, where: 'key = ?', whereArgs: [key]);
  }
}
