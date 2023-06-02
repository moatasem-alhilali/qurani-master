import 'package:quran/quran_text.dart';
import 'package:quran_app/core/shared/resources/normalise.dart';
import 'package:quran_app/features/search_ayah/model/search_ayah_model.dart';
import 'package:quran/quran.dart' as quran;

class SearchController {
  //search Words
  static Future<List<SearchAyahResultModel>> searchWords(String ayh) async {
    //normalised ayh
    String normalisedWord = normalise(ayh).trim();

    //the data result
    List<SearchAyahResultModel> result = [];

    //loop in every ayh in quran
    for (var i in quranText) {
      String normalisedVWord = normalise(i['content']);
      bool exist = false;

      //loop in ayh word
      if (normalisedVWord.contains(normalisedWord) &&
          normalisedVWord.startsWith(normalisedWord)) {
        exist = true;
      }

      if (exist) {
        SearchAyahResultModel searchAyahResultModel = SearchAyahResultModel(
            NameSurah: quran.getSurahNameArabic(i["surah_number"]),
            ayah: i["content"],
            numberOfAyah: i["verse_number"],
            page: quran.getPageNumber(i['surah_number'], i["verse_number"]));
        result.add(
          searchAyahResultModel,
        );
      }
    }
    //

    return result;
  }

  static Future<List<Map>> searchAyahInSurah({
    required int surahNumber,
    required String ayah,
  }) async {
    List<Map> result = [];

    //normalised ayh
    String normalisedWord = normalise(ayah).trim();
    //Surah Verse Count
    int SurahVerseCount = quran.getVerseCount(surahNumber);
    //Surah Verse
    // int SurahVerse = quran.getVerseCount(surahNumber);
    for (int i = 1; i < SurahVerseCount; i++) {
      String normalisedVWord = normalise(quran.getVerse(surahNumber, i));
      bool exist = false;
      //loop in ayh word
      if (normalisedVWord.contains(normalisedWord) &&
          normalisedVWord.startsWith(normalisedWord)) {
        exist = true;
      }

      if (exist) {
        result.add(
          {
            "pageNumber": quran.getPageNumber(surahNumber, i),
            "ayah": quran.getVerse(surahNumber, i),
          },
        );
      }
    }

    return result;
  }
}
