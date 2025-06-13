import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:quran_app/main.dart';
import 'package:sqflite/sqflite.dart';

class AyaRepository {
  Future<Database?> getDatabase() async {
    try {
      // DataBaseClient dataBaseClient = DataBaseClient();

      return await sl.get<DataBaseClient>().database;
    } catch (e) {
      throw DatabaseException("Database connection failed: ${e.toString()}");
    }
  }

  Future<List<Aya>> search(String text, pageSize, pageNumber) async {
    final Database? database = await getDatabase();
    if (database == null) throw DatabaseException("Database is not available");

    List<Aya> ayaList = [];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      String searchTextReplace = text.replaceAll("ة", "ه");
      String searchTextReplaceReverse = text.replaceAll("ه", "ة");

      // Perform the query without using a transaction for a read-only operation.
      List<Map> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        where:
            "SearchText LIKE ? OR SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?",
        whereArgs: [
          '%$searchTextReplace%',
          '%$text%',
          text,
          '%$searchTextReplaceReverse%',
          '%$text%',
        ],
        limit: pageSize,
        offset: (pageNumber - 1) * pageSize,
      );
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print("Error in search: $e");
      throw DatabaseException("An error occurred during the search operation.");
    }

    return ayaList;
  }

  Future<List<Aya>> surahSearch(String text) async {
    // Attempt to get a database instance.
    Database? database = await sl.get<DataBaseClient>().database;
    if (database == null) {
      throw DatabaseException("Database connection failed.");
    }

    List<Aya> ayaList = [];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      String searchTextReplace = text.replaceAll("ة", "ه");

      // Perform the query without using a transaction for a read-only operation.
      List<Map> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        // Corrected WHERE clause to start with a valid condition
        where:
            "SoraNameSearch LIKE ? OR SoraName_En LIKE ? OR PageNum = ? OR SoraNum = ?",
        whereArgs: ['%$searchTextReplace%', '%$text%', text, text],
      );

      // Convert the query results into a list of Aya objects.
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print("Error in search: $e");
      throw DatabaseException("An error occurred during the search operation.");
    }

    return ayaList;
  }

  Future<List<Aya>> fetchAyahsByPage(int offset, int limit) async {
    Database? database = await sl.get<DataBaseClient>().database;
    List<Aya> ayaList = [];

    // This SQL query will fetch a limited number of Ayahs, starting from an offset.
    // It assumes that you have a way to order the Ayahs consistently.
    await database!.transaction((txn) async {
      List<Map>? results = await txn.rawQuery(
        'SELECT * FROM ${Aya.tableName} ORDER BY some_order_column LIMIT ? OFFSET ?',
        [limit, offset],
      );
      for (var result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    });

    return ayaList;
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

String removeDiacritics(String input) {
  final diacriticsMap = {
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'إٔ': 'ا',
    'إٕ': 'ا',
    'إٓ': 'ا',
    'أَ': 'ا',
    'إَ': 'ا',
    'آَ': 'ا',
    'إُ': 'ا',
    'إٌ': 'ا',
    'إً': 'ا',
    'ة': 'ه',
    'ً': '',
    'ٌ': '',
    'ٍ': '',
    'َ': '',
    'ُ': '',
    'ِ': '',
    'ّ': '',
    'ْ': '',
    'ـ': '',
    'ٰ': '',
    'ٖ': '',
    'ٗ': '',
    'ٕ': '',
    'ٓ': '',
    'ۖ': '',
    'ۗ': '',
    'ۘ': '',
    'ۙ': '',
    'ۚ': '',
    'ۛ': '',
    'ۜ': '',
    '۝': '',
    '۞': '',
    '۟': '',
    '۠': '',
    'ۡ': '',
    'ۢ': '',
  };

  StringBuffer buffer = StringBuffer();
  Map<int, int> indexMapping =
      {}; // Ensure indexMapping is declared if not already globally declared
  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    String? mappedChar = diacriticsMap[char];
    if (mappedChar != null) {
      buffer.write(mappedChar);
      if (mappedChar.isNotEmpty) {
        indexMapping[buffer.length - 1] = i;
      }
    } else {
      buffer.write(char);
      indexMapping[buffer.length - 1] = i;
    }
  }
  return buffer.toString();
}

List<TextSpan> highlightLine(String line, searchTextEditing) {
  List<TextSpan> spans = [];
  int start = 0;

  String lineWithoutDiacritics = removeDiacritics(line);
  String searchTermWithoutDiacritics = removeDiacritics(searchTextEditing);
  spans.add(TextSpan(text: line));
  while (start < lineWithoutDiacritics.length) {
    final startIndex =
        lineWithoutDiacritics.indexOf(searchTermWithoutDiacritics, start);
    if (startIndex == -1) {
      spans.add(TextSpan(
          text: line.substring(start))); // Modified to use start directly.
      break;
    }

    if (startIndex > start) {
      spans.add(TextSpan(
          text: line.substring(
              start, startIndex))); // Simplified by removing indexMapping.
    }

    int endIndex = startIndex + searchTermWithoutDiacritics.length;
    endIndex = endIndex <= line.length ? endIndex : line.length;

    spans.add(TextSpan(
      text: line.substring(startIndex, endIndex),
      style: const TextStyle(
          color: Color(0xffa24308), fontWeight: FontWeight.bold),
    ));

    start = endIndex; // Move past the end of the current match.
  }
  return spans;
}

String convertArabicToEnglishNumbers(String input) {
  const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
  const englishNumbers = '0123456789';

  return input.split('').map((char) {
    int index = arabicNumbers.indexOf(char);
    if (index != -1) {
      return englishNumbers[index];
    }
    return char;
  }).join('');
}
