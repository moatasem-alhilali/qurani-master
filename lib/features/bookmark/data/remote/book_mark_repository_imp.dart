// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/bookmark/data/database/bookmark_service.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayah.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_page_model.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_ayah_request.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_page_request.dart';
import 'package:quran_app/main.dart';

abstract class BookmarkRepository {
  // ─────────────────────── AYAH BOOKMARKS ───────────────────────

  Future<Either<LogicFailure, List<BookmarkAyahModel>>> getBookmarksAyah();

  Future<Either<LogicFailure, void>> addBookmarkAyah(
    BookmarkAyahRequest bookmarksAyah,
  );

  Future<Either<LogicFailure, void>> deleteBookmarkAyah(
    BookmarkAyahRequest bookmarksAyah,
  );

  // ─────────────────────── PAGE BOOKMARKS ───────────────────────

  Future<Either<LogicFailure, List<BookmarkPageModel>>> getBookmarksPage();

  Future<Either<LogicFailure, void>> addBookmarkPage(
    BookmarkPageRequest bookmarksPage,
  );

  Future<Either<LogicFailure, void>> deleteBookmarkPage(
    BookmarkPageRequest bookmarksPage,
  );

  //
}

class BookmarkRepositoryImpl implements BookmarkRepository {
  final DatabaseBookmarkAyahService bookmarkAyahService;
  final DatabaseBookmarkPageService bookmarkService;
  BookmarkRepositoryImpl({
    required this.bookmarkAyahService,
    required this.bookmarkService,
  });

  // ─────────────────────── AYAH BOOKMARKS ───────────────────────

  @override
  Future<Either<LogicFailure, void>> addBookmarkAyah(
    BookmarkAyahRequest request,
  ) async {
    try {
      await bookmarkAyahService.addAyahBookmark(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> deleteBookmarkAyah(
    BookmarkAyahRequest request,
  ) async {
    try {
      await bookmarkAyahService.deleteAyahBookmark(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, List<BookmarkAyahModel>>>
      getBookmarksAyah() async {
    try {
      final result = await bookmarkAyahService.getAllAyahBookmarks();
      return right(result);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  // ─────────────────────── PAGE BOOKMARKS ───────────────────────

  @override
  Future<Either<LogicFailure, List<BookmarkPageModel>>>
      getBookmarksPage() async {
    try {
      final result = await bookmarkService.getAllBookmarksPage();
      return right(
        result.map((e) => BookmarkPageModel.fromJson(e.toJson())).toList(),
      );
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> addBookmarkPage(
    BookmarkPageRequest request,
  ) async {
    try {
      await bookmarkService.addBookmarkPage(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> deleteBookmarkPage(
    BookmarkPageRequest request,
  ) async {
    try {
      await bookmarkService.deleteBookmarkPage(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }
}
