import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:quran_app/core/jsons/tafsir.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';

class QuranReadHelper {
  bool isSelected = false;
  List<Surah> surahs = [];
  List<List<Ayah>> pages = [];
  List<Ayah> allAyahs = [];

  //
 static  String getTafsirAyah({required int ayah, required int surahNumber}) {
    String ayahTafsir = "";
    for (var element in tafsir) {
      //
      if (element['aya'] == ayah && element['sura'] == surahNumber) {
        ayahTafsir = element['text'];
      }
    }
        return ayahTafsir;

  }

  Future<void> loadQuran() async {
    String jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    List<dynamic> surahsJson = jsonResponse['data']['surahs'];
    surahs = surahsJson.map((s) => Surah.fromJson(s)).toList();

    for (final surah in surahs) {
      allAyahs.addAll(surah.ayahs);
      log('Added ${surah.arabicName} ayahs');
      // update();
    }
    List.generate(604, (pageIndex) {
      pages.add(allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    log('Pages Length: ${pages.length}', name: 'Quran Controller');
  }

  List<List<Ayah>> getCurrentPageAyahsSeparatedForBasmalah(int pageIndex) =>
      pages[pageIndex]
          .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
          .toList();

  List<Ayah> getCurrentPageAyahs(int pageIndex) => pages[pageIndex];

  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
          (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first))
      .surahNumber;

  Surah getCurrentSurahByPage(int pageNumber) => surahs.firstWhere(
      (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first));

  String getSurahNameFromPage(int pageNumber) {
    try {
      return surahs
          .firstWhere(
              (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first))
          .arabicName;
    } catch (e) {
      return "Surah not found";
    }
  }

  int getSurahNumberByAyah(Ayah ayah) =>
      surahs.firstWhere((s) => s.ayahs.contains(ayah)).surahNumber;

  Surah getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  Ayah getJuzByPage(int page) => allAyahs.firstWhere((a) => a.page == page + 1);

  String getSurahByAyahUQ(int ayah) => surahs
      .firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah))
      .arabicName;
  List<int> downThePageIndex = [
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
    583
  ];
  List<int> topOfThePageIndex = [
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
    584
  ];
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<List<T>> splitBetween(bool Function(T first, T second) test) =>
      splitBetweenIndexed((_, first, second) => test(first, second));

  Iterable<List<T>> splitBetweenIndexed(
      bool Function(int index, T first, T second) test) sync* {
    var iterator = this.iterator;
    if (!iterator.moveNext()) return;
    var previous = iterator.current;
    var chunk = <T>[previous];
    var index = 1;
    while (iterator.moveNext()) {
      var element = iterator.current;
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
