import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class QuranReadHelper {
  bool isSelected = false;
  List<Surah> surahs = [];
  List<List<AyahQuranModel>> pages = [];
  List<AyahQuranModel> allAyahs = [];

  Future<void> loadQuran() async {
    final jsonString = await rootBundle.loadString('assets/json/quranV2.json');
    final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;
    final surahsJson = jsonResponse['data']['surahs'] as List<dynamic>;
    surahs = surahsJson
        .map((s) => Surah.fromJson(s as Map<String, dynamic>))
        .toList();

    for (final surah in surahs) {
      allAyahs.addAll(surah.ayahs);
      // log('Added ${surah.arabicName} ayahs');
      // update();
    }
    List.generate(604, (pageIndex) {
      pages.add(allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList());
    });
    log('Pages Length: ${pages.length}', name: 'Quran Controller');
  }

  //
  static String getTafsirAyah({required int ayah, required int surahNumber}) {
    const ayahTafsir = '';
    // for (final element in tafsir) {
    //   //
    //   if (element['aya'] == ayah && element['sura'] == surahNumber) {
    //     ayahTafsir = element['text'] as String;
    //   }
    // }
    return ayahTafsir;
  }

  // List<List<AyahQuranModel>> getCurrentPageAyahsSeparatedForBasmalah(
  //   int pageIndex,
  // ) =>
  //     pages[pageIndex]
  //         .splitBetween((f, s) => f.ayahNumber > s.ayahNumber)
  //         .toList();

  List<AyahQuranModel> getCurrentPageAyahs(int pageIndex) => pages[pageIndex];

  int getSurahNumberFromPage(int pageNumber) => surahs
      .firstWhere(
        (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first),
      )
      .surahNumber;

  Surah getCurrentSurahByPage(int pageNumber) => surahs.firstWhere(
        (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first),
      );

  String getSurahNameFromPage(int pageNumber) {
    try {
      return surahs
          .firstWhere(
            (s) => s.ayahs.contains(getCurrentPageAyahs(pageNumber).first),
          )
          .arabicName;
    } catch (e) {
      return 'Surah not found';
    }
  }

  int getSurahNumberByAyah(AyahQuranModel ayah) =>
      surahs.firstWhere((s) => s.ayahs.contains(ayah)).surahNumber;

  Surah getSurahDataByAyahUQ(int ayah) =>
      surahs.firstWhere((s) => s.ayahs.any((a) => a.ayahUQNumber == ayah));

  AyahQuranModel getJuzByPage(int page) =>
      allAyahs.firstWhere((a) => a.page == page + 1);

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
    583,
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
    584,
  ];
}
