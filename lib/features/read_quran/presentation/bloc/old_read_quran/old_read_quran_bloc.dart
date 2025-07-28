import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

part 'old_read_quran_event.dart';
part 'old_read_quran_state.dart';

class OldReadQuranBloc extends Bloc<OldReadQuranEvent, OldReadQuranState> {
  OldReadQuranBloc() : super(const OldReadQuranState()) {
    on<OldLoadQuranEvent>(_loadQuran);
    on<OldToggleEvent>(_toggle);
    on<OldSetStateRBlocEvent>(_emitState);
    on<OldSetLastPageReadEvent>(_setLastPageRead);
    on<OldJumpToPageEvent>(_jumpToPage);
    on<OldToggleBoxEvent>(_toggleBox);
    on<OldToggleHighBoxEvent>(_toggleHighBox);
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PageController pageController = PageController();
  final BoxController boxController = BoxController();

  final QuranReadHelper quranRH = QuranReadHelper();

  bool toggle = false;

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
    OldLoadQuranEvent event,
    Emitter<OldReadQuranState> emit,
  ) async {
    emit(state.copyWith(loadQuranState: RequestState.loading));
    try {
      await quranRH.loadQuran();

      emit(
        state.copyWith(
          loadQuranState: RequestState.success,
          surahs: quranRH.surahs,
          pages: quranRH.pages,
          allAyahs: quranRH.allAyahs,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadQuranState: RequestState.error));
    }
  }

  /// Toggles internal view state
  void _toggle(OldToggleEvent event, Emitter<OldReadQuranState> emit) {
    toggle = !toggle;
    emit(state.copyWith(loadQuranState: RequestState.success));
  }

  /// Emits a fresh state manually
  void _emitState(
    OldSetStateRBlocEvent event,
    Emitter<OldReadQuranState> emit,
  ) {
    emit(state.copyWith());
  }

  void _setLastPageRead(
    OldSetLastPageReadEvent event,
    Emitter<OldReadQuranState> emit,
  ) {
    lastPageRead = event.page;
    CacheConfig.saveLastPageRead();
    emit(state.copyWith(loadQuranState: RequestState.success));
  }

  void _jumpToPage(OldJumpToPageEvent event, Emitter<OldReadQuranState> emit) {
    if (event.page != null) {
      pageController.jumpToPage(event.page!);
      add(OldToggleBoxEvent());
    } else {
      if (lastPageRead != 0) {
        pageController.jumpToPage(lastPageRead);
      }
    }
  }

  void _toggleBox(OldToggleBoxEvent event, Emitter<OldReadQuranState> emit) {
    boxController.isBoxOpen
        ? boxController.closeBox()
        : boxController.openBox();
  }

  void _toggleHighBox(
    OldToggleHighBoxEvent event,
    Emitter<OldReadQuranState> emit,
  ) {
    emit(state.copyWith(minusHeight: event.minusHeight));
  }
}
