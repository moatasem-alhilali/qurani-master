import 'package:path/path.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/main.dart';
import 'package:sqflite/sqflite.dart';

/// Centralized table name definitions to be reused across all services and models.
class DatabaseTables {
  static const String bookmark = 'bookmarkTable';
  static const String bookmarkText = 'bookmarkTextTable';
  static const String azkar = 'azkarTable';
  static const String searchEngine = 'search_engine_mosoaa';
  static const String offlines = 'offlines';
  static const String coordinates = 'coordinates';
  static const String doua = 'doua';
}

/// A singleton service to manage the local SQLite database.
///
/// This class handles initialization and provides reusable CRUD methods.
/// Use this in feature-specific services like BookmarkService.
class DatabaseService {
  /// Factory constructor for singleton access
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();

  /// Internal database reference
  static Database? _db;

  /// Database file name
  static const _dbName = 'quran_app.db';

  /// Database version (used for future upgrades)
  static const _dbVersion = 1;

  /// Accessor that returns the database instance
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// Initializes the database and creates tables if not yet created.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  /// Called when database is created for the first time.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_searchEngine);
    await db.execute(_sqlBookMark);
    await db.execute(_bookmarkTextTable);
    await db.execute(_bookmarkTable);
    await db.execute(_coordinates);
    await db.execute(_doua);
    await db.execute(_notificationSettings);
    await db.execute(DatabaseSabihService.subihTable);
    await db.execute(DatabaseSabihService.subihLogsTable);
    await db.execute(DatabaseSabihService.subihSummaryTable);

    logger.i('✅ Database initialized and tables created.');
  }

  // ──────────────────────────────────────────────────────────────────────────────
  // 🗂 SQL Table Definitions
  // ──────────────────────────────────────────────────────────────────────────────

  static const String _searchEngine = '''
    CREATE TABLE ${DatabaseTables.searchEngine} (
      id INTEGER PRIMARY KEY,
      question TEXT,
      answer TEXT,
      created_at TEXT
    );
  ''';

  static const String _sqlBookMark = '''
    CREATE TABLE ${DatabaseTables.offlines} (
      id INTEGER PRIMARY KEY,
      path TEXT NOT NULL,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      url TEXT NOT NULL,
      description TEXT NOT NULL,
      time TEXT NOT NULL
    );
  ''';

  static const String _bookmarkTextTable = '''
    CREATE TABLE ${DatabaseTables.bookmarkText} (
      id INTEGER PRIMARY KEY,
      sorahName TEXT,
      sorahNum INTEGER,
      pageNum INTEGER,
      ayahNum INTEGER,
      nomPageF INTEGER,
      nomPageL INTEGER,
      lastRead TEXT
    );
  ''';

  static const String _bookmarkTable = '''
    CREATE TABLE ${DatabaseTables.bookmark} (
      id INTEGER PRIMARY KEY,
      sorahName TEXT,
      pageNum INTEGER,
      lastRead TEXT
    );
  ''';

  static const String _coordinates = '''
    CREATE TABLE ${DatabaseTables.coordinates} (
      id INTEGER PRIMARY KEY,
      latitude DOUBLE NOT NULL,
      longitude DOUBLE NOT NULL
    );
  ''';

  static const String _doua = '''
    CREATE TABLE ${DatabaseTables.doua} (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL
    );
  ''';
  static const String _notificationSettings = '''
  CREATE TABLE notification_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT NOT NULL UNIQUE,
    value INTEGER NOT NULL DEFAULT 0,
    label TEXT,
    updated_at TEXT,
    time TEXT
  );
''';

  // ──────────────────────────────────────────────────────────────────────────────
  // 🔁 Generic CRUD Methods
  // ──────────────────────────────────────────────────────────────────────────────

  /// Fetches records from the given [table].
  ///
  /// Optional: [columns], [where], [whereArgs] to filter results.
  ///
  /// Example:
  /// ```dart
  /// final rows = await dbService.get('bookmarkTable');
  /// final filtered = await dbService.get('bookmarkTable', where: 'pageNum = ?', whereArgs: [5]);
  /// ```
  Future<List<Map<String, dynamic>>> get(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    bool? distinct,
    String? groupBy,
    String? having,
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      distinct: distinct,
      groupBy: groupBy,
      having: having,
    );
  }

  /// Inserts a record into the specified [table] using [values].
  ///
  /// Returns the inserted row ID.
  ///
  /// Example:
  /// ```dart
  /// await dbService.insert('bookmarkTable', {
  ///   'sorahName': 'Al-Baqara',
  ///   'pageNum': 5,
  ///   'lastRead': DateTime.now().toString(),
  /// });
  /// ```
  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    final db = await database;
    return await db.insert(
      table,
      values,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Updates a record by its [id] in the given [table].
  ///
  /// Returns number of affected rows.
  ///
  /// Example:
  /// ```dart
  /// await dbService.update('bookmarkTable', {
  ///   'pageNum': 6,
  ///   'lastRead': DateTime.now().toString(),
  /// }, 1);
  /// ```
  Future<int> update(
    String table,
    Map<String, dynamic> values,
    int id, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async {
    final db = await database;
    return await db.update(
      table,
      values,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Deletes a record by its [id] from the given [table].
  ///
  /// Returns number of affected rows.
  ///
  /// Example:
  /// ```dart
  /// await dbService.delete('bookmarkTable', 1);
  /// ```
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> rawQuery(
    String sql,
    List<Object?>? arguments,
  ) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }
}
