import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/allh_name/data/models/allah_name_model.dart';

part 'allah_names_event.dart';
part 'allah_names_state.dart';

class AllahNamesBloc extends Bloc<AllahNamesEvent, AllahNamesState> {
  AllahNamesBloc() : super(const AllahNamesState()) {
    on<LoadAllahNamesEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadAllahNamesEvent event,
    Emitter<AllahNamesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.allahNamesPath,
      );

      final names = list.map(AllahNameModel.fromJson).toList();

      emit(state.copyWith(data: names, state: RequestState.success));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }
}
