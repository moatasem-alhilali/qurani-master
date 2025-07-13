// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'read_quran_bloc.dart';

@immutable
class ReadQuranState {
  const ReadQuranState({
    this.loadQuranState = RequestState.initial,
    this.surahs = const [],
    this.pages = const [],
    this.allAyahs = const [],
  });
  final RequestState loadQuranState;
  final List<Surah> surahs;
  final List<List<Ayah>> pages;
  final List<Ayah> allAyahs;

  ReadQuranState copyWith({
    RequestState? loadQuranState,
    List<Surah>? surahs,
    List<List<Ayah>>? pages,
    List<Ayah>? allAyahs,
  }) {
    return ReadQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
      surahs: surahs ?? this.surahs,
      pages: pages ?? this.pages,
      allAyahs: allAyahs ?? this.allAyahs,
    );
  }

  @override
  bool operator ==(covariant ReadQuranState other) {
    if (identical(this, other)) return true;

    return other.loadQuranState == loadQuranState &&
        other.surahs == surahs &&
        other.pages == pages &&
        other.allAyahs == allAyahs;
  }

  @override
  int get hashCode =>
      loadQuranState.hashCode ^
      surahs.hashCode ^
      pages.hashCode ^
      allAyahs.hashCode;
}
