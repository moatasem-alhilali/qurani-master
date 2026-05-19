import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_silent_mode_settings.dart';

class PrayerSilentModeSettingsStore {
  PrayerSilentModeSettingsStore({
    CacheService? cacheService,
  }) : _cacheService = cacheService ?? CacheService();

  static const _enabledKey = 'prayer_silent_mode_enabled';
  static const _durationMinutesKey = 'prayer_silent_mode_duration_minutes';

  final CacheService _cacheService;

  PrayerSilentModeSettings load() {
    return PrayerSilentModeSettings(
      enabled: _cacheService.getBool(_enabledKey) ?? false,
      durationMinutes: _cacheService.getInt(_durationMinutesKey) ??
          PrayerSilentModeSettings.defaultDurationMinutes,
    );
  }

  Future<void> save(PrayerSilentModeSettings settings) async {
    await _cacheService.setBool(_enabledKey, settings.enabled);
    await _cacheService.setInt(
      _durationMinutesKey,
      settings.durationMinutes.clamp(1, 360),
    );
  }
}
