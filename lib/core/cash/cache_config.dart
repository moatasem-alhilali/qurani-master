import 'package:quran_app/core/cash/cache_service.dart';

/// Handles domain-specific logic related to app-level cache initialization and state.
class CacheConfig {
  // constants
  static const String subihKey = 'SUBIH';
  static const String lastPageReadKey = 'LAST_PAGE_READ';

  //
  static bool hasInitLocal = false;

  /// Initializes global settings stored in local cache (theme, last page, etc).
  static Future<void> loadConfig() async {
    await CacheService.init();
    await _loadInitFlag();
  }

  // ─────────────────────────────────────────────
  // 🔁 Getters for Cached App State
  // ─────────────────────────────────────────────

  static Future<void> _loadInitFlag() async {
    hasInitLocal = CacheService().getBool('hasInitLocal') ?? false;
  }

  // ─────────────────────────────────────────────
  // 💾 Setters to Save State
  // ─────────────────────────────────────────────

  static Future<void> markInitDone() async {
    await CacheService().setBool('hasInitLocal', true);
  }
}
