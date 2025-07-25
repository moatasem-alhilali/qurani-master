// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quran_plan_bloc.dart';

class QuranPlanState extends Equatable {
  const QuranPlanState({
    this.requestState = RequestState.initial,
    this.plans = const [],
    this.selectedPlan,
    this.sessions = const [],
    this.errorMessage,
    this.analysis,
  });
  final RequestState requestState;
  final List<QuranPlan> plans;
  final QuranPlan? selectedPlan;
  final List<QuranPlanSession> sessions;
  final String? errorMessage;
  final PlanProgressAnalysis? analysis;

  QuranPlanState copyWith({
    RequestState? requestState,
    List<QuranPlan>? plans,
    QuranPlan? selectedPlan,
    List<QuranPlanSession>? sessions,
    String? errorMessage,
    PlanProgressAnalysis? analysis,
  }) {
    return QuranPlanState(
      requestState: requestState ?? this.requestState,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage ?? this.errorMessage,
      analysis: analysis ?? this.analysis,
    );
  }

  @override
  List<Object?> get props =>
      [requestState, plans, selectedPlan, sessions, errorMessage, analysis];
}
