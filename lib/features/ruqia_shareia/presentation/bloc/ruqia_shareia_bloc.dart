import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/ruqia_shareia/data/models/ruqia_shareia_model.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';

part 'ruqia_shareia_event.dart';
part 'ruqia_shareia_state.dart';

class RuqiaShareiaBloc extends Bloc<RuqiaShareiaEvent, RuqiaShareiaState> {
  RuqiaShareiaBloc() : super(const RuqiaShareiaState()) {
    on<LoadRuqiaShareiaEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadRuqiaShareiaEvent event,
    Emitter<RuqiaShareiaState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.ruqiaShareiaPath,
      );

      final names = list.map(RuqiaShareiaModel.fromJson).toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
