part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SetStateEvent extends SearchEvent {}

// class SearchMosoaaEvent extends SearchEvent {
//   final String text;
//   SearchMosoaaEvent(this.text);
// }

// class GetHistoryMosoaaEvent extends SearchEvent {}

// class SearchQuranEvent extends SearchEvent {
//   final String text;
//   SearchQuranEvent(this.text);
// }

class SearchSurahEvent extends SearchEvent {
  SearchSurahEvent(this.text);
  final String text;
}

class FetchAyaMoreEvent extends SearchEvent {
  FetchAyaMoreEvent(this.text);
  final String text;
}
