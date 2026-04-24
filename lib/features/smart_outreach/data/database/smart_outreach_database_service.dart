import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SmartOutreachDatabaseService {
  factory SmartOutreachDatabaseService() => _instance;

  SmartOutreachDatabaseService._internal();

  static final SmartOutreachDatabaseService _instance =
      SmartOutreachDatabaseService._internal();

  static const String databaseName = 'autodialer.db';
  static const int databaseVersion = 3;

  static const String schedulesTable = 'groups';
  static const String contactsTable = 'phone_numbers';
  static const String callLogsTable = 'call_logs';
  static const String settingsTable = 'settings';

  Database? _database;

  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<void> ensureTables() async {
    await database;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(schedulesTableSql);
    await db.execute(contactsTableSql);
    await db.execute(callLogsTableSql);
    await db.execute(settingsTableSql);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $schedulesTable '
        'ADD COLUMN repeat_cycle INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE $callLogsTable ADD COLUMN reason TEXT',
      );
    }
  }

  static const String schedulesTableSql = '''
CREATE TABLE IF NOT EXISTS groups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 1,
  schedule_time TEXT NOT NULL DEFAULT '08:00',
  schedule_days TEXT NOT NULL DEFAULT '[]',
  is_daily INTEGER NOT NULL DEFAULT 1,
  ring_timeout INTEGER NOT NULL DEFAULT 20,
  hangup_delay INTEGER NOT NULL DEFAULT 30,
  retry_enabled INTEGER NOT NULL DEFAULT 0,
  delay_between_calls INTEGER NOT NULL DEFAULT 3,
  stop_on_first_answered INTEGER NOT NULL DEFAULT 0,
  repeat_cycle INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
''';

  static const String contactsTableSql = '''
CREATE TABLE IF NOT EXISTS phone_numbers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  group_id INTEGER NOT NULL,
  number TEXT NOT NULL,
  label TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
);
''';

  static const String callLogsTableSql = '''
CREATE TABLE IF NOT EXISTS call_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  group_id INTEGER NOT NULL,
  number TEXT NOT NULL,
  status TEXT NOT NULL,
  reason TEXT,
  duration INTEGER NOT NULL DEFAULT 0,
  called_at TEXT NOT NULL
);
''';

  static const String settingsTableSql = '''
CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
''';
}
