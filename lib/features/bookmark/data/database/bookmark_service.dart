import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark.dart';

class DatabaseBookmarkService {
  final _db = DatabaseService();

  Future<int> addBookmark(Bookmarks bookmark) {
    return _db.insert(DatabaseTables.bookmark, bookmark.toJson());
  }

  Future<int> deleteBookmark(int id) {
    return _db.delete(DatabaseTables.bookmark, id);
  }

  Future<int> updateBookmark(int id, Bookmarks bookmark) {
    return _db.update(DatabaseTables.bookmark, bookmark.toJson(), id);
  }

  Future<List<Bookmarks>> getAllBookmarks() async {
    final rows = await _db.get(DatabaseTables.bookmark);
    return rows.map((e) => Bookmarks.fromJson(e)).toList();
  }
}

class DatabaseBookmarkTextService {
  final _db = DatabaseService();

  Future<int> addTextBookmark(BookmarksAyahs ayah) {
    return _db.insert(DatabaseTables.bookmarkText, ayah.toJson());
  }

  Future<int> deleteTextBookmark(int id) {
    return _db.delete(DatabaseTables.bookmarkText, id);
  }

  Future<int> updateTextBookmark(int id, BookmarksAyahs ayah) {
    return _db.update(DatabaseTables.bookmarkText, ayah.toJson(), id);
  }

  Future<List<BookmarksAyahs>> getAllTextBookmarks() async {
    final rows = await _db.get(DatabaseTables.bookmarkText);
    return rows.map((e) => BookmarksAyahs.fromJson(e)).toList();
  }
}
