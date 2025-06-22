import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';

part 'hadith_40_event.dart';
part 'hadith_40_state.dart';

class Hadith40Bloc extends Bloc<Hadith40Event, Hadith40State> {
  Hadith40Bloc() : super(const Hadith40State()) {
    on<LoadHadith40Event>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadHadith40Event event,
    Emitter<Hadith40State> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.hadith40Path,
      );

      final names = list.map(Hadith40Model.fromJson).toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
