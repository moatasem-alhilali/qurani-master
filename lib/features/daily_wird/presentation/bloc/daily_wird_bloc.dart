import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_overview_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_settings_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_stats_model.dart';
import 'package:quran_app/features/daily_wird/data/repo/daily_wird_repository.dart';

part 'daily_wird_event.dart';
part 'daily_wird_state.dart';

class DailyWirdBloc extends Bloc<DailyWirdEvent, DailyWirdState> {
  DailyWirdBloc({
    required DailyWirdRepository repository,
  })  : _repository = repository,
        super(const DailyWirdState()) {
    on<DailyWirdLoadEvent>(_onLoad);
    on<DailyWirdSelectPresetEvent>(_onSelectPreset);
    on<DailyWirdIncrementItemEvent>(_onIncrementItem);
    on<DailyWirdResetItemEvent>(_onResetItem);
    on<DailyWirdToggleItemEvent>(_onToggleItem);
    on<DailyWirdHideItemEvent>(_onHideItem);
    on<DailyWirdRestoreItemEvent>(_onRestoreItem);
    on<DailyWirdUpdateItemCountEvent>(_onUpdateItemCount);
    on<DailyWirdMoveItemEvent>(_onMoveItem);
    on<DailyWirdUpdateSettingsEvent>(_onUpdateSettings);
  }

  final DailyWirdRepository _repository;

  Future<void> _onLoad(
    DailyWirdLoadEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading, clearError: true));
    try {
      final overview = await _repository.loadOverview();
      emit(_mapOverview(state, overview));
    } catch (error) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSelectPreset(
    DailyWirdSelectPresetEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.selectPreset(event.presetId));
  }

  Future<void> _onIncrementItem(
    DailyWirdIncrementItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.incrementItem(event.itemId));
  }

  Future<void> _onResetItem(
    DailyWirdResetItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.resetItem(event.itemId));
  }

  Future<void> _onToggleItem(
    DailyWirdToggleItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.toggleCompleted(event.itemId));
  }

  Future<void> _onHideItem(
    DailyWirdHideItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.hideItem(event.itemId));
  }

  Future<void> _onRestoreItem(
    DailyWirdRestoreItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(emit, () => _repository.restoreItem(event.itemId));
  }

  Future<void> _onUpdateItemCount(
    DailyWirdUpdateItemCountEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(
      emit,
      () => _repository.updateItemCount(event.itemId, event.countRequired),
    );
  }

  Future<void> _onMoveItem(
    DailyWirdMoveItemEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(
      emit,
      () => _repository.moveItem(event.itemId, event.direction),
    );
  }

  Future<void> _onUpdateSettings(
    DailyWirdUpdateSettingsEvent event,
    Emitter<DailyWirdState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading, clearError: true));
    await _runMutation(
      emit,
      () => _repository.updateReminderSettings(event.settings),
    );
  }

  Future<void> _runMutation(
    Emitter<DailyWirdState> emit,
    Future<DailyWirdOverview> Function() action,
  ) async {
    try {
      final overview = await action();
      emit(
        _mapOverview(
          state,
          overview,
          actionState: RequestState.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  DailyWirdState _mapOverview(
    DailyWirdState current,
    DailyWirdOverview overview, {
    RequestState requestState = RequestState.success,
    RequestState actionState = RequestState.initial,
  }) {
    return current.copyWith(
      requestState: requestState,
      actionState: actionState,
      presets: overview.presets,
      settings: overview.settings,
      program: overview.program,
      stats: overview.stats,
      clearError: true,
    );
  }
}
