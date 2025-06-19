import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';

class DatabaseNotificationSchedulesService {
  factory DatabaseNotificationSchedulesService() => _instance;
  DatabaseNotificationSchedulesService._internal();
  static final DatabaseNotificationSchedulesService _instance =
      DatabaseNotificationSchedulesService._internal();

  final _db = DatabaseService();
  static const table = 'notification_schedules';

  static const String notificationSchedules = '''
CREATE TABLE $table (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  notif_key TEXT NOT NULL,              -- مفتاح الإشعار الرئيسي (مثل isNotificationThikrMorning)
  enabled INTEGER NOT NULL DEFAULT 1,
  schedule_type TEXT,
  hour INTEGER,
  minute INTEGER,
  interval_minutes INTEGER,
  weekdays TEXT,
  custom_dates TEXT,
  label TEXT,                -- اسم اختياري للجدولة
  updated_at TEXT
);

''';
  Future<List<NotificationScheduleCustomModel>> getSchedules(
      String notifKey) async {
    final rows = await _db.get(
      table,
      where: 'notif_key = ?',
      whereArgs: [notifKey],
      orderBy: 'hour, minute',
    );
    return rows.map(NotificationScheduleCustomModel.fromMap).toList();
  }

  Future<void> upsert(NotificationScheduleCustomModel model) async {
    await _db.insert(table, model.toMap());
  }

  Future<void> delete(int id) async {
    final db = await _db.database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
