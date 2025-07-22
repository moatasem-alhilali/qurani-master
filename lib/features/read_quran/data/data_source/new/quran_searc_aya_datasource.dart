import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/read_quran/data/data_source/old_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class QuranSearchAyaDataSource {
  Future<Database?> getDatabase() async {
    try {
      // DataBaseClient dataBaseClient = DataBaseClient();

      return await sl.get<OldDataBaseClient>().database;
    } catch (e) {
      throw DatabaseException('Database connection failed: $e');
    }
  }

  Future<List<QuranSearchResult>> searchQuran(String query,
      {bool searchTafsir = false}) async {
    final results = <QuranSearchResult>[];
    final database = await getDatabase();
    if (database == null) throw DatabaseException('Database is not available');

    // ابحث في أسماء السور
    final surahMatches = await database.query(
      NewSurahModel.tableName,
      where: 'name_ar LIKE ? OR name_en LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    for (final s in surahMatches) {
      results.add(QuranSearchResult.surah(
        s['id'] as int,
        (s['name_ar'] as String?) ?? (s['name_en'] as String?) ?? '',
      ));
    }

    // ابحث في نصوص الآيات (أو التفسير إذا طلبت)
    final ayahCol = searchTafsir ? 'tafsir' : 'text';
    final ayahMatches = await database.query(
      NewAyahModel.tableName,
      where: '$ayahCol LIKE ?',
      whereArgs: ['%$query%'],
    );
    for (final a in ayahMatches) {
      results.add(QuranSearchResult.ayah(NewAyahModel.fromMap(a)));
    }

    return results;
  }

  /// بحث في أسماء السور فقط
  Future<List<NewSurahModel>> searchSurahs(String text) async {
    final database = await getDatabase();
    if (database == null) throw DatabaseException('Database is not available');
    final res = await database.query(
      NewSurahModel.tableName,
      where: 'name_ar LIKE ? OR name_en LIKE ?',
      whereArgs: ['%$text%', '%$text%'],
    );
    return res.map(NewSurahModel.fromMap).toList();
  }

  /// بحث في نصوص الآيات فقط (أو التفسير)
  Future<List<NewAyahModel>> searchAyahs(
    String text, {
    bool inTafsir = false,
    int pageSize = 20,
    int pageNumber = 1,
  }) async {
    final database = await getDatabase();
    if (database == null) throw DatabaseException('Database is not available');
    final col = inTafsir ? 'tafsir' : 'text';
    final res = await database.query(
      NewAyahModel.tableName,
      where: '$col LIKE ?',
      whereArgs: ['%$text%'],
      limit: pageSize,
      offset: (pageNumber - 1) * pageSize,
    );
    return res.map(NewAyahModel.fromMap).toList();
  }

  /// جلب آيات من صفحة معيّنة (Paging)
  Future<List<NewAyahModel>> fetchAyahsByPage(
    int page, {
    int pageSize = 20,
    int pageNumber = 1,
  }) async {
    final database = await getDatabase();
    if (database == null) throw DatabaseException('Database is not available');
    final res = await database.query(
      NewAyahModel.tableName,
      where: 'page = ?',
      whereArgs: [page],
      limit: pageSize,
      offset: (pageNumber - 1) * pageSize,
      orderBy: 'surah_id ASC, ayah_number ASC',
    );
    return res.map(NewAyahModel.fromMap).toList();
  }
}

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
}

List<TextSpan> highlightLine(
  String line,
  String searchTextEditing, {
  TextStyle? defaultStyle,
  TextStyle? highlightStyle,
}) {
  if (searchTextEditing.isEmpty) {
    return [TextSpan(text: line, style: defaultStyle)];
  }

  final spans = <TextSpan>[];
  var start = 0;

  final lineWithoutDiacritics = line;
  final searchTermWithoutDiacritics = searchTextEditing;

  while (start < line.length) {
    final startIndex =
        lineWithoutDiacritics.indexOf(searchTermWithoutDiacritics, start);

    if (startIndex == -1) {
      // No more matches, add the rest of the text
      if (start < line.length) {
        spans.add(
          TextSpan(
            text: line.substring(start),
            style: defaultStyle,
          ),
        );
      }
      break;
    }

    // Add text before the match
    if (startIndex > start) {
      spans.add(
        TextSpan(
          text: line.substring(start, startIndex),
          style: defaultStyle,
        ),
      );
    }

    // Add the highlighted match
    var endIndex = startIndex + searchTermWithoutDiacritics.length;
    endIndex = endIndex <= line.length ? endIndex : line.length;

    spans.add(
      TextSpan(
        text: line.substring(startIndex, endIndex),
        style: highlightStyle ??
            const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.yellow,
            ),
      ),
    );

    start = endIndex;
  }

  return spans.isNotEmpty ? spans : [TextSpan(text: line, style: defaultStyle)];
}
