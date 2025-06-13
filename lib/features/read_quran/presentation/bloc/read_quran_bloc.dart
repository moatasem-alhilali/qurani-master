import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/bookmark/data/database/bookmark_service.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

part 'read_quran_event.dart';
part 'read_quran_state.dart';

class ReadQuranBloc extends Bloc<ReadQuranEvent, ReadQuranState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PageController pageController = PageController();

  final QuranReadHelper quranRH = QuranReadHelper();
  final BookmarkTextService _bookmarkTextService = BookmarkTextService();

  bool toggle = false;

  ReadQuranBloc() : super(ReadQuranState()) {
    on<LoadQuranEvent>(_loadQuran);
    on<ToggleEvent>(_toggle);
    on<SetStateRBlocEvent>(_emitState);
  }

  /// Adds a text bookmark (ayah-based) using the BookmarkTextService
  Future<void> addBookmarkText(
    String surahName,
    int surahNum,
    int pageNum,
    int ayahNum,
    int ayahUQNum,
    String lastRead,
  ) async {
    try {
      final bookMark = BookmarksAyahs(
        null,
        surahName,
        surahNum,
        pageNum,
        ayahNum,
        ayahUQNum,
        lastRead,
      );
      await _bookmarkTextService.addTextBookmark(bookMark);
    } catch (e) {
      print('Error adding bookmark: $e');
    }
  }

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
      LoadQuranEvent event, Emitter<ReadQuranState> emit) async {
    emit(state.copyWith(loadQuranState: RequestState.loading));
    try {
      await quranRH.loadQuran();
      emit(state.copyWith(loadQuranState: RequestState.success));
    } catch (e) {
      emit(state.copyWith(loadQuranState: RequestState.error));
    }
  }

  /// Toggles internal view state
  void _toggle(ToggleEvent event, Emitter<ReadQuranState> emit) {
    toggle = !toggle;
    emit(state.copyWith(loadQuranState: RequestState.success));
  }

  /// Emits a fresh state manually
  void _emitState(SetStateRBlocEvent event, Emitter<ReadQuranState> emit) {
    emit(state.copyWith(loadQuranState: RequestState.success));
  }
}
