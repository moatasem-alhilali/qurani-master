import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';

part 'hisn_muslim_event.dart';
part 'hisn_muslim_state.dart';

class HisnMuslimBloc extends Bloc<HisnMuslimEvent, HisnMuslimState> {
  HisnMuslimBloc() : super(HisnMuslimState()) {
    on<LoadHisnMuslimEvent>(_onLoadHisnMuslim);
  }

  FutureOr<void> _onLoadHisnMuslim(
    LoadHisnMuslimEvent event,
    Emitter<HisnMuslimState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final jsonStr =
          await rootBundle.loadString('assets/json/hisn_muslim.json');

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;

      final sections = jsonMap.entries.map((entry) {
        return HisnMuslimModel.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        );
      }).toList();

      emit(
        state.copyWith(
          state: RequestState.success,
          hisnMuslim: sections,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          state: RequestState.error,
          hisnMuslim: [],
        ),
      );
    }
  }
}
