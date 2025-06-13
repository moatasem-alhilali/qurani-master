import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/bookmark/data/remote/bookmarks_controller.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayahs.dart';
import 'package:quran_app/main.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //
  BookmarksController bookmarksController = BookmarksController();
  bool toggle = false;

  FutureOr<void> toggleUi(event, emit) {
    toggle = !toggle;
    emit(BookmarkState(setState: RequestState.success));
  }

  FutureOr<void> addBookmarkText(event, emit) async {
    try {
      await bookmarksController
          .addBookmarksText(event.bookmarksAyahs as BookmarksAyahs?);
      emit(BookmarkState(setState: RequestState.success));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  FutureOr<void> deleteBookmarkText(event, emit) async {
    try {
      await bookmarksController.deleteBookmarksText(
        event.ayahUQNum as int,
        event.surahNumber as int,
      );
      emit(BookmarkState(setState: RequestState.success));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
