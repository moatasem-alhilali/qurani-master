part of 'search_bloc.dart';

@immutable
class SearchState {
  const SearchState({
    //
    // this.searchMossoState = RequestState.initial,
    // this.result = const {},

    //
    // this.historyState = RequestState.initial,
    //  this.historySearchMosoaa = const [],
    //
    this.ayahState = RequestState.initial,
    this.loadAyahState = RequestState.initial,
    this.ayaData = const [],
    this.currentSearchTerm = '',
  });
  //
  // final Map<String, dynamic> result;
  // final RequestState searchMossoState;
  //
  // final List<dynamic> historySearchMosoaa;
  // final RequestState historyState;

  //
  final List<NewAyahModel> ayaData;
  final RequestState ayahState;
  final RequestState loadAyahState;
  final String currentSearchTerm;

  SearchState copyWith({
    // RequestState? searchMossoState,
    // Map<String, dynamic>? result,
    //
    // List<dynamic>? historySearchMosoaa,
    // RequestState? historyState,

    //
    List<NewAyahModel>? ayaData,
    RequestState? ayahState,
    RequestState? loadAyahState,
    String? currentSearchTerm,
  }) {
    return SearchState(
      // result: result ?? this.result,
      // searchMossoState: searchMossoState ?? this.searchMossoState,

      //
      // historySearchMosoaa: historySearchMosoaa ?? this.historySearchMosoaa,
      // historyState: historyState ?? this.historyState,
      //
      ayaData: ayaData ?? this.ayaData,
      ayahState: ayahState ?? this.ayahState,
      loadAyahState: loadAyahState ?? this.loadAyahState,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
    );
  }

  
}
