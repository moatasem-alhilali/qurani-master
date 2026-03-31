// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quran_plan_bloc.dart';

class QuranPlanState extends Equatable {
  const QuranPlanState({
    this.requestState = RequestState.initial,
    this.deleteRequestState = RequestState.initial,
    this.createRequestState = RequestState.initial,
    this.plans = const [],
    this.selectedPlan,
    this.sessions = const [],
    this.nextSession,
    this.nextSessionState = RequestState.initial,
    this.errorMessage,
    this.analysis,
    this.currentPage = 0,
    this.pageSize = 20,
    this.hasMoreSessions = true,
    this.isLoadingMore = false,
  });
  final RequestState requestState;
  final RequestState deleteRequestState;
  final RequestState createRequestState;
  final List<QuranPlan> plans;
  final QuranPlan? selectedPlan;
  final List<QuranPlanSession> sessions;
  final QuranPlanSession? nextSession;
  final RequestState nextSessionState;
  final String? errorMessage;
  final PlanProgressAnalysis? analysis;
  final int currentPage;
  final int pageSize;
  final bool hasMoreSessions;
  final bool isLoadingMore;

  QuranPlanState copyWith({
    RequestState? requestState,
    RequestState? deleteRequestState,
    RequestState? createRequestState,
    List<QuranPlan>? plans,
    QuranPlan? selectedPlan,
    List<QuranPlanSession>? sessions,
    QuranPlanSession? nextSession,
    RequestState? nextSessionState,
    String? errorMessage,
    PlanProgressAnalysis? analysis,
    int? currentPage,
    int? pageSize,
    bool? hasMoreSessions,
    bool? isLoadingMore,
  }) {
    return QuranPlanState(
      requestState: requestState ?? this.requestState,
      deleteRequestState: deleteRequestState ?? this.deleteRequestState,
      createRequestState: createRequestState ?? this.createRequestState,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      sessions: sessions ?? this.sessions,
      nextSession: nextSession ?? this.nextSession,
      nextSessionState: nextSessionState ?? this.nextSessionState,
      errorMessage: errorMessage ?? this.errorMessage,
      analysis: analysis ?? this.analysis,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMoreSessions: hasMoreSessions ?? this.hasMoreSessions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        deleteRequestState,
        createRequestState,
        plans,
        selectedPlan,
        sessions,
        nextSession,
        nextSessionState,
        errorMessage,
        analysis,
        currentPage,
        pageSize,
        hasMoreSessions,
        isLoadingMore,
      ];
}
