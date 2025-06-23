import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/list_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayah.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_page_model.dart';
import 'package:quran_app/features/bookmark/data/remote/book_mark_repository_imp.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_ayah_request.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_page_request.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc({required this.repository}) : super(const BookmarkState()) {
    on<GetBookmarksAyahEvent>(_getBookmarksAyah);
    on<AddBookmarkAyahEvent>(_addBookmarkAyah);
    on<DeleteBookmarkAyahEvent>(_deleteBookmarkAyah);

    // ─────────────────────── PAGE BOOKMARKS ───────────────────────
    on<GetBookmarksPageEvent>(_getBookmarksPage);
    on<AddBookmarkPageEvent>(_addBookmarkPage);
    on<DeleteBookmarkPageEvent>(_deleteBookmarkPage);

    on<SetStateBookmarkEvent>(
      (event, emit) {
        emit(state.copyWith(setState: RequestState.success));
      },
    );
  }
  //
  final BookmarkRepositoryImpl repository;

  FutureOr<void> _getBookmarksAyah(
    GetBookmarksAyahEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.getBookmarksAyah();
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (bookmarks) => emit(
        state.copyWith(
          setState: RequestState.success,
          ayahBookmarkList: bookmarks,
        ),
      ),
    );
  }

  FutureOr<void> _addBookmarkAyah(
    AddBookmarkAyahEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.addBookmarkAyah(event.bookmarksAyah);
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            setState: RequestState.success,
          ),
        );
        add(GetBookmarksAyahEvent());
      },
    );
  }

  FutureOr<void> _deleteBookmarkAyah(
    DeleteBookmarkAyahEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.deleteBookmarkAyah(event.bookmarksAyah);
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            setState: RequestState.success,
          ),
        );
        add(GetBookmarksAyahEvent());
      },
    );
  }

  // ─────────────────────── PAGE BOOKMARKS ───────────────────────

  FutureOr<void> _getBookmarksPage(
    GetBookmarksPageEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.getBookmarksPage();
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (bookmarks) => emit(
        state.copyWith(
          setState: RequestState.success,
          pageBookmarksList: bookmarks,
        ),
      ),
    );
  }

  FutureOr<void> _addBookmarkPage(
    AddBookmarkPageEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.addBookmarkPage(event.bookmarksPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            setState: RequestState.success,
          ),
        );
        add(GetBookmarksPageEvent());
      },
    );
  }

  FutureOr<void> _deleteBookmarkPage(
    DeleteBookmarkPageEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await repository.deleteBookmarkPage(event.bookmarksPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          setState: RequestState.error,
          error: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            setState: RequestState.success,
          ),
        );
        add(GetBookmarksPageEvent());
      },
    );
  }

  // ─────────────────────── AYAH BOOKMARKS ───────────────────────
  bool hasBookmarkAyahSelect(int surahNum, int ayahNum) {
    final res = state.ayahBookmarkList.any(
      (bookmark) =>
          bookmark.surahNumber == surahNum && bookmark.ayahNumber == ayahNum,
    );
    return res;
  }

  bool hasBookmarkAyah(int surahNum, int ayahNum) {
    return state.ayahBookmarkList.any(
      (bookmark) {
        final bool =
            bookmark.surahNumber == surahNum && bookmark.ayahNumber == ayahNum;
        // log('bookmark: ${bookmark.ayahUQNumber} ${bookmark.ayahNumber}');
        return bool;
      },
    );
  }

  //get bookmark ayah id by surah num and ayah num
  int? getBookmarkAyahId(int surahNum, int ayahNum) {
    final res = state.ayahBookmarkList.firstWhereOrNull(
      (bookmark) =>
          bookmark.surahNumber == surahNum && bookmark.ayahNumber == ayahNum,
    );
    return res?.id;
  }

  bool hasBookmarkPage(int pageNum) {
    return state.pageBookmarksList.any(
      (bookmark) => bookmark.pageNum == pageNum,
    );
  }

  int? getBookmarkPageId(int pageNum) {
    final res = state.pageBookmarksList.firstWhereOrNull(
      (bookmark) => bookmark.pageNum == pageNum,
    );
    return res?.id;
  }
}
