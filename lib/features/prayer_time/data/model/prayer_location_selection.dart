enum PrayerLocationSource {
  device,
  manualSearch,
  manualMap,
}

class PrayerLocationSelection {
  const PrayerLocationSelection({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.source,
    required this.utcOffsetMinutes,
    this.locality,
    this.administrativeArea,
    this.country,
  });

  final double latitude;
  final double longitude;
  final String label;
  final PrayerLocationSource source;
  final int utcOffsetMinutes;
  final String? locality;
  final String? administrativeArea;
  final String? country;

  bool get isManual => source != PrayerLocationSource.device;

  String get detailsLabel {
    final parts = <String>[
      if ((locality ?? '').trim().isNotEmpty) locality!.trim(),
      if ((administrativeArea ?? '').trim().isNotEmpty)
        administrativeArea!.trim(),
      if ((country ?? '').trim().isNotEmpty) country!.trim(),
    ];

    return parts.join('، ');
  }

  PrayerLocationSelection copyWith({
    double? latitude,
    double? longitude,
    String? label,
    PrayerLocationSource? source,
    int? utcOffsetMinutes,
    String? locality,
    String? administrativeArea,
    String? country,
  }) {
    return PrayerLocationSelection(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      label: label ?? this.label,
      source: source ?? this.source,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      locality: locality ?? this.locality,
      administrativeArea: administrativeArea ?? this.administrativeArea,
      country: country ?? this.country,
    );
  }

  static PrayerLocationSource sourceFromStorage(String? value) {
    return PrayerLocationSource.values.firstWhere(
      (source) => source.name == value,
      orElse: () => PrayerLocationSource.device,
    );
  }
}
