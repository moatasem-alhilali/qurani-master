class PrayerSilentModeSettings {
  const PrayerSilentModeSettings({
    required this.enabled,
    required this.durationMinutes,
  });

  static const defaultDurationMinutes = 30;

  final bool enabled;
  final int durationMinutes;

  PrayerSilentModeSettings copyWith({
    bool? enabled,
    int? durationMinutes,
  }) {
    return PrayerSilentModeSettings(
      enabled: enabled ?? this.enabled,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
