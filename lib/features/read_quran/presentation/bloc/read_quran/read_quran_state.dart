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
    // this.currentPageAyahsSeparatedForBasmalah = const [],
    this.tafsirAyah,
  });
  final RequestState loadQuranState;
  final List<NewSurahModel> surahs;
  final List<List<NewAyahModel>> pages;
  final List<NewAyahModel> allAyahs;
  final double minusHeight;
  // final List<List<NewAyahModel>> currentPageAyahsSeparatedForBasmalah;
  final String? tafsirAyah;

  ReadQuranState copyWith({
    RequestState? loadQuranState,
    List<NewSurahModel>? surahs,
    List<List<NewAyahModel>>? pages,
    List<NewAyahModel>? allAyahs,
    double? minusHeight,
    List<List<NewAyahModel>>? currentPageAyahsSeparatedForBasmalah,
    String? tafsirAyah,
  }) {
    return ReadQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
      surahs: surahs ?? this.surahs,
      pages: pages ?? this.pages,
      allAyahs: allAyahs ?? this.allAyahs,
      minusHeight: minusHeight ?? this.minusHeight,
      // currentPageAyahsSeparatedForBasmalah:
      //     currentPageAyahsSeparatedForBasmalah ??
      //         this.currentPageAyahsSeparatedForBasmalah,
      tafsirAyah: tafsirAyah ?? this.tafsirAyah,
    );
  }

  @override
  bool operator ==(covariant ReadQuranState other) {
    if (identical(this, other)) return true;

    return other.loadQuranState == loadQuranState &&
        other.surahs == surahs &&
        other.pages == pages &&
        other.allAyahs == allAyahs &&
        other.minusHeight == minusHeight &&
        other.tafsirAyah == tafsirAyah;
    // other.currentPageAyahsSeparatedForBasmalah ==
    //     currentPageAyahsSeparatedForBasmalah;
  }

  @override
  int get hashCode =>
      loadQuranState.hashCode ^
      surahs.hashCode ^
      pages.hashCode ^
      allAyahs.hashCode ^
      minusHeight.hashCode ^
      tafsirAyah.hashCode
      // currentPageAyahsSeparatedForBasmalah.hashCode;
      ;

  List<List<NewAyahModel>> getCurrentPageAyahsSeparatedForBasmalah(
    int pageIndex,
  ) =>
      pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<NewAyahModel> getCurrentPageAyahs(int pageIndex) => pages[pageIndex];

  int getSurahNumberFromPage(int pageNumber) =>
      getCurrentSurahByPage(pageNumber).surahNumber;

  NewSurahModel getCurrentSurahByPage(int pageNumber) => surahs.firstWhere(
        (s) => allAyahs.contains(getCurrentPageAyahs(pageNumber).first),
      );

  String getSurahNameFromPage(int pageNumber) {
    try {
      return surahs
          .firstWhere(
            (s) => s.surahNumber == getSurahNumberFromPage(pageNumber),
          )
          .nameAr;
    } catch (e) {
      return 'Surah not found';
    }
  }

  String getSurahNameByPageIndex(int pageIndex) {
    if (pages.isEmpty || pageIndex < 0 || pageIndex >= pages.length) return '';
    final pageAyahs = pages[pageIndex];
    if (pageAyahs.isEmpty) return '';
    final surahId = pageAyahs.first.surahId;
    final surah = surahs.firstWhere(
      (s) => s.surahNumber == surahId,
      orElse: () => NewSurahModel(
        id: 0,
        nameAr: '',
        nameEn: '',
        translation: '',
        revelationType: '',
        ayahCount: 0,
        surahNumber: 0,
      ),
    );
    return surah.nameAr;
  }

  int getSurahNumberByAyah(NewAyahModel ayah) =>
      surahs.firstWhere((s) => s.surahNumber == ayah.surahId).surahNumber;

  NewSurahModel getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.surahNumber == ayah);

  NewAyahModel getJuzByPage(int page) =>
      allAyahs.firstWhere((a) => a.page == page + 1);

  String getSurahByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.surahNumber == ayah).nameAr;

  List<NewAyahModel> getAyahsBySurahNumber(int surahNumber) {
    return allAyahs.where((a) => a.surahId == surahNumber).toList()
      ..sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));
  }

  int? getFirstPageOfSurah(int surahNumber, {int? ayahNumber = 1}) {
    try {
      final firstAyah = allAyahs.firstWhere(
        (a) => a.surahId == surahNumber && a.ayahNumber == ayahNumber,
        orElse: () => NewAyahModel(
          id: 0,
          surahId: 0,
          numberGlobal: 0,
          ayahNumber: 0,
          text: '',
        ),
      );
      return firstAyah.page! - 1;
    } catch (_) {
      return null;
    }
  }

  List<int> get downThePageIndex => [
        75,
        206,
        330,
        340,
        348,
        365,
        375,
        413,
        416,
        434,
        444,
        451,
        497,
        505,
        524,
        547,
        554,
        556,
        583,
      ];
  List<int> get topOfThePageIndex => [
        76,
        207,
        331,
        341,
        349,
        366,
        376,
        414,
        417,
        435,
        445,
        452,
        498,
        506,
        525,
        548,
        554,
        555,
        557,
        583,
        584,
      ];
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<List<T>> splitBetween(bool Function(T first, T second) test) =>
      splitBetweenIndexed((_, first, second) => test(first, second));

  Iterable<List<T>> splitBetweenIndexed(
    bool Function(int index, T first, T second) test,
  ) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    var previous = iterator.current;
    var chunk = <T>[previous];
    var index = 1;
    while (iterator.moveNext()) {
      final element = iterator.current;
      if (test(index++, previous, element)) {
        yield chunk;
        chunk = [];
      }
      chunk.add(element);
      previous = element;
    }
    yield chunk;
  }
}
