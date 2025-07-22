// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_quran_bloc.dart';

@immutable
class ReadQuranState {
  const ReadQuranState({
    this.loadQuranState = RequestState.initial,
    this.surahs = const [],
    this.pages = const [],
    this.allAyahs = const [],
    this.minusHeight = 300,
  });
  final RequestState loadQuranState;
  final List<NewSurahModel> surahs;
  final List<List<NewAyahModel>> pages;
  final List<NewAyahModel> allAyahs;
  final double minusHeight;

  ReadQuranState copyWith({
    RequestState? loadQuranState,
    List<NewSurahModel>? surahs,
    List<List<NewAyahModel>>? pages,
    List<NewAyahModel>? allAyahs,
    double? minusHeight,
  }) {
    return ReadQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
      surahs: surahs ?? this.surahs,
      pages: pages ?? this.pages,
      allAyahs: allAyahs ?? this.allAyahs,
      minusHeight: minusHeight ?? this.minusHeight,
    );
  }

  @override
  bool operator ==(covariant ReadQuranState other) {
    if (identical(this, other)) return true;

    return other.loadQuranState == loadQuranState &&
        other.surahs == surahs &&
        other.pages == pages &&
        other.allAyahs == allAyahs &&
        other.minusHeight == minusHeight;
  }

  @override
  int get hashCode =>
      loadQuranState.hashCode ^
      surahs.hashCode ^
      pages.hashCode ^
      allAyahs.hashCode ^
      minusHeight.hashCode;
}
