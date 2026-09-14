import 'package:adhan/adhan.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';

/// تخزين واسترجاع إعدادات حساب المواقيت التي يختارها المستخدم.
///
/// القراءة متزامنة لأن حساب المواقيت يجري في أماكن لا تحتمل الانتظار،
/// منها عزلة الخلفية الخاصة بودجات الشاشة الرئيسية.
class PrayerCalculationSettingsStore {
  PrayerCalculationSettingsStore({CacheService? cacheService})
      : _cacheService = cacheService ?? CacheService();

  static const _methodKey = 'prayer_calculation_method';
  static const _madhabKey = 'prayer_calculation_madhab';
  static const _highLatitudeKey = 'prayer_calculation_high_latitude_rule';
  static const _ramadanIshaKey = 'prayer_calculation_ramadan_isha_adjustment';
  static const _fajrAdjustmentKey = 'prayer_calculation_adjustment_fajr';
  static const _sunriseAdjustmentKey = 'prayer_calculation_adjustment_sunrise';
  static const _dhuhrAdjustmentKey = 'prayer_calculation_adjustment_dhuhr';
  static const _asrAdjustmentKey = 'prayer_calculation_adjustment_asr';
  static const _maghribAdjustmentKey = 'prayer_calculation_adjustment_maghrib';
  static const _ishaAdjustmentKey = 'prayer_calculation_adjustment_isha';
  static const _customFajrAngleKey = 'prayer_calculation_custom_fajr_angle';
  static const _customIshaModeKey = 'prayer_calculation_custom_isha_mode';
  static const _customIshaAngleKey = 'prayer_calculation_custom_isha_angle';
  static const _customIshaIntervalKey =
      'prayer_calculation_custom_isha_interval';
  static const _customMaghribAngleKey =
      'prayer_calculation_custom_maghrib_angle';
  static const _customMaghribAngleEnabledKey =
      'prayer_calculation_custom_maghrib_angle_enabled';

  final CacheService _cacheService;

  PrayerCalculationSettings load() {
    return PrayerCalculationSettings(
      method: _readEnum(
        _cacheService.getString(_methodKey),
        CalculationMethod.values,
        PrayerCalculationSettings.defaultMethod,
      ),
      madhab: _readEnum(
        _cacheService.getString(_madhabKey),
        Madhab.values,
        PrayerCalculationSettings.defaultMadhab,
      ),
      highLatitudeOption: _readEnum(
        _cacheService.getString(_highLatitudeKey),
        PrayerHighLatitudeOption.values,
        PrayerHighLatitudeOption.auto,
      ),
      ramadanIshaAdjustmentEnabled:
          _cacheService.getBool(_ramadanIshaKey) ?? true,
      adjustments: PrayerManualAdjustments(
        fajr: _cacheService.getInt(_fajrAdjustmentKey) ?? 0,
        sunrise: _cacheService.getInt(_sunriseAdjustmentKey) ?? 0,
        dhuhr: _cacheService.getInt(_dhuhrAdjustmentKey) ?? 0,
        asr: _cacheService.getInt(_asrAdjustmentKey) ?? 0,
        maghrib: _cacheService.getInt(_maghribAdjustmentKey) ?? 0,
        isha: _cacheService.getInt(_ishaAdjustmentKey) ?? 0,
      ).clamped(),
      customAngles: PrayerCustomAngles(
        fajrAngle: _cacheService.getDouble(_customFajrAngleKey) ??
            PrayerCustomAngles.defaults.fajrAngle,
        ishaMode: _readEnum(
          _cacheService.getString(_customIshaModeKey),
          PrayerIshaMode.values,
          PrayerCustomAngles.defaults.ishaMode,
        ),
        ishaAngle: _cacheService.getDouble(_customIshaAngleKey) ??
            PrayerCustomAngles.defaults.ishaAngle,
        ishaInterval: _cacheService.getInt(_customIshaIntervalKey) ??
            PrayerCustomAngles.defaults.ishaInterval,
        maghribAngle:
            (_cacheService.getBool(_customMaghribAngleEnabledKey) ?? false)
                ? _cacheService.getDouble(_customMaghribAngleKey) ??
                    PrayerCustomAngles.minMaghribAngle
                : null,
      ).clamped(),
    );
  }

  Future<void> save(PrayerCalculationSettings settings) async {
    final adjustments = settings.adjustments.clamped();
    await _cacheService.setString(_methodKey, settings.method.name);
    await _cacheService.setString(_madhabKey, settings.madhab.name);
    await _cacheService.setString(
      _highLatitudeKey,
      settings.highLatitudeOption.name,
    );
    await _cacheService.setBool(
      _ramadanIshaKey,
      settings.ramadanIshaAdjustmentEnabled,
    );
    await _cacheService.setInt(_fajrAdjustmentKey, adjustments.fajr);
    await _cacheService.setInt(_sunriseAdjustmentKey, adjustments.sunrise);
    await _cacheService.setInt(_dhuhrAdjustmentKey, adjustments.dhuhr);
    await _cacheService.setInt(_asrAdjustmentKey, adjustments.asr);
    await _cacheService.setInt(_maghribAdjustmentKey, adjustments.maghrib);
    await _cacheService.setInt(_ishaAdjustmentKey, adjustments.isha);

    final custom = settings.customAngles.clamped();
    await _cacheService.setDouble(_customFajrAngleKey, custom.fajrAngle);
    await _cacheService.setString(_customIshaModeKey, custom.ishaMode.name);
    await _cacheService.setDouble(_customIshaAngleKey, custom.ishaAngle);
    await _cacheService.setInt(_customIshaIntervalKey, custom.ishaInterval);
    final maghribAngle = custom.maghribAngle;
    await _cacheService.setBool(
      _customMaghribAngleEnabledKey,
      maghribAngle != null,
    );
    if (maghribAngle != null) {
      await _cacheService.setDouble(_customMaghribAngleKey, maghribAngle);
    }
  }

  /// يقرأ قيمة enum مخزّنة بالاسم، ويرجع للافتراضي عند أي قيمة غير معروفة
  /// حتى لا تتعطل المواقيت بسبب إعداد قديم أو تالف.
  T _readEnum<T extends Enum>(String? name, List<T> values, T fallback) {
    if (name == null) return fallback;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}
