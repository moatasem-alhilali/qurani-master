part of 'search_bloc.dart';

@immutable
class SearchState {
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

  SearchState({
    //
    this.searchMossoState = RequestState.defaults,
    this.result = const {},

    //
    this.historyState = RequestState.defaults,
    this.historySearchMosoaa = const [],
    //
    this.ayahState = RequestState.defaults,
    this.loadAyahState = RequestState.defaults,
    this.ayaData = const [],
  });

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
    );
  }
}
