import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';

import 'package:quran_app/features/zkar_after_pray/data/models/zkar_after_pray_model.dart';
import 'package:quran_app/main.dart';

part 'zkar_after_pray_event.dart';
part 'zkar_after_pray_state.dart';

class ZkarAfterPrayBloc extends Bloc<ZkarAfterPrayEvent, ZkarAfterPrayState> {
  ZkarAfterPrayBloc() : super(const ZkarAfterPrayState()) {
    on<LoadZkarAfterPrayEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadZkarAfterPrayEvent event,
    Emitter<ZkarAfterPrayState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.zkarAfterPrayPath,
      );

      final names = list.map(ZkarAfterPrayModel.fromJson).toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      logger.e(e.toString());
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
