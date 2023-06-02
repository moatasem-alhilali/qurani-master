import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/jsons/tafsir.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/jsons/quran_text.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/features/quran/controller/db_helper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../presentation/model/surah_model.dart';
import 'package:quran/quran.dart' as qurans;

class ControllerQuran {
  static final ItemScrollController scrollSurahController =
      ItemScrollController();
  static final ItemPositionsListener positionsSurahListener =
      ItemPositionsListener.create();

  //

 static void scrollTo({
    required int index,
  }) async {
    try {
      await scrollSurahController.scrollTo(
        index: index,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic,
      );
    } catch (e) {
      ToastServes.showToast(message: "لا توجد ايه بهذا الرقم");
    }
  }

  //
  static late AudioPlayer audioPlayerPlayAyah;

  //load surah data
  static void loadSurah() async {
    myQuranText.forEach((element) {
      surahData.add(SurahModel.fromJson(element));
    });

    surahData.reversed.toList();
  }

  //save bookmark

  static Future<int> saveBookMark({
    required QuranBookMarkModel quranBookMarkModel,
  }) async {
    return DBHelperQuran.addBookMark(quranBookMarkModel);
  }

  //get all bookmark

  static Future<List<QuranBookMarkModel>> getBookMark() async {
    List<QuranBookMarkModel> result = [];
    final data = await DBHelperQuran.getAllBookMark();
    for (var element in data) {
      result.add(QuranBookMarkModel.fromJson(element));
    }
    return result;
  }

  //tafsir ayah
  static String getTafsirAyah({required int ayah, required int surahNumber}) {
    String ayahTafsir = "";
    tafsir.forEach((element) {
      //
      if (element['aya'] == ayah && element['sura'] == surahNumber) {
        ayahTafsir = element['text'];
      }
    });

    //return the data
    return ayahTafsir;
  }

  static List<AudioSource> audioSource = [];

  //init Player Online Listen audio Source
  static Future<void> initPlayerPlayAyah({
    required int surahNumber,
  }) async {
    //init the audio source
    audioPlayerPlayAyah = AudioPlayer();
    audioSource.clear();
    final verseCount = qurans.getVerseCount(surahNumber);

    for (int i = 1; i <= verseCount; i++) {
      final url = qurans.getAudioURLByVerse(surahNumber, i);
      print(url);
      var audio = AudioSource.uri(Uri.parse(url));
      audioSource.add(audio);
    }

    //set Audio Source
    await audioPlayerPlayAyah.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: [...audioSource],
      ),
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
  }
}
