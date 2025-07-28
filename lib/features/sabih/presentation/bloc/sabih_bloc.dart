import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/main.dart';

part 'sabih_event.dart';
part 'sabih_state.dart';

class SabihBloc extends Bloc<SabihEvent, SabihState> {
  SabihBloc({required SabihRepository repository})
      : _repository = repository,
        super(const SabihState()) {
    // Load all dhikr items
    on<LoadAllSubihEvent>(_onLoadAllSubih);

    // Refresh all dhikr items
    on<RefreshAllSubihEvent>(_onRefreshAllSubih);

    // Tap/count dhikr
    on<PerformSubihTapEvent>(_onPerformSubihTap);

    // Get counts for a specific period
    on<GetCountsForPeriodEvent>(_onGetCountsForPeriod);

    // Reset counter for today for a specific dhikr
    on<ResetTodayCounterEvent>(_onResetTodayCounter);

    // Add new custom dhikr
    on<AddCustomSubihEvent>(_onAddCustomSubih);

    // Update existing dhikr
    on<UpdateSubihEvent>(_onUpdateSubih);

    // Delete dhikr
    on<DeleteSubihEvent>(_onDeleteSubih);

    // Get analytics data
    on<GetAnalyticsDataEvent>(_onGetAnalyticsData);
  }
  final SabihRepository _repository;

  FutureOr<void> _onRefreshAllSubih(
    RefreshAllSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    // Refresh the list of dhikr items
    final subihResult = await _repository.getSubih();

    subihResult.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (subihList) => emit(
        state.copyWith(
          subihList: subihList,
          actionState: RequestState.success,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadAllSubih(
    LoadAllSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading));

    final result = await _repository.getSubih();

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (subihList) => emit(
        state.copyWith(
          loadState: RequestState.success,
          subihList: subihList,
        ),
      ),
    );
  }

  FutureOr<void> _onPerformSubihTap(
    PerformSubihTapEvent event,
    Emitter<SabihState> emit,
  ) async {
    // Show optimistic update
    final updatedCounts = Map<int, int>.from(state.countsMap ?? {});
    updatedCounts[event.subihId] = (updatedCounts[event.subihId] ?? 0) + 1;

    emit(
      state.copyWith(
        countsMap: updatedCounts,
        actionState: RequestState.loading,
      ),
    );

    final result = await _repository.performSubihTap(event.subihId);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => LogicFailure('message'));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message ?? 'Unknown error',
        ),
      );
      return;
    }

    final now = DateTime.now();
    final countsResult = await _repository.getCountsGrouped(
      from: event.from ?? DateTime(now.year, now.month, now.day),
      to: event.to ?? now,
    );

    countsResult.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (counts) => emit(
        state.copyWith(
          countsMap: counts,
          actionState: RequestState.success,
        ),
      ),
    );
  }

  FutureOr<void> _onGetCountsForPeriod(
    GetCountsForPeriodEvent event,
    Emitter<SabihState> emit,
  ) async {
    logger.d(event.periodType);
    emit(
      state.copyWith(
        loadState: RequestState.loading,
        periodType: event.periodType,
      ),
    );

    final result = await _repository.getCountsGrouped(
      from: event.from,
      to: event.to,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (counts) => emit(
        state.copyWith(
          countsMap: counts,
          loadState: RequestState.success,
        ),
      ),
    );
  }

  FutureOr<void> _onResetTodayCounter(
    ResetTodayCounterEvent event,
    Emitter<SabihState> emit,
  ) async {
    // This is a custom operation not directly in the repository
    // We'll need to implement it by removing today's logs for this dhikr

    emit(state.copyWith(actionState: RequestState.loading));

    // For now, we'll simulate this by refreshing the counts
    // In a real implementation, you would add a method to delete logs for today

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // TODO: Add repository method to reset counter for specific dhikr for today

    // Refresh counts after reset
    final result = await _repository.getCountsGrouped(
      from: today,
      to: now,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (counts) {
        // Remove this dhikr's count or set to 0
        final updatedCounts = Map<int, int>.from(counts);
        updatedCounts[event.subihId] = 0;

        emit(
          state.copyWith(
            countsMap: updatedCounts,
            actionState: RequestState.success,
          ),
        );
      },
    );
  }

  FutureOr<void> _onAddCustomSubih(
    AddCustomSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading));

    final result = await _repository.addSubih(event.request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(RefreshAllSubihEvent()),
    );
  }

  FutureOr<void> _onUpdateSubih(
    UpdateSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading));

    final result = await _repository.updateSubih(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(RefreshAllSubihEvent()),
    );
  }

  FutureOr<void> _onDeleteSubih(
    DeleteSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading));

    final result = await _repository.deleteSubih(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(RefreshAllSubihEvent()),
    );
  }

  FutureOr<void> _onGetAnalyticsData(
    GetAnalyticsDataEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        analyticsLoadState: RequestState.loading,
      ),
    );

    try {
      final now = DateTime.now();

      // Get today's counts
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayResult = await _repository.getSummaryCounts(
        from: todayStart,
        to: now,
      );

      // Get this week's counts
      final weekStart =
          DateTime(now.year, now.month, now.day - now.weekday + 1);
      final weekResult = await _repository.getSummaryCounts(
        from: weekStart,
        to: now,
      );

      // Get this month's counts
      final monthStart = DateTime(now.year, now.month);
      final monthResult = await _repository.getSummaryCounts(
        from: monthStart,
        to: now,
      );

      // Get all time counts
      final allTimeResult = await _repository.getSummaryCounts(
        from: DateTime(2000),
        to: now,
      );

      // Combine results
      final todayCounts = todayResult.getOrElse(() => {});
      final weekCounts = weekResult.getOrElse(() => {});
      final monthCounts = monthResult.getOrElse(() => {});
      final allTimeCounts = allTimeResult.getOrElse(() => {});

      // Get the most used dhikr for each period
      final todayMostUsed = _getMostUsedDhikr(todayCounts);
      final weekMostUsed = _getMostUsedDhikr(weekCounts);
      final monthMostUsed = _getMostUsedDhikr(monthCounts);
      final allTimeMostUsed = _getMostUsedDhikr(allTimeCounts);

      emit(
        state.copyWith(
          analyticsLoadState: RequestState.success,
          todayCounts: todayCounts,
          weekCounts: weekCounts,
          monthCounts: monthCounts,
          allTimeCounts: allTimeCounts,
          todayMostUsed: todayMostUsed,
          weekMostUsed: weekMostUsed,
          monthMostUsed: monthMostUsed,
          allTimeMostUsed: allTimeMostUsed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          analyticsLoadState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  int? _getMostUsedDhikr(Map<int, int> counts) {
    if (counts.isEmpty) return null;

    int? maxId;
    var maxCount = 0;

    counts.forEach((id, count) {
      if (count > maxCount) {
        maxCount = count;
        maxId = id;
      }
    });

    return maxId;
  }
}
