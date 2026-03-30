part of 'young_muslim_bloc.dart';

class YoungMuslimState extends Equatable {
  const YoungMuslimState({
    this.loadState = RequestState.initial,
    this.categoryState = RequestState.initial,
    this.videoState = RequestState.initial,
    this.actionState = RequestState.initial,
    this.dashboard,
    this.categoryDetails,
    this.videoDetails,
    this.query = '',
    this.filters = YoungMuslimFilters.empty,
    this.errorMessage,
  });

  final RequestState loadState;
  final RequestState categoryState;
  final RequestState videoState;
  final RequestState actionState;
  final YoungMuslimDashboardEntity? dashboard;
  final YoungMuslimCategoryDetailsEntity? categoryDetails;
  final YoungMuslimVideoDetailsEntity? videoDetails;
  final String query;
  final YoungMuslimFilters filters;
  final String? errorMessage;

  YoungMuslimState copyWith({
    RequestState? loadState,
    RequestState? categoryState,
    RequestState? videoState,
    RequestState? actionState,
    YoungMuslimDashboardEntity? dashboard,
    YoungMuslimCategoryDetailsEntity? categoryDetails,
    YoungMuslimVideoDetailsEntity? videoDetails,
    String? query,
    YoungMuslimFilters? filters,
    String? errorMessage,
  }) {
    return YoungMuslimState(
      loadState: loadState ?? this.loadState,
      categoryState: categoryState ?? this.categoryState,
      videoState: videoState ?? this.videoState,
      actionState: actionState ?? this.actionState,
      dashboard: dashboard ?? this.dashboard,
      categoryDetails: categoryDetails ?? this.categoryDetails,
      videoDetails: videoDetails ?? this.videoDetails,
      query: query ?? this.query,
      filters: filters ?? this.filters,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        categoryState,
        videoState,
        actionState,
        dashboard,
        categoryDetails,
        videoDetails,
        query,
        filters,
        errorMessage,
      ];
}
