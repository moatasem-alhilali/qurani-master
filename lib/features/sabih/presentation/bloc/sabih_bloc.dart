import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<LoadAllSubihEvent>(_onLoadAllSubih);
    on<RefreshAllSubihEvent>(_onRefreshAllSubih);
    on<PerformSubihTapEvent>(_onPerformSubihTap);
    on<GetCountsForPeriodEvent>(_onGetCountsForPeriod);
    on<ResetTodayCounterEvent>(_onResetTodayCounter);
    on<AddCustomSubihEvent>(_onAddCustomSubih);
    on<UpdateSubihEvent>(_onUpdateSubih);
    on<DeleteSubihEvent>(_onDeleteSubih);
    on<GetAnalyticsDataEvent>(_onGetAnalyticsData);
  }

  final SabihRepository _repository;

  ({DateTime from, DateTime to}) _todayPeriod() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return (from: todayStart, to: now);
  }

  Future<void> _refreshSubihAndTodayCounts(
    Emitter<SabihState> emit, {
    RequestState actionState = RequestState.success,
  }) async {
    final subihResult = await _repository.getSubih();

    if (subihResult.isLeft()) {
      final failure = subihResult.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message ?? 'تعذر تحديث قائمة الأذكار.',
        ),
      );
      return;
    }

    final subihList = subihResult.getOrElse(() => []);
    final today = _todayPeriod();
    final countsResult = await _repository.getCountsGrouped(
      from: today.from,
      to: today.to,
    );

    if (countsResult.isLeft()) {
      final failure = countsResult.swap().getOrElse(() => LogicFailure(null));
      logger
          .e('Failed to refresh counts after list refresh: ${failure.message}');
    }

    final counts = countsResult.getOrElse(() => state.countsMap ?? {});

    emit(
      state.copyWith(
        loadState: RequestState.success,
        actionState: actionState,
        subihList: subihList,
        countsMap: counts,
        periodType: PeriodType.today,
        clearErrorMessage: true,
      ),
    );
  }

  FutureOr<void> _onRefreshAllSubih(
    RefreshAllSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    await _refreshSubihAndTodayCounts(emit);
  }

  FutureOr<void> _onLoadAllSubih(
    LoadAllSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        loadState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final subihResult = await _repository.getSubih();

    if (subihResult.isLeft()) {
      final failure = subihResult.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: failure.message ?? 'تعذر تحميل الأذكار.',
        ),
      );
      return;
    }

    final subihList = subihResult.getOrElse(() => []);
    final today = _todayPeriod();
    final countsResult = await _repository.getCountsGrouped(
      from: today.from,
      to: today.to,
    );

    if (countsResult.isLeft()) {
      final failure = countsResult.swap().getOrElse(() => LogicFailure(null));
      logger.e('Failed to load today counts: ${failure.message}');
    }

    emit(
      state.copyWith(
        loadState: RequestState.success,
        subihList: subihList,
        countsMap: countsResult.getOrElse(() => state.countsMap ?? {}),
        periodType: PeriodType.today,
        clearErrorMessage: true,
      ),
    );
  }

  FutureOr<void> _onPerformSubihTap(
    PerformSubihTapEvent event,
    Emitter<SabihState> emit,
  ) async {
    final previousCounts = Map<int, int>.from(state.countsMap ?? {});
    final optimisticCounts = Map<int, int>.from(previousCounts)
      ..update(
        event.subihId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

    emit(
      state.copyWith(
        countsMap: optimisticCounts,
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _repository.performSubihTap(event.subihId);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          countsMap: previousCounts,
          actionState: RequestState.error,
          errorMessage: failure.message ?? 'تعذر تسجيل الذكر.',
        ),
      );
      return;
    }

    final today = _todayPeriod();
    final countsResult = await _repository.getCountsGrouped(
      from: event.from ?? today.from,
      to: event.to ?? today.to,
    );

    if (countsResult.isLeft()) {
      logger.e('Failed to refresh counts after tap. keeping optimistic value.');
      emit(
        state.copyWith(
          countsMap: optimisticCounts,
          actionState: RequestState.success,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        countsMap: countsResult.getOrElse(() => optimisticCounts),
        actionState: RequestState.success,
        clearErrorMessage: true,
      ),
    );
  }

  FutureOr<void> _onGetCountsForPeriod(
    GetCountsForPeriodEvent event,
    Emitter<SabihState> emit,
  ) async {
    logger.d(event.periodType);

    final shouldShowFullLoading = state.subihList.isEmpty;

    if (shouldShowFullLoading) {
      emit(
        state.copyWith(
          loadState: RequestState.loading,
          periodType: event.periodType,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionState: RequestState.loading,
          periodType: event.periodType,
          clearErrorMessage: true,
        ),
      );
    }

    final result = await _repository.getCountsGrouped(
      from: event.from,
      to: event.to,
    );

    result.fold(
      (failure) {
        if (shouldShowFullLoading) {
          emit(
            state.copyWith(
              loadState: RequestState.error,
              errorMessage: failure.message,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            actionState: RequestState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (counts) {
        emit(
          state.copyWith(
            countsMap: counts,
            periodType: event.periodType,
            loadState:
                shouldShowFullLoading ? RequestState.success : state.loadState,
            actionState: shouldShowFullLoading
                ? state.actionState
                : RequestState.success,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  FutureOr<void> _onResetTodayCounter(
    ResetTodayCounterEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final resetResult = await _repository.resetTodayCounter(event.subihId);

    if (resetResult.isLeft()) {
      final failure = resetResult.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message ?? 'تعذر تصفير عداد اليوم.',
        ),
      );
      return;
    }

    final today = _todayPeriod();
    final result = await _repository.getCountsGrouped(
      from: today.from,
      to: today.to,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (counts) => emit(
        state.copyWith(
          countsMap: counts,
          periodType: PeriodType.today,
          actionState: RequestState.success,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  FutureOr<void> _onAddCustomSubih(
    AddCustomSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _repository.addSubih(event.request);
    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    await _refreshSubihAndTodayCounts(emit);
  }

  FutureOr<void> _onUpdateSubih(
    UpdateSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _repository.updateSubih(event.request);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    await _refreshSubihAndTodayCounts(emit);
  }

  FutureOr<void> _onDeleteSubih(
    DeleteSubihEvent event,
    Emitter<SabihState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _repository.deleteSubih(event.request);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => LogicFailure(null));
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    await _refreshSubihAndTodayCounts(emit);
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
