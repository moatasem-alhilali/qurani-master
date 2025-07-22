// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'old_read_quran_bloc.dart';

@immutable
class OldReadQuranState {
  const OldReadQuranState({
    this.loadQuranState = RequestState.initial,
    this.surahs = const [],
    this.pages = const [],
    this.allAyahs = const [],
    this.minusHeight = 300,
  });
  final RequestState loadQuranState;
  final List<Surah> surahs;
  final List<List<AyahQuranModel>> pages;
  final List<AyahQuranModel> allAyahs;
  final double minusHeight;

  OldReadQuranState copyWith({
    RequestState? loadQuranState,
    List<Surah>? surahs,
    List<List<AyahQuranModel>>? pages,
    List<AyahQuranModel>? allAyahs,
    double? minusHeight,
  }) {
    return OldReadQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
      surahs: surahs ?? this.surahs,
      pages: pages ?? this.pages,
      allAyahs: allAyahs ?? this.allAyahs,
      minusHeight: minusHeight ?? this.minusHeight,
    );
  }

  @override
  bool operator ==(covariant OldReadQuranState other) {
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
