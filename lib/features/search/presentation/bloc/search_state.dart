part of 'search_bloc.dart';

@immutable
class SearchState {
  SearchState({
    //
    this.searchMossoState = RequestState.initial,
    this.result = const {},

    //
    this.historyState = RequestState.initial,
    this.historySearchMosoaa = const [],
    //
    this.ayahState = RequestState.initial,
    this.loadAyahState = RequestState.initial,
    this.ayaData = const [],
    this.currentSearchTerm = '',
  });
  //
  Map<String, dynamic> result;
  RequestState searchMossoState;
  //
  List<dynamic> historySearchMosoaa;
  RequestState historyState;

  //
  List<Aya> ayaData;
  RequestState ayahState;
  RequestState loadAyahState;
  String currentSearchTerm;

  SearchState copyWith({
    RequestState? searchMossoState,
    Map<String, dynamic>? result,
    //
    List<dynamic>? historySearchMosoaa,
    RequestState? historyState,

    //
    List<Aya>? ayaData,
    RequestState? ayahState,
    RequestState? loadAyahState,
    String? currentSearchTerm,
  }) {
    return SearchState(
      result: result ?? this.result,
      searchMossoState: searchMossoState ?? this.searchMossoState,

      //
      historySearchMosoaa: historySearchMosoaa ?? this.historySearchMosoaa,
      historyState: historyState ?? this.historyState,
      //
      ayaData: ayaData ?? this.ayaData,
      ayahState: ayahState ?? this.ayahState,
      loadAyahState: loadAyahState ?? this.loadAyahState,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
    );
  }
}
