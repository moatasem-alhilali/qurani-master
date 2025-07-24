part of 'sabih_bloc.dart';

@immutable
class SabihState extends Equatable {
  const SabihState({
    this.loadState = RequestState.initial,
    this.actionState = RequestState.initial,
    this.analyticsLoadState = RequestState.initial,
    this.subihList = const [],
    this.countsMap,
    this.errorMessage,
    this.selectedSubihId,
    this.periodType = PeriodType.today,
    this.todayCounts,
    this.weekCounts,
    this.monthCounts,
    this.allTimeCounts,
    this.todayMostUsed,
    this.weekMostUsed,
    this.monthMostUsed,
    this.allTimeMostUsed,
  });

  final RequestState loadState;
  final RequestState actionState;
  final RequestState analyticsLoadState;
  final List<SubihModel> subihList;
  final Map<int, int>? countsMap;
  final String? errorMessage;
  final int? selectedSubihId;
  final PeriodType periodType;

  // Analytics data
  final Map<int, int>? todayCounts;
  final Map<int, int>? weekCounts;
  final Map<int, int>? monthCounts;
  final Map<int, int>? allTimeCounts;
  final int? todayMostUsed;
  final int? weekMostUsed;
  final int? monthMostUsed;
  final int? allTimeMostUsed;

  SabihState copyWith({
    RequestState? loadState,
    RequestState? actionState,
    RequestState? analyticsLoadState,
    List<SubihModel>? subihList,
    Map<int, int>? countsMap,
    String? errorMessage,
    int? selectedSubihId,
    PeriodType? periodType,
    Map<int, int>? todayCounts,
    Map<int, int>? weekCounts,
    Map<int, int>? monthCounts,
    Map<int, int>? allTimeCounts,
    int? todayMostUsed,
    int? weekMostUsed,
    int? monthMostUsed,
    int? allTimeMostUsed,
  }) {
    return SabihState(
      loadState: loadState ?? this.loadState,
      actionState: actionState ?? this.actionState,
      analyticsLoadState: analyticsLoadState ?? this.analyticsLoadState,
      subihList: subihList ?? this.subihList,
      countsMap: countsMap ?? this.countsMap,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedSubihId: selectedSubihId ?? this.selectedSubihId,
      periodType: periodType ?? this.periodType,
      todayCounts: todayCounts ?? this.todayCounts,
      weekCounts: weekCounts ?? this.weekCounts,
      monthCounts: monthCounts ?? this.monthCounts,
      allTimeCounts: allTimeCounts ?? this.allTimeCounts,
      todayMostUsed: todayMostUsed ?? this.todayMostUsed,
      weekMostUsed: weekMostUsed ?? this.weekMostUsed,
      monthMostUsed: monthMostUsed ?? this.monthMostUsed,
      allTimeMostUsed: allTimeMostUsed ?? this.allTimeMostUsed,
    );
  }

  int getCountForSubih(int subihId) {
    return countsMap?[subihId] ?? 0;
  }

  SubihModel? getSubihById(int? id) {
    if (id == null) return null;
    try {
      return subihList.firstWhere((subih) => subih.id == id);
    } catch (_) {
      return null;
    }
  }

  SubihModel? get mostUsedTodaySubih => getSubihById(todayMostUsed);
  SubihModel? get mostUsedWeekSubih => getSubihById(weekMostUsed);
  SubihModel? get mostUsedMonthSubih => getSubihById(monthMostUsed);
  SubihModel? get mostUsedAllTimeSubih => getSubihById(allTimeMostUsed);

  @override
  List<Object?> get props => [
        loadState,
        actionState,
        analyticsLoadState,
        subihList,
        countsMap,
        errorMessage,
        selectedSubihId,
        periodType,
        todayCounts,
        weekCounts,
        monthCounts,
        allTimeCounts,
        todayMostUsed,
        weekMostUsed,
        monthMostUsed,
        allTimeMostUsed,
      ];
}
