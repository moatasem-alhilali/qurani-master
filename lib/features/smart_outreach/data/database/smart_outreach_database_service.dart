import 'package:quran_app/core/local_database/database_service.dart';

class SmartOutreachDatabaseService {
  factory SmartOutreachDatabaseService() => _instance;

  SmartOutreachDatabaseService._internal();

  static final SmartOutreachDatabaseService _instance =
      SmartOutreachDatabaseService._internal();

  final DatabaseService _db = DatabaseService();

  static const String schedulesTable = 'smart_outreach_schedules';
  static const String contactsTable = 'smart_outreach_contacts';
  static const String sessionsTable = 'smart_outreach_sessions';
  static const String contactResultsTable = 'smart_outreach_contact_results';

  static const String schedulesTableSql = '''
CREATE TABLE IF NOT EXISTS $schedulesTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  note TEXT,
  daily_hour INTEGER NOT NULL,
  daily_minute INTEGER NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 0,
  sms_template TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
''';

  static const String contactsTableSql = '''
CREATE TABLE IF NOT EXISTS $contactsTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  schedule_id INTEGER NOT NULL,
  name TEXT,
  phone TEXT NOT NULL,
  contact_order INTEGER NOT NULL,
  action_type TEXT NOT NULL,
  sms_template TEXT,
  UNIQUE(schedule_id, contact_order)
);
''';

  static const String sessionsTableSql = '''
CREATE TABLE IF NOT EXISTS $sessionsTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  schedule_id INTEGER NOT NULL,
  current_index INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  started_at TEXT NOT NULL,
  completed_at TEXT,
  trigger_source TEXT NOT NULL,
  session_date TEXT NOT NULL
);
''';

  static const String contactResultsTableSql = '''
CREATE TABLE IF NOT EXISTS $contactResultsTable (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  contact_id INTEGER NOT NULL,
  result_type TEXT NOT NULL,
  timestamp TEXT NOT NULL
);
''';

  Future<void> ensureTables() async {
    final db = await _db.database;
    await db.execute(schedulesTableSql);
    await db.execute(contactsTableSql);
    await db.execute(sessionsTableSql);
    await db.execute(contactResultsTableSql);
  }
}
