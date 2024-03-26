import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/bookmark/data/bookmarks_controller.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark_ayahs.dart';
import 'package:quran_app/main.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //
  BookmarksController bookmarksController = BookmarksController();
  bool toggle = false;

  //
  BookmarkBloc() : super(BookmarkState()) {
    bookmarksController.init();
    on<ToggleBookmarkEvent>(toggleUi);
    on<AddBookmarkEvent>(addBookmarkText);
    on<DeleteBookmarkEvent>(deleteBookmarkText);
    on<SetStateBookmarkEvent>(
      (event, emit) {
        emit(BookmarkState(setState: RequestState.success));
      },
    );
  }

  FutureOr<void> toggleUi(event, emit) {
    toggle = !toggle;
    emit(BookmarkState(setState: RequestState.success));
  }

  FutureOr<void> addBookmarkText(event, emit) async {
    try {
      await bookmarksController.addBookmarksText(event.bookmarksAyahs);
      emit(BookmarkState(setState: RequestState.success));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  FutureOr<void> deleteBookmarkText(event, emit) async {
    try {
      bookmarksController.deleteBookmarksText(
          event.ayahUQNum, event.surahNumber);
      emit(BookmarkState(setState: RequestState.success));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
