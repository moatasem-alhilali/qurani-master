// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'surah_quran_bloc.dart';

@immutable
class SurahQuranState {
  const SurahQuranState({
    this.loadQuranState = RequestState.initial,
    this.surahs = const [],
  });
  final RequestState loadQuranState;
  final List<NewSurahModel> surahs;


  SurahQuranState copyWith({
    RequestState? loadQuranState,
    List<NewSurahModel>? surahs,
  }) {
    return SurahQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
      surahs: surahs ?? this.surahs,
    );
  }
}
