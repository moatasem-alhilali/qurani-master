part of 'travel_athkar_bloc.dart';

enum TravelAthkarStatus { initial, loading, success, failure }
enum AthkarDisplayMode { pageView, listView }

class TravelAthkarState {
  const TravelAthkarState({
    this.status = TravelAthkarStatus.initial,
    this.allItems = const [],
    this.filteredItems = const [],
    this.repeatCounts = const {},
    this.errorMessage,
    this.searchQuery = '',
    this.displayMode = AthkarDisplayMode.pageView,
    this.currentPageIndex = 0,
  });

  final TravelAthkarStatus status;
  final List<TravelDhikrModel> allItems;
  final List<TravelDhikrModel> filteredItems;
  final Map<String, int> repeatCounts;
  final String? errorMessage;
  final String searchQuery;
  final AthkarDisplayMode displayMode;
  final int currentPageIndex;

  TravelAthkarState copyWith({
    TravelAthkarStatus? status,
    List<TravelDhikrModel>? allItems,
    List<TravelDhikrModel>? filteredItems,
    Map<String, int>? repeatCounts,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
    AthkarDisplayMode? displayMode,
    int? currentPageIndex,
  }) {
    return TravelAthkarState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      repeatCounts: repeatCounts ?? this.repeatCounts,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      displayMode: displayMode ?? this.displayMode,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
