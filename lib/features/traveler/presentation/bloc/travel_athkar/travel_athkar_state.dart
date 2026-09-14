part of 'travel_athkar_bloc.dart';

enum TravelAthkarStatus { initial, loading, success, failure }

/// حالة أذكار السفر.
///
/// حُذف منها `filteredItems` و`searchQuery` و`displayMode` و`currentPageIndex`:
/// كلّها آلة تصفّح لقائمة طويلة، والقائمة ستّة أذكار تتّسع لشاشة واحدة.
/// الترتيب على محطّات الرحلة يُشتقّ من `trigger` في الشاشة نفسها.
class TravelAthkarState {
  const TravelAthkarState({
    this.status = TravelAthkarStatus.initial,
    this.allItems = const [],
    this.repeatCounts = const {},
    this.errorMessage,
  });

  final TravelAthkarStatus status;
  final List<TravelDhikrModel> allItems;
  final Map<String, int> repeatCounts;
  final String? errorMessage;

  TravelAthkarState copyWith({
    TravelAthkarStatus? status,
    List<TravelDhikrModel>? allItems,
    Map<String, int>? repeatCounts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TravelAthkarState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      repeatCounts: repeatCounts ?? this.repeatCounts,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
