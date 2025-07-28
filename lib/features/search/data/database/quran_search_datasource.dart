import 'package:flutter/material.dart';
import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class QuranSearchDataSource {
  QuranSearchDataSource(this.fullQuranDataClient);
  final FullQuranDataClient fullQuranDataClient;

  // get database
  Future<Database?> get db async {
    return fullQuranDataClient.database;
  }

  Future<List<QuranSearchResult>> searchQuran(
    String query, {
    bool searchTafsir = false,
  }) async {
    final results = <QuranSearchResult>[];
    final database = await db;
    if (database == null) throw DatabaseException('Database is not available');

    // ابحث في أسماء السور
    final surahMatches = await (await db)!.query(
      NewSurahModel.tableName,
      where: 'name_ar LIKE ? OR name_en LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    for (final s in surahMatches) {
      results.add(
        QuranSearchResult.surah(
          s['id']! as int,
          (s['name_ar'] as String?) ?? (s['name_en'] as String?) ?? '',
        ),
      );
    }

    // ابحث في نصوص الآيات (أو التفسير إذا طلبت)
    final ayahCol = searchTafsir ? 'tafsir' : 'text';
    final ayahMatches = await (await db)!.query(
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
    final database = await db;
    if (database == null) throw DatabaseException('Database is not available');
    final res = await (await db)!.query(
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
    final database = await db;
    if (database == null) throw DatabaseException('Database is not available');

    final searchTextReplace = text.replaceAll('ة', 'ه');
    final searchTextReplaceReverse = text.replaceAll('ه', 'ة');

    // قائمة الأعمدة المستهدفة
    final whereClauses = <String>[
      'text LIKE ?',
      'text_emlaey LIKE ?',
      'tafsir LIKE ?',
      'page = ?',
      'juz = ?',
      'ayah_number = ?',
    ];
    final whereArgs = <dynamic>[
      '%$text%', // نص آية
      '%$searchTextReplace%', // emlaey بعد التبديل
      '%$text%', // التفسير (لو موجود)
      int.tryParse(text) ?? -1, // البحث كرقم صفحة (لو كان رقم)
      int.tryParse(text) ?? -1, // البحث كرقم جزء
      int.tryParse(text) ?? -1, // البحث كرقم آية
    ];

    // جلب أسماء السور المطابقة من جدول السور
    final surahsResults = await database.query(
      'surahs',
      columns: ['id'],
      where: 'name_ar LIKE ? OR name_en LIKE ?',
      whereArgs: [
        '%$searchTextReplace%',
        '%$text%',
      ],
    );
    // لو وجد اسم سورة مطابق، نضيف للسؤال:
    if (surahsResults.isNotEmpty) {
      final surahIds = surahsResults.map((e) => e['id']).toList();
      whereClauses.add('surah_id IN (${surahIds.join(",")})');
    }

    final whereClause = whereClauses.join(' OR ');

    final res = await database.query(
      NewAyahModel.tableName,
      where: whereClause,
      whereArgs: whereArgs,
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
    final database = await db;
    if (database == null) throw DatabaseException('Database is not available');
    final res = await (await db)!.query(
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
