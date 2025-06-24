import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayah.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_page_model.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_ayah_request.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_page_request.dart';

class DatabaseBookmarkPageService {
  final _db = DatabaseService();

  Future<int> addBookmarkPage(BookmarkPageRequest bookmark) {
    return _db.insert(DatabaseTables.bookmark, bookmark.toJson());
  }

  Future<int> deleteBookmarkPage(BookmarkPageRequest request) {
    return _db.delete(DatabaseTables.bookmark, request.id!);
  }

  Future<int> updateBookmarkPage(int id, BookmarkPageRequest bookmark) {
    return _db.updateById(DatabaseTables.bookmark, bookmark.toJson(), id);
  }

  Future<List<BookmarkPageModel>> getAllBookmarksPage() async {
    final rows = await _db.get(DatabaseTables.bookmark);
    return rows.map(BookmarkPageModel.fromJson).toList();
  }
}

class DatabaseBookmarkAyahService {
  final _db = DatabaseService();
  Future<List<BookmarkAyahModel>> getAllAyahBookmarks() async {
    final rows = await _db.get(DatabaseTables.bookmarkText);
    return rows.map(BookmarkAyahModel.fromJson).toList();
  }

  Future<int> addAyahBookmark(BookmarkAyahRequest ayah) {
    return _db.insert(DatabaseTables.bookmarkText, ayah.toJson());
  }

  Future<int> deleteAyahBookmark(
    BookmarkAyahRequest request,
  ) {
    return _db.delete(DatabaseTables.bookmarkText, request.id!);
  }

  Future<int> updateAyahBookmark(
    BookmarkAyahRequest request,
  ) {
    return _db.updateById(
      DatabaseTables.bookmarkText,
      request.toJson(),
      request.id!,
    );
  }
}
