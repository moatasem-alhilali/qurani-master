import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_event.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_state.dart';
import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';

class HisnMuslimBloc extends Bloc<HisnMuslimEvent, HisnMuslimState> {
  HisnMuslimBloc() : super(HisnMuslimInitial()) {
    on<LoadHisnMuslimEvent>(_onLoadHisnMuslim);
  }

  FutureOr<void> _onLoadHisnMuslim(
    LoadHisnMuslimEvent event,
    Emitter<HisnMuslimState> emit,
  ) async {
    emit(HisnMuslimLoading());

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

      emit(HisnMuslimLoaded(sections));
    } catch (e) {
      emit(HisnMuslimError('Failed to load hisn muslim data'));
    }
  }
}
