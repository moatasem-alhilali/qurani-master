import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
part 'surah_info_event.dart';
part 'surah_info_state.dart';


class SurahInfoBloc extends Bloc<SurahInfoEvent, SurahInfoState> {
  SurahInfoBloc() : super(SurahInfoState()) {
    on<LoadSurahInfoEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadSurahInfoEvent event,
    Emitter<SurahInfoState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    try {
      final jsonStr =
          await rootBundle.loadString('assets/json/surah_info.json');
      final jsonMap = jsonDecode(jsonStr) as List<dynamic>;
      final models = <SurahInfoModel>[];
      for (final element in jsonMap) {
        models.add(SurahInfoModel.fromJson(element as Map<String, dynamic>));
      }
      emit(state.copyWith(state: RequestState.success, data: models));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error, data: []));
    }
  }
}
