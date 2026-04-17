import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_library/quran.dart';

class SurahDataSource {
  SurahDataSource(this.fullQuranDataClient);
  final dynamic fullQuranDataClient; // Keep for DI compatibility but unused

  List<SurahModel> get allSurahs => QuranCtrl.instance.state.surahs;

  NewSurahModel _mapToNewSurah(SurahModel s) {
    return NewSurahModel(
      id: s.surahNumber,
      surahNumber: s.surahNumber,
      nameAr: s.arabicName,
      nameEn: s.englishName,
      revelationType: s.revelationType,
      ayahCount: s.ayahs.length,
    );
  }

  Future<List<NewSurahModel>> getAllSurahs() async {
    return allSurahs.map(_mapToNewSurah).toList();
  }

  Future<NewSurahModel?> getSurahById(int surahId) async {
    try {
      final s = allSurahs.firstWhere((s) => s.surahNumber == surahId);
      return _mapToNewSurah(s);
    } catch (_) {
      return null;
    }
  }

  Future<int> getSurahsCount() async {
    return allSurahs.length;
  }

  Future<List<NewSurahModel>> searchSurahsByName(String query) async {
    final results = QuranCtrl.instance.searchSurah(query);
    return results.map(_mapToNewSurah).toList();
  }
}
