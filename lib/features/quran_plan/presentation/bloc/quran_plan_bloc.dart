import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/quran_plan/data/data_source/plan_analytics_datasource.dart';
import 'package:quran_app/features/quran_plan/data/data_source/quran_plan_data_source.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/main.dart';

part 'quran_plan_event.dart';
part 'quran_plan_state.dart';

class QuranPlanBloc extends Bloc<QuranPlanEvent, QuranPlanState> {
  QuranPlanBloc(this.dataSource) : super(const QuranPlanState()) {
    on<LoadAllPlansEvent>(_onLoadAllPlans);
    on<CreatePlanEvent>(_onCreatePlan);
    on<UpdatePlanEvent>(_onUpdatePlan);
    on<DeletePlanEvent>(_onDeletePlan);
    on<LoadSessionsEvent>(_onLoadSessions);
    on<CompleteSessionEvent>(_onCompleteSession);
  }
  final QuranPlanDataSource dataSource;

  Future<void> _onLoadAllPlans(
    LoadAllPlansEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      final plans = await dataSource.getAllPlans();
      emit(state.copyWith(requestState: RequestState.success, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreatePlan(
    CreatePlanEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      final planId = await dataSource.createPlan(
        event.plan,
        event.fromJuz,
        event.toJuz,
        event.totalDays,
      );
      final plans = await dataSource.getAllPlans();
      emit(state.copyWith(requestState: RequestState.success, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdatePlan(
    UpdatePlanEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      await dataSource.updatePlan(event.plan);
      final plans = await dataSource.getAllPlans();
      emit(state.copyWith(requestState: RequestState.success, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeletePlan(
    DeletePlanEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      await dataSource.deletePlan(event.planId);
      final plans = await dataSource.getAllPlans();
      emit(state.copyWith(requestState: RequestState.success, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadSessions(
    LoadSessionsEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      final sessions = await dataSource.getSessions(event.plan.id!);
      final analysis = await PlanAnalyticsService().analyzePlan(
        event.plan,
        sessions,
      );
      emit(
        state.copyWith(
          requestState: RequestState.success,
          sessions: sessions,
          analysis: analysis,
        ),
      );
    } catch (e, stackTrace) {
      logger.e(e.toString(), stackTrace: stackTrace);
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCompleteSession(
    CompleteSessionEvent event,
    Emitter<QuranPlanState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      await dataSource.completeSession(event.sessionId);
      // reload sessions for current plan if wanted
      if (state.selectedPlan != null) {
        final sessions = await dataSource.getSessions(state.selectedPlan!.id!);
        emit(
          state.copyWith(
            requestState: RequestState.success,
            sessions: sessions,
          ),
        );
      } else {
        emit(state.copyWith(requestState: RequestState.success));
        add(LoadSessionsEvent(state.selectedPlan!.id!, state.selectedPlan!));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
