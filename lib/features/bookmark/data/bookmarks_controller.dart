import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/bookmark/bookmark_service.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/main.dart';

class BookmarksController {
  final _bookmarkService = BookmarkService();
  final _bookmarkTextService = BookmarkTextService();

  final List<Bookmarks> bookmarksList = <Bookmarks>[];
  final List<BookmarksAyahs> bookmarkTextList = <BookmarksAyahs>[];
  late int lastBook;

  // ─────────────────────── TEXT BOOKMARKS ───────────────────────

  Future<void> getBookmarksText() async {
    bookmarkTextList.clear();
    bookmarkTextList.addAll(await _bookmarkTextService.getAllTextBookmarks());
  }

  Future<int?> addBookmarksText(BookmarksAyahs? bookmarksText) async {
    if (bookmarksText == null) return 0;
    bookmarkTextList.add(bookmarksText);
    final result = await _bookmarkTextService.addTextBookmark(bookmarksText);
    return result > 0 ? 1 : 0;
  }

  Future<void> updateBookmarksText(BookmarksAyahs? bookmarksText) async {
    if (bookmarksText == null) return;
    await _bookmarkTextService.updateTextBookmark(
        bookmarksText.id!, bookmarksText);
    await getBookmarksText();
  }

  Future<bool> deleteBookmarksText(int ayahNumber, int surahNumber) async {
    final bookmarkToDelete = bookmarkTextList.firstWhere(
      (b) => b.ayahNumber == ayahNumber && b.surahNumber == surahNumber,
      orElse: () => BookmarksAyahs(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      ), // empty if not found
    );

    if (bookmarkToDelete.id == null) return false;

    final result =
        await _bookmarkTextService.deleteTextBookmark(bookmarkToDelete.id!);
    if (result > 0) {
      bookmarkTextList.removeWhere((b) => b.id == bookmarkToDelete.id);
      await getBookmarksText();
      return true;
    }

    return false;
  }

  bool hasBookmarkSelect(int surahNum, int ayahNum, int pageNumber) {
    return bookmarkTextList.any((bookmark) =>
        bookmark.surahNumber == surahNum && bookmark.ayahUQNumber == ayahNum);
  }

  bool hasBookmark2(int surahNum, int ayahNum) {
    return bookmarkTextList.any((bookmark) =>
        bookmark.surahNumber == surahNum && bookmark.ayahNumber == ayahNum);
  }

  // ─────────────────────── PAGE BOOKMARKS ───────────────────────

  bool isPageBookmarked(int pageNum) {
    return bookmarksList.any((b) => b.pageNum == pageNum);
  }

  Future<void> getBookmarks() async {
    bookmarksList.clear();
    bookmarksList.addAll(await _bookmarkService.getAllBookmarks());
  }

  Future<int?> addBookmarks(
      int pageNum, String sorahName, String lastRead) async {
    try {
      final newBookmark = Bookmarks(
        pageNum: pageNum,
        sorahName: sorahName,
        lastRead: lastRead,
      );
      await _bookmarkService.addBookmark(newBookmark);
      await getBookmarks();
      return 1;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  void addPageBookmarkOnTap(BuildContext context, int index) async {
    final qrH = context.read<ReadQuranBloc>().quranRH;
    final sorahName = qrH.getSurahNameFromPage(index + 1);
    final now = TimeNow().dateNow;

    if (isPageBookmarked(index + 1)) {
      await deleteBookmarks(index + 1);
    } else {
      await addBookmarks(index + 1, sorahName, now);
    }
  }

  Future<bool> deleteBookmarks(int pageNum) async {
    try {
      final target = bookmarksList.firstWhere((b) => b.pageNum == pageNum);
      final result = await _bookmarkService.deleteBookmark(target.id!);
      if (result > 0) {
        bookmarksList.removeWhere((b) => b.id == target.id);
        return true;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return false;
  }

  // ─────────────────────── INIT ───────────────────────

  Future<void> init() async {
    await getBookmarksText();
    await getBookmarks();
  }
}

/// Utility for current date as string (yyyy/MM/dd)
class TimeNow {
  final DateTime now = DateTime.now();
  late final String dateNow;

  TimeNow() {
    dateNow =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  }
}
