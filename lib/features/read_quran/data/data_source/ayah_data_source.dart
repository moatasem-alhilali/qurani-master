import 'dart:math';

import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_library/quran.dart';

class AyahDataSource {
  AyahDataSource(this.fullQuranDataClient);
  final dynamic fullQuranDataClient; // Keep for DI compatibility but unused

  List<AyahModel> get _allAyahs {
    // Prefer the explicitly populated List from loadQuranDataV1 as it has better metadata (surahNumber, etc.)
    if (QuranCtrl.instance.ayahs.isNotEmpty) return QuranCtrl.instance.ayahs;
    return QuranCtrl.instance.state.allAyahs;
  }

  NewAyahModel _mapToNewAyah(AyahModel a) {
    return NewAyahModel(
      id: a.ayahUQNumber,
      surahId: a.surahNumber ?? 0,
      numberGlobal: a.ayahUQNumber,
      ayahNumber: a.ayahNumber,
      text: a.text,
      textEmlaey: a.ayaTextEmlaey,
      page: a.page,
      juz: a.juz,
      hizb: a.hizb,
      sajda: a.sajda != null ? 1 : 0,
    );
  }

  Future<List<NewAyahModel>> getAyahsBySurah(
    int surahId, {
    int? limit,
    int? offset,
  }) async {
    final filtered = _allAyahs.where((a) => a.surahNumber == surahId).toList();
    filtered.sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));

    var result = filtered;
    if (offset != null) result = result.skip(offset).toList();
    if (limit != null) result = result.take(limit).toList();

    return result.map(_mapToNewAyah).toList();
  }

  Future<NewAyahModel?> getAyah(int surahId, int ayahNumber) async {
    try {
      final a = _allAyahs.firstWhere(
        (a) => a.surahNumber == surahId && a.ayahNumber == ayahNumber,
      );
      return _mapToNewAyah(a);
    } catch (_) {
      return null;
    }
  }

  Future<NewAyahModel?> getAyahById(int id) async {
    try {
      final a = _allAyahs.firstWhere((a) => a.ayahUQNumber == id);
      return _mapToNewAyah(a);
    } catch (_) {
      return null;
    }
  }

  Future<NewAyahModel?> getRandomAyah() async {
    if (_allAyahs.isEmpty) return null;
    final randomIndex = Random().nextInt(_allAyahs.length);
    return _mapToNewAyah(_allAyahs[randomIndex]);
  }

  Future<List<NewAyahModel>> searchAyahs(
    String query, {
    bool inTafsir = false,
    int? limit,
    int? offset,
  }) async {
    final results = QuranCtrl.instance.search(query);

    var result = results;
    if (offset != null) result = result.skip(offset).toList();
    if (limit != null) result = result.take(limit).toList();

    return result.map(_mapToNewAyah).toList();
  }

  Future<int> getAyahCountBySurah(int surahId) async {
    return _allAyahs.where((a) => a.surahNumber == surahId).length;
  }

  Future<int> getTotalAyahCount() async {
    return _allAyahs.length;
  }

  Future<NewAyahModel?> getAyahByGlobalIndex(int globalIndex) async {
    return getAyahById(globalIndex);
  }

  Future<List<NewAyahModel>> getAyahsByPage(
    int page, {
    int? limit,
    int? offset,
  }) async {
    final filtered = _allAyahs.where((a) => a.page == page).toList();
    filtered.sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));

    var result = filtered;
    if (offset != null) result = result.skip(offset).toList();
    if (limit != null) result = result.take(limit).toList();

    return result.map(_mapToNewAyah).toList();
  }

  Future<List<NewAyahModel>> getAyahsByJuz(
    int juz, {
    int? limit,
    int? offset,
  }) async {
    final filtered = _allAyahs.where((a) => a.juz == juz).toList();
    filtered.sort((a, b) => a.ayahUQNumber.compareTo(b.ayahUQNumber));

    var result = filtered;
    if (offset != null) result = result.skip(offset).toList();
    if (limit != null) result = result.take(limit).toList();

    return result.map(_mapToNewAyah).toList();
  }

  Future<List<NewAyahModel>> getAyahsWithSajda() async {
    final filtered =
        _allAyahs.where((a) => a.sajda != null && a.sajda != false).toList();
    return filtered.map(_mapToNewAyah).toList();
  }

  Future<List<NewAyahModel>> getAyahsByJuzRange(int fromJuz, int toJuz) async {
    final filtered =
        _allAyahs.where((a) => a.juz >= fromJuz && a.juz <= toJuz).toList();
    filtered.sort((a, b) => a.ayahUQNumber.compareTo(b.ayahUQNumber));
    return filtered.map(_mapToNewAyah).toList();
  }
}
