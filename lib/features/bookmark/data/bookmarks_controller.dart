import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/main.dart';

class BookmarksController {
  final List<Bookmarks> bookmarksList = <Bookmarks>[];
  final List<BookmarksAyahs> bookmarkTextList = <BookmarksAyahs>[];
  late int lastBook;

  Future<void> getBookmarksText() async {
    final List<Map<String, dynamic>> bookmarksText =
        await DBHelper.get('bookmarkTextTable');
    bookmarkTextList.clear();
    bookmarkTextList.addAll(
        bookmarksText.map((data) => BookmarksAyahs.fromJson(data)).toList());
  }

  init() {
    getBookmarksText();
    getBookmarks();
  }

  Future<int?> addBookmarksText(BookmarksAyahs? bookmarksText) async {
    bookmarkTextList.add(bookmarksText!);
    return (await DBHelper.insert('bookmarkTextTable', bookmarksText.toJson()))
        ? 1
        : 0;
  }

  void updateBookmarksText(BookmarksAyahs? bookmarksText) async {
    await DBHelper.updateBookmarksText(bookmarksText!);
    getBookmarksText();
  }

  bool deleteBookmarksText(int ayahNumber, surahNumber) {
    BookmarksAyahs? bookmarkToDelete = bookmarkTextList.firstWhere((bookmark) =>
        bookmark.ayahNumber == ayahNumber &&
        bookmark.surahNumber == surahNumber);
    DBHelper.deleteBookmarkText(bookmarkToDelete).then((value) {
      bookmarkTextList
          .removeWhere((element) => element.ayahNumber == ayahNumber);
      getBookmarksText();

      int result = value;
      if (result > 0) {
        getBookmarksText();
        return true;
      }
    });
    return false;
  }

  bool hasBookmarkSelect(int surahNum, int ayahNum, pageNumber) {
    for (final bookmark in bookmarkTextList) {
      if (bookmark.surahNumber == surahNum &&
          bookmark.ayahUQNumber == ayahNum) {
        return true;
      }
    }
    return false;
  }

  bool hasBookmark2(int surahNum, int ayahNum) {
    for (final bookmark in bookmarkTextList) {
      if (bookmark.surahNumber == surahNum && bookmark.ayahNumber == ayahNum) {
        return true;
      }
    }
    return false;
  }

  //-----------------------------------------------------------------------------page bookmark

  bool isPageBookmarked(int pageNum) {
    for (var bookmark in bookmarksList) {
      if (bookmark.pageNum == pageNum) {
        return true;
      }
    }
    return false;
  }

  Future<void> getBookmarks() async {
    final List<Map<String, dynamic>> bookmarks =
        await DBHelper.get('bookmarkTable');
    // logger.d(bookmarks);
    if (bookmarks.isNotEmpty) {
      bookmarksList.clear();

      bookmarksList
          .addAll(bookmarks.map((data) => Bookmarks.fromJson(data)).toList());
    }
  }

  Future<int?> addBookmarks(
      int pageNum, String sorahName, String lastRead) async {
    try {
      // If there's no bookmark for the current page, add a new one
      Bookmarks newBookmark =
          Bookmarks(pageNum: pageNum, sorahName: sorahName, lastRead: lastRead);
      await DBHelper.insert('bookmarkTable', newBookmark.toJson())
          .then((value) {
        getBookmarks();
        return value;
      });
      return null;
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  void addPageBookmarkOnTap(BuildContext context, int index) async {
    final qrH = context.read<ReadQuranBloc>().quranRH;
    TimeNow timeNow = TimeNow();
    final sorahName = qrH.getSurahNameFromPage(index + 1);
    print(sorahName);

    if (isPageBookmarked(index + 1)) {
      deleteBookmarks(index + 1, context);
      await getBookmarks();
    } else {
      addBookmarks(index + 1, sorahName, timeNow.dateNow);
      await getBookmarks();
    }
  }

  Future<bool> deleteBookmarks(int pageNum, BuildContext context) async {
    for (var bookmark in bookmarksList) {
      if (bookmark.pageNum == pageNum) {
        await DBHelper.deleteBookmark(bookmark);
        bookmarksList.removeWhere((element) => element.id == bookmark.id);
        return true;
      }
    }

    return false;
  }
}

class TimeNow {
  DateTime now = DateTime.now();
  late String dateNow;

  TimeNow() {
    dateNow =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  }
}
