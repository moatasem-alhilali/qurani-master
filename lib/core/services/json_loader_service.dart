import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoaderService {
  // constants
  static const String allahNamesPath = 'assets/json/allah_names.json';
  static const String mostReaderPath = 'assets/json/most_reader.json';
  static const String surahInfoPath = 'assets/json/surah_info.json';
  static const String wirdsPath = 'assets/json/wird_night_morning.json';
  static const String hadith40Path = 'assets/json/hadith_40.json';
  static const String zkarAfterPrayPath = 'assets/json/zkar-after-pray.json';
  static const String ruqiaShareiaPath = 'assets/json/ruqia_shareia.json';
  static const String hisnMuslimPath = 'assets/json/hisn_muslim.json';
  static const String adhkarHajjUmrahPath =
      'assets/json/adhkar_hajj_umrah.json';
  static const String adhkarSleepDreamsPath =
      'assets/json/adhkar_sleep_dreams.json';
  static const String adhkarQuranDuasPath =
      'assets/json/adhkar_quran_duas.json';
  static const String adhkarQuranicDuasPath =
      'assets/json/adhkar_quranic_duas.json';
  static const String adhkarFuneralPath = 'assets/json/adhkar_funeral.json';
  static const String adhkarSalahJumuahPath =
      'assets/json/adhkar_salah_jumuah.json';

  /// Loads and decodes a JSON list from an asset file.
  ///
  /// [assetPath] مثل: 'assets/json/allah_names.json'
  ///
  /// ترجع: `List<Map<String, dynamic>>`
  static Future<List<Map<String, dynamic>>> loadJsonList(
    String assetPath,
  ) async {
    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }

  /// Loads a single JSON object from an asset.
  static Future<Map<String, dynamic>> loadJsonObject(String assetPath) async {
    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return decoded;
    } catch (e) {
      rethrow;
    }
  }
}
