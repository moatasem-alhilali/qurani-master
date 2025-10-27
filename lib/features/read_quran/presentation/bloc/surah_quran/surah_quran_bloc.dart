import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

part 'surah_quran_event.dart';
part 'surah_quran_state.dart';

class SurahQuranBloc extends Bloc<SurahQuranEvent, SurahQuranState> {
  SurahQuranBloc() : super(const SurahQuranState()) {
    on<LoadSurahEvent>(_loadQuran);
  }

  final QuranReadHelperSqlite quranReadHelperSqlite = QuranReadHelperSqlite();

  bool toggle = false;
  bool isTafser = false;

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
    LoadSurahEvent event,
    Emitter<SurahQuranState> emit,
  ) async {
    emit(state.copyWith(loadQuranState: RequestState.loading));
    try {
      final surahs = await quranReadHelperSqlite.getAllSurahs();

      emit(
        state.copyWith(
          loadQuranState: RequestState.success,
          surahs: surahs,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadQuranState: RequestState.error));
    }
  }
}
