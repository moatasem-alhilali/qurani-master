import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_built_in_override.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_custom_preference.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:sqflite/sqflite.dart';

class FloatingAdhkarDatabaseService {
  FloatingAdhkarDatabaseService();

  final DatabaseService _db = DatabaseService();

  static const String settingsTable = DatabaseTables.floatingAdhkarSettings;
  static const String customPreferencesTable =
      DatabaseTables.floatingAdhkarCustomPreferences;
  static const String builtInOverridesTable =
      DatabaseTables.floatingAdhkarBuiltInOverrides;

  Future<FloatingAdhkarSettings?> getSettings() async {
    final rows = await _db.get(settingsTable, limit: 1);
    if (rows.isEmpty) {
      return null;
    }
    return FloatingAdhkarSettings.fromMap(rows.first);
  }

  Future<void> upsertSettings(FloatingAdhkarSettings settings) async {
    final db = await _db.database;
    await db.insert(
      settingsTable,
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FloatingAdhkarCustomPreference>> getCustomPreferences() async {
    final rows = await _db.get(customPreferencesTable);
    return rows.map(FloatingAdhkarCustomPreference.fromMap).toList();
  }

  Future<Map<int, bool>> getCustomSelectionMap() async {
    final items = await getCustomPreferences();
    return {
      for (final item in items) item.subihId: item.isEnabled,
    };
  }

  Future<void> upsertCustomPreference(
    FloatingAdhkarCustomPreference preference,
  ) async {
    final db = await _db.database;
    await db.insert(
      customPreferencesTable,
      preference.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCustomPreference(int subihId) async {
    final db = await _db.database;
    await db.delete(
      customPreferencesTable,
      where: 'subih_id = ?',
      whereArgs: [subihId],
    );
  }

  Future<List<FloatingAdhkarBuiltInOverride>> getBuiltInOverrides() async {
    final rows = await _db.get(builtInOverridesTable);
    return rows.map(FloatingAdhkarBuiltInOverride.fromMap).toList();
  }

  Future<Map<String, FloatingAdhkarBuiltInOverride>>
      getBuiltInOverrideMap() async {
    final items = await getBuiltInOverrides();
    return {
      for (final item in items) item.itemId: item,
    };
  }

  Future<void> upsertBuiltInOverride(
    FloatingAdhkarBuiltInOverride override,
  ) async {
    final db = await _db.database;
    await db.insert(
      builtInOverridesTable,
      override.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBuiltInOverride(String itemId) async {
    final db = await _db.database;
    await db.delete(
      builtInOverridesTable,
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }
}
