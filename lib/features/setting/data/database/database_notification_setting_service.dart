import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseNotificationSettingService {
  final _db = DatabaseService();
  static const table = 'notification_settings';

  Future<void> upsert(NotificationSettingModel setting) async {
    await _db.insert(table, setting.toMap());
  }

  Future<NotificationSettingModel?> getByKey(String key) async {
    final rows = await _db.get(
      table,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      return NotificationSettingModel.fromJson(rows.first);
    }
    return null;
  }

  Future<List<NotificationSettingModel>> getAll() async {
    final rows = await _db.get(table);
    return rows.map((e) => NotificationSettingModel.fromJson(e)).toList();
  }

  Future<void> updateValue(String key, bool value) async {
    await _db.insert(
      table,
      {
        'key': key,
        'value': value ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> getValue(String key, {bool fallback = false}) async {
    final result = await getByKey(key);
    return result?.value ?? fallback;
  }

  Future<void> deleteByKey(String key) async {
    final rows = await _db.database;
    await rows.delete(table, where: 'key = ?', whereArgs: [key]);
  }
}
