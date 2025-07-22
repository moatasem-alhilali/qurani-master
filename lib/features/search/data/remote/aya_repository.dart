import 'package:flutter/material.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/read_quran/data/data_source/old_data_client.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:sqflite/sqflite.dart';

class AyaRepository {
  Future<Database?> getDatabase() async {
    try {
      // DataBaseClient dataBaseClient = DataBaseClient();

      return await sl.get<OldDataBaseClient>().database;
    } catch (e) {
      throw DatabaseException('Database connection failed: $e');
    }
  }

  Future<List<Aya>> search(String text, int pageSize, int pageNumber) async {
    final database = await getDatabase();
    if (database == null) throw DatabaseException('Database is not available');

    final ayaList = <Aya>[];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      final searchTextReplace = text.replaceAll('ة', 'ه');
      final searchTextReplaceReverse = text.replaceAll('ه', 'ة');

      // Perform the query without using a transaction for a read-only operation.
      final List<Map<String, dynamic>> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        where:
            'SearchText LIKE ? OR SearchText LIKE ? OR PageNum = ? OR SoraNameSearch LIKE ? OR SoraName_En LIKE ?',
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
      for (final result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print('Error in search: $e');
      throw DatabaseException('An error occurred during the search operation.');
    }

    return ayaList;
  }

  Future<List<Aya>> surahSearch(String text) async {
    // Attempt to get a database instance.
    final database = await sl.get<OldDataBaseClient>().database;
    if (database == null) {
      throw DatabaseException('Database connection failed.');
    }

    final ayaList = <Aya>[];
    try {
      // Prepare the search text by replacing specific characters for broader matching.
      final searchTextReplace = text.replaceAll('ة', 'ه');

      // Perform the query without using a transaction for a read-only operation.
      final List<Map<String, dynamic>> results = await database.query(
        Aya.tableName,
        columns: Aya.columns,
        // Corrected WHERE clause to start with a valid condition
        where:
            'SoraNameSearch LIKE ? OR SoraName_En LIKE ? OR PageNum = ? OR SoraNum = ?',
        whereArgs: ['%$searchTextReplace%', '%$text%', text, text],
      );

      // Convert the query results into a list of Aya objects.
      for (final result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    } catch (e) {
      // Log the error and rethrow a more generic exception to avoid leaking details.
      print('Error in search: $e');
      throw DatabaseException('An error occurred during the search operation.');
    }

    return ayaList;
  }

  Future<List<Aya>> fetchAyahsByPage(int offset, int limit) async {
    final database = await sl.get<OldDataBaseClient>().database;
    final ayaList = <Aya>[];

    // This SQL query will fetch a limited number of Ayahs, starting from an offset.
    // It assumes that you have a way to order the Ayahs consistently.
    await database!.transaction((txn) async {
      final List<Map<String, dynamic>> results = await txn.rawQuery(
        'SELECT * FROM ${Aya.tableName} ORDER BY some_order_column LIMIT ? OFFSET ?',
        [limit, offset],
      );
      for (final result in results) {
        ayaList.add(Aya.fromMap(result));
      }
    });

    return ayaList;
  }
}

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
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

  final buffer = StringBuffer();
  final indexMapping = <int,
      int>{}; // Ensure indexMapping is declared if not already globally declared
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    final mappedChar = diacriticsMap[char];
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

  final lineWithoutDiacritics = removeDiacritics(line);
  final searchTermWithoutDiacritics = removeDiacritics(searchTextEditing);

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

String convertArabicToEnglishNumbers(String input) {
  const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
  const englishNumbers = '0123456789';

  return input.split('').map((char) {
    final index = arabicNumbers.indexOf(char);
    if (index != -1) {
      return englishNumbers[index];
    }
    return char;
  }).join();
}
