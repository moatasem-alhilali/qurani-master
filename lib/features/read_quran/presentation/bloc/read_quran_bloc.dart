import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

part 'read_quran_event.dart';
part 'read_quran_state.dart';

class ReadQuranBloc extends Bloc<ReadQuranEvent, ReadQuranState> {
  ReadQuranBloc() : super(ReadQuranState()) {
    on<LoadQuranEvent>(_loadQuran);
    on<ToggleEvent>(_toggle);
    on<SetStateRBlocEvent>(_emitState);
    on<SetLastPageReadEvent>(_setLastPageRead);
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PageController pageController = PageController();

  final QuranReadHelper quranRH = QuranReadHelper();

  bool toggle = false;

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
    LoadQuranEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
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

  void _setLastPageRead(
    SetLastPageReadEvent event,
    Emitter<ReadQuranState> emit,
  ) {
    lastPageRead = event.page;
    CacheConfig.saveLastPageRead();
    emit(state.copyWith(loadQuranState: RequestState.success));
  }
}
