import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoaderService {
  // constants
  static const String allahNamesPath = 'assets/json/allah_names.json';
  static const String mostReaderPath = 'assets/json/most_reader.json';
  static const String surahInfoPath = 'assets/json/surah_info.json';

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
