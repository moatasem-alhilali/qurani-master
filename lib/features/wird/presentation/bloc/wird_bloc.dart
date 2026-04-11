import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
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

      final names = list
          .map(WirdModel.fromJson)
          .where((item) => item.isForPeriod(event.isMorning))
          .toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
