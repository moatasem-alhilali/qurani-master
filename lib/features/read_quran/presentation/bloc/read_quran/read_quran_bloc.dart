import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

part 'read_quran_event.dart';
part 'read_quran_state.dart';

class ReadQuranBloc extends Bloc<ReadQuranEvent, ReadQuranState> {
  ReadQuranBloc() : super(const ReadQuranState()) {
    on<LoadQuranEvent>(_loadQuran);
    on<ToggleEvent>(_toggle);
    on<SetStateRBlocEvent>(_emitState);
    on<SetLastPageReadEvent>(_setLastPageRead);
    on<JumpToPageEvent>(_jumpToPage);
    on<ToggleBoxEvent>(_toggleBox);
    on<ToggleHighBoxEvent>(_toggleHighBox);
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PageController pageController = PageController();
  final BoxController boxController = BoxController();

  final QuranReadHelperSqlite quranReadHelperSqlite = QuranReadHelperSqlite();

  bool toggle = false;

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
    LoadQuranEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
    emit(state.copyWith(loadQuranState: RequestState.loading));
    try {
      final surahs = await quranReadHelperSqlite.getAllSurahs();
      final pages = await quranReadHelperSqlite.getAllPages();
      final allAyahs = await quranReadHelperSqlite.getAllAyahs();

      emit(
        state.copyWith(
          loadQuranState: RequestState.success,
          surahs: surahs,
          pages: pages,
          allAyahs: allAyahs,
        ),
      );
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
    emit(state.copyWith());
  }

  void _setLastPageRead(
    SetLastPageReadEvent event,
    Emitter<ReadQuranState> emit,
  ) {
    lastPageRead = event.page;
    CacheConfig.saveLastPageRead();
    emit(state.copyWith(loadQuranState: RequestState.success));
  }

  void _jumpToPage(JumpToPageEvent event, Emitter<ReadQuranState> emit) {
    if (event.page != null) {
      pageController.jumpToPage(event.page!);
      add(ToggleBoxEvent());
    } else {
      if (lastPageRead != 0) {
        pageController.jumpToPage(lastPageRead);
      }
    }
  }

  void _toggleBox(ToggleBoxEvent event, Emitter<ReadQuranState> emit) {
    boxController.isBoxOpen
        ? boxController.closeBox()
        : boxController.openBox();
  }

  void _toggleHighBox(
    ToggleHighBoxEvent event,
    Emitter<ReadQuranState> emit,
  ) {
    emit(state.copyWith(minusHeight: event.minusHeight));
  }
}
