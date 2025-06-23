import 'package:shared_preferences/shared_preferences.dart';

/// A high-level service for accessing shared preferences with typed helpers.
/// This is a singleton service to ensure centralized, safe access to local cache.
class CacheService {
  factory CacheService() => _instance;
  CacheService._internal();
  static final CacheService _instance = CacheService._internal();

  static SharedPreferences? _prefs;

  /// Initialize the shared preferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─────────────────────────────────────────────
  // 🔐 Setters
  // ─────────────────────────────────────────────
  Future<void> setString(String key, String value) async =>
      await _prefs?.setString(key, value);

  Future<void> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  Future<void> setInt(String key, int value) async =>
      await _prefs?.setInt(key, value);

  Future<void> setDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value);

  // ─────────────────────────────────────────────
  // 🧾 Getters
  // ─────────────────────────────────────────────
  String? getString(String key) {
    final value = _prefs?.getString(key);
    return value?.toString();
  }

  bool? getBool(String key) => _prefs?.getBool(key);
  int? getInt(String key) => _prefs?.getInt(key);
  double? getDouble(String key) => _prefs?.getDouble(key);

  // ─────────────────────────────────────────────
  // 🧹 Clear/Delete
  // ─────────────────────────────────────────────
  Future<void> remove(String key) async => await _prefs?.remove(key);
  Future<void> clear() async => await _prefs?.clear();
}
