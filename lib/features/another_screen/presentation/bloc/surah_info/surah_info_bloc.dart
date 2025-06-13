import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_event.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_state.dart';

class SurahInfoBloc extends Bloc<SurahInfoEvent, SurahInfoState> {
  SurahInfoBloc() : super(SurahInfoInitial()) {
    on<LoadSurahInfoEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadSurahInfoEvent event,
    Emitter<SurahInfoState> emit,
  ) async {
    emit(SurahInfoLoading());
    try {
      final jsonStr =
          await rootBundle.loadString('assets/json/surah_info.json');
      final jsonMap = jsonDecode(jsonStr) as List<dynamic>;
      final models = <SurahInfoModel>[];
      for (final element in jsonMap) {
        models.add(SurahInfoModel.fromJson(element as Map<String, dynamic>));
      }
      emit(SurahInfoLoaded(models));
    } catch (e) {
      emit(SurahInfoError('Failed to load surah info'));
    }
  }
}
