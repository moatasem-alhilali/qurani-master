import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class QuranReadHelperSqlite {
  Future<Database?> getDatabase() async {
    try {
      // DataBaseClient dataBaseClient = DataBaseClient();

      return await sl.get<FullQuranDataClient>().database;
    } catch (e) {
      throw Exception('Database connection failed: $e');
    }
  }

  /// جلب جميع السور (بدون كل الآيات لتقليل الذاكرة)
  Future<List<NewSurahModel>> getAllSurahs() async {
    final db = await getDatabase();
    final data = await db?.query(NewSurahModel.tableName, orderBy: 'id');
    return data?.map(NewSurahModel.fromMap).toList() ?? [];
  }

  /// جلب كل آيات سورة واحدة (مع التفسير)
  Future<List<NewAyahModel>> getAyahsOfSurah(int surahId) async {
    final db = await getDatabase();
    final data = await db?.query(
      NewAyahModel.tableName,
      where: 'surah_id = ?',
      whereArgs: [surahId],
      orderBy: 'ayah_number ASC',
    );
    return data?.map(NewAyahModel.fromMap).toList() ?? [];
  }

  /// جلب كل الآيات في صفحة واحدة (مباشرة من القاعدة)
  Future<List<NewAyahModel>> getAyahsByPage(int pageNum) async {
    final db = await getDatabase();
    final data = await db?.query(
      NewAyahModel.tableName,
      where: 'page = ?',
      whereArgs: [pageNum],
      orderBy: 'surah_id, ayah_number',
    );
    return data?.map(NewAyahModel.fromMap).toList() ?? [];
  }

  /// جلب كل صفحات المصحف بشكل كسول (على حسب الحاجة فقط)
  Future<List<List<NewAyahModel>>> getAllPages() async {
    final pages = <List<NewAyahModel>>[];

    for (var page = 1; page <= 604; page++) {
      pages.add(await getAyahsByPage(page));
    }
    return pages;
  }

  /// جلب التفسير لآية محددة
  Future<String?> getTafsirForAyah({
    required int surahId,
    required int ayahNumber,
  }) async {
    final db = await getDatabase();
    final data = await db?.query(
      NewAyahModel.tableName,
      columns: ['tafsir'],
      where: 'surah_id = ? AND ayah_number = ?',
      whereArgs: [surahId, ayahNumber],
      limit: 1,
    );
    if (data?.isEmpty ?? true) return null;
    return data!.first['tafsir'] as String?;
  }

  /// جلب اسم السورة من رقم الصفحة
  Future<String?> getSurahNameFromPage(int pageNum) async {
    final db = await getDatabase();
    final data = await db?.rawQuery(
      '''
      SELECT s.name_ar FROM ${NewSurahModel.tableName} s
      JOIN ${NewAyahModel.tableName} a ON s.id = a.surah_id
      WHERE a.page = ?
      ORDER BY a.ayah_number LIMIT 1
    ''',
      [pageNum],
    );
    if (data?.isEmpty ?? true) return null;
    return data!.first['name_ar'] as String?;
  }

  /// جلب رقم السورة من رقم الصفحة
  Future<int?> getSurahNumberFromPage(int pageNum) async {
    final db = await getDatabase();
    final data = await db?.rawQuery(
      '''
      SELECT s.id FROM ${NewSurahModel.tableName} s
      JOIN ${NewAyahModel.tableName} a ON s.id = a.surah_id
      WHERE a.page = ?
      ORDER BY a.ayah_number LIMIT 1
    ''',
      [pageNum],
    );
    if (data?.isEmpty ?? true) return null;
    return data!.first['id'] as int?;
  }

  /// جلب كل آيات القرآن (مثالي للبحث فقط، تجنب تحميل الكل للذاكرة في الاستخدام اليومي)
  Future<List<NewAyahModel>> getAllAyahs() async {
    final db = await getDatabase();
    final data =
        await db?.query(NewAyahModel.tableName, orderBy: 'number_global');
    return data?.map(NewAyahModel.fromMap).toList() ?? [];
  }

  /// جلب آية عالمية برقم عالمي
  Future<NewAyahModel?> getAyahByGlobalNumber(int numberGlobal) async {
    final db = await getDatabase();
    final data = await db?.query(
      NewAyahModel.tableName,
      where: 'number_global = ?',
      whereArgs: [numberGlobal],
      limit: 1,
    );
    if (data?.isEmpty ?? true) return null;
    return NewAyahModel.fromMap(data!.first);
  }

  /// جلب بيانات السورة (بالآيدي)
  Future<NewSurahModel?> getSurahById(int surahId) async {
    final db = await getDatabase();
    final data = await db?.query(
      NewSurahModel.tableName,
      where: 'id = ?',
      whereArgs: [surahId],
      limit: 1,
    );
    if (data?.isEmpty ?? true) return null;
    return NewSurahModel.fromMap(data!.first);
  }

  /// تقسيم آيات الصفحة مع مراعاة البسملة (مثل الوظيفة القديمة)
  Future<List<List<NewAyahModel>>> getCurrentPageAyahsSeparatedForBasmalah(
    int pageNum,
  ) async {
    final ayahs = await getAyahsByPage(pageNum);
    return _splitBetween(ayahs, (f, s) => f.ayahNumber > s.ayahNumber);
  }

  /// دالة splitBetween نفسها (مستنسخة من الاكستنشن القديم)
  List<List<NewAyahModel>> _splitBetween(
    List<NewAyahModel> items,
    bool Function(NewAyahModel, NewAyahModel) test,
  ) {
    if (items.isEmpty) return [];
    final chunks = <List<NewAyahModel>>[];
    var chunk = <NewAyahModel>[items.first];
    for (var i = 1; i < items.length; i++) {
      if (test(items[i - 1], items[i])) {
        chunks.add(chunk);
        chunk = [];
      }
      chunk.add(items[i]);
    }
    if (chunk.isNotEmpty) chunks.add(chunk);
    return chunks;
  }
}
