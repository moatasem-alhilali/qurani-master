import 'dart:math';

import 'package:quran_app/features/read_quran/data/data_source/full_quran_data_client.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class AyahDataSource {
  AyahDataSource(this.fullQuranDataClient);
  final FullQuranDataClient fullQuranDataClient;

  // get database
  Future<Database?> get db async {
    return fullQuranDataClient.database;
  }

  Future<List<NewAyahModel>> getAyahsBySurah(
    int surahId, {
    int? limit,
    int? offset,
  }) async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'surah_id = ?',
      whereArgs: [surahId],
      orderBy: 'ayah_number ASC',
      limit: limit,
      offset: offset,
    );
    return result.map(NewAyahModel.fromMap).toList();
  }

  Future<NewAyahModel?> getAyah(int surahId, int ayahNumber) async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'surah_id = ? AND ayah_number = ?',
      whereArgs: [surahId, ayahNumber],
    );
    return result.isNotEmpty ? NewAyahModel.fromMap(result.first) : null;
  }

  Future<NewAyahModel?> getAyahById(int id) async {
    final result =
        await (await db)!.query('ayahs', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? NewAyahModel.fromMap(result.first) : null;
  }

  // get random ayah from database
  Future<NewAyahModel?> getRandomAyah() async {
    final dbInstance = await db;
    final countRes =
        await dbInstance!.rawQuery('SELECT COUNT(*) as c FROM ayahs');
    final total = countRes.isNotEmpty ? (countRes.first['c']! as int) : 0;
    if (total == 0) return null;

    final randomIndex = Random().nextInt(total);

    final result = await dbInstance.query(
      'ayahs',
      orderBy: 'id ASC',
      limit: 1,
      offset: randomIndex,
    );
    return result.isNotEmpty ? NewAyahModel.fromMap(result.first) : null;
  }

  Future<List<NewAyahModel>> searchAyahs(
    String query, {
    bool inTafsir = false,
    int? limit,
    int? offset,
  }) async {
    final col = inTafsir ? 'tafsir' : 'text';
    final result = await (await db)!.query(
      'ayahs',
      where: '$col LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: limit,
      offset: offset,
    );
    return result.map(NewAyahModel.fromMap).toList();
  }

  Future<int> getAyahCountBySurah(int surahId) async {
    final res = await (await db)!.rawQuery(
      'SELECT COUNT(*) as c FROM ayahs WHERE surah_id=?',
      [surahId],
    );
    return res.isNotEmpty ? (res.first['c']! as int) : 0;
  }

  Future<int> getTotalAyahCount() async {
    final res = await (await db)!.rawQuery('SELECT COUNT(*) as c FROM ayahs');
    return res.isNotEmpty ? (res.first['c']! as int) : 0;
  }

  /// جلب آية بناء على رقمها المطلق في القرآن (من 1 إلى 6236)
  Future<NewAyahModel?> getAyahByGlobalIndex(int globalIndex) async {
    final result = await (await db)!
        .query('ayahs', where: 'id = ?', whereArgs: [globalIndex]);
    return result.isNotEmpty ? NewAyahModel.fromMap(result.first) : null;
  }

  /// جلب آيات حسب الصفحة
  Future<List<NewAyahModel>> getAyahsByPage(
    int page, {
    int? limit,
    int? offset,
  }) async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: limit,
      offset: offset,
    );
    return result.map(NewAyahModel.fromMap).toList();
  }

  /// جلب آيات حسب الجزء
  Future<List<NewAyahModel>> getAyahsByJuz(
    int juz, {
    int? limit,
    int? offset,
  }) async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'juz = ?',
      whereArgs: [juz],
      orderBy: 'surah_id ASC, ayah_number ASC',
      limit: limit,
      offset: offset,
    );
    return result.map(NewAyahModel.fromMap).toList();
  }

  /// جلب كل الآيات التي فيها سجدة
  Future<List<NewAyahModel>> getAyahsWithSajda() async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'sajda > 0',
      orderBy: 'surah_id ASC, ayah_number ASC',
    );
    return result.map(NewAyahModel.fromMap).toList();
  }

  /// جلب جميع آيات النطاق
  Future<List<NewAyahModel>> getAyahsByJuzRange(int fromJuz, int toJuz) async {
    final result = await (await db)!.query(
      'ayahs',
      where: 'juz >= ? AND juz <= ?',
      whereArgs: [fromJuz, toJuz],
      orderBy: 'id ASC',
    );
    return result.map(NewAyahModel.fromMap).toList();
  }
}
