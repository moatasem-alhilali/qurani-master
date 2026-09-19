import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'travel_athkar_event.dart';
part 'travel_athkar_state.dart';

class TravelAthkarBloc extends Bloc<TravelAthkarEvent, TravelAthkarState> {
  TravelAthkarBloc() : super(const TravelAthkarState()) {
    on<LoadAthkarEvent>(_onLoadAthkar);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<ResetCounterEvent>(_onResetCounter);

    add(LoadAthkarEvent());
  }

  Future<void> _onLoadAthkar(
    LoadAthkarEvent event,
    Emitter<TravelAthkarState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TravelAthkarStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final jsonString =
          await rootBundle.loadString('assets/json/travel_azkar.json');
      final rawList = jsonDecode(jsonString);
      if (rawList is! List<dynamic>) {
        throw const FormatException('Invalid travel azkar json');
      }

      final items = rawList
          .whereType<Map<dynamic, dynamic>>()
          .map(Map<String, dynamic>.from)
          .map(TravelDhikrModel.fromJson)
          .where((item) => item.key.isNotEmpty)
          .toList();

      emit(
        state.copyWith(
          status: TravelAthkarStatus.success,
          allItems: items,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TravelAthkarStatus.failure,
          errorMessage: L10nService.current.travelerAthkarLoadFailed,
        ),
      );
    }
  }

  void _onIncrementCounter(
    IncrementCounterEvent event,
    Emitter<TravelAthkarState> emit,
  ) {
    if (state.status != TravelAthkarStatus.success) return;

    final current = state.repeatCounts[event.item.key] ?? 0;
    final target = event.item.repeatCount;

    if (target != null && !event.item.isDynamicRepeat && current >= target) {
      return;
    }

    final updatedCounts = Map<String, int>.from(state.repeatCounts);
    updatedCounts[event.item.key] = current + 1;

    emit(state.copyWith(repeatCounts: updatedCounts));
  }

  void _onResetCounter(
    ResetCounterEvent event,
    Emitter<TravelAthkarState> emit,
  ) {
    if (state.status != TravelAthkarStatus.success) return;

    final updatedCounts = Map<String, int>.from(state.repeatCounts);
    updatedCounts[event.key] = 0;

    emit(state.copyWith(repeatCounts: updatedCounts));
  }
}
