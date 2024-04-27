import 'package:quran_app/features/read_quran/data/model/bookmark.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark_ayahs.dart';
import 'package:quran_app/main.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const int _version = 8;
  static const String tableNote = 'noteTable';
  static const String tableBookmarks = 'bookmarkTable';
  static const String tableBookmarksText = 'bookmarkTextTable';
  static const String tableAzkar = 'azkarTable';
  static const String columnId = 'id';
  static const String columnBId = 'id';
  static const String columnCId = 'id';
  static const String columnTId = 'nomPageF';
  static const String columnPageNum = 'pageNum';

  //
  static const String _searchEngine = '''
CREATE TABLE search_engine_mosoaa (
    id INTEGER PRIMARY KEY,
    question TEXT,
    answer TEXT,
    created_at TEXT
)
''';
  static const String _sqlBookMark = '''
      CREATE TABLE offlines(
        id INTEGER PRIMARY KEY,
        path TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        description TEXT NOT NULL,
        time TEXT NOT NULL 
      )
      ''';
  static var bookmarkTextTable = 'CREATE TABLE bookmarkTextTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'sorahNum INTEGER, '
      'pageNum INTEGER, '
      'ayahNum INTEGER, '
      'nomPageF INTEGER, '
      'nomPageL INTEGER, '
      'lastRead TEXT)';
  static var bookmarkTable = 'CREATE TABLE bookmarkTable ('
      'id INTEGER PRIMARY KEY, '
      'sorahName TEXT, '
      'pageNum INTEGER, '
      'lastRead TEXT)';

  //
  static String coordinates = '''
      CREATE TABLE coordinates(
        id INTEGER PRIMARY KEY,
        latitude double NOT NULL,
        longitude double NOT NULL);
      ''';
  static String doua = '''
      CREATE TABLE doua(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL);
      ''';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path =
          '${await getDatabasesPath()}ddddddddddddddddfddddddddddddddddDddhdddfdd.db';
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(_searchEngine);
          await db.execute(_sqlBookMark);
          await db.execute(bookmarkTextTable);
          await db.execute(bookmarkTable);

          //
          await db.execute(doua);
          await db.execute(coordinates);
          logger.i('data opened And created');
        },
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  static Future<List<Map<String, dynamic>>> get(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final data = await _db!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    return data;
  }

  static Future<bool> insert(String table, Map<String, dynamic> values) async {
    try {
      final res = await _db!.insert(table, values);
      if (res == 1) return true;
      return false;
    } catch (e) {
      logger.e(e);

      return false;
    }
  }

  static Future<bool> update(
      String table, Map<String, dynamic> values, int id) async {
    try {
      final res =
          await _db!.update(table, values, where: "id = ?", whereArgs: [id]);
      if (res == 1) return true;
      return false;
    } catch (e) {
      logger.e(e);

      return false;
    }
  }

  static Future<bool> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final res = await _db!.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
    if (res == 1) return true;
    return false;
  }

//
  static Future<int> deleteBookmarkText(BookmarksAyahs? bookmarksText) async {
    print('Delete Text Bookmarks');
    return await _db!.delete(tableBookmarksText,
        where: 'id = ?', whereArgs: [bookmarksText!.id]);
  }

  static Future<int> updateBookmarksText(BookmarksAyahs bookmarksText) async {
    print('Update Text Bookmarks');
    return await _db!.update(tableBookmarksText, bookmarksText.toJson(),
        where: "$columnTId = ?", whereArgs: [bookmarksText.id]);
  }

  //bookmark page
  /// bookmarks database
  static Future<int?> addBookmark(Bookmarks? bookmarks) async {
    print('Save Bookmarks');
    try {
      return await _db!.insert(tableBookmarks, bookmarks!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteBookmark(Bookmarks? bookmarks) async {
    print('Delete Bookmarks');
    return await _db!.delete(tableBookmarks,
        where: '$columnBId = ?', whereArgs: [bookmarks!.id]);
  }
}
