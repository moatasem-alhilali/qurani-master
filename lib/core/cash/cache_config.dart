import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/constant.dart';

/// Handles domain-specific logic related to app-level cache initialization and state.
class CacheConfig {
  // constants
  static const String subihKey = 'SUBIH';

  //
  static bool hasInitLocal = false;

  /// Initializes global settings stored in local cache (theme, last page, etc).
  static Future<void> loadConfig() async {
    await CacheService.init();
    await _loadLastPageRead();
    await _loadInitFlag();
  }

  // ─────────────────────────────────────────────
  // 🔁 Getters for Cached App State
  // ─────────────────────────────────────────────

  static Future<void> _loadLastPageRead() async {
    lastPageRead = CacheService().getInt('lastPageRead') ?? 0;
  }

  static Future<void> _loadInitFlag() async {
    hasInitLocal = CacheService().getBool('hasInitLocal') ?? false;
  }

  // ─────────────────────────────────────────────
  // 💾 Setters to Save State
  // ─────────────────────────────────────────────

  static Future<void> saveLastPageRead() async {
    await CacheService().setInt('lastPageRead', lastPageRead);
  }

  static Future<void> markInitDone() async {
    await CacheService().setBool('hasInitLocal', true);
  }
}
