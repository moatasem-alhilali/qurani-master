import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';

part 'wird_event.dart';
part 'wird_state.dart';

class WirdBloc extends Bloc<WirdEvent, WirdState> {
  WirdBloc() : super(const WirdState()) {
    on<LoadWirdEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadWirdEvent event,
    Emitter<WirdState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.wirdsPath,
      );

      final names = list.map(WirdModel.fromJson).toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
