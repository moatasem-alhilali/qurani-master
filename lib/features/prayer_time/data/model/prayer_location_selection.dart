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

  /// اسم المكان مؤهَّلًا بمنطقته الإدارية — لعرضه خارج التطبيق.
  ///
  /// [label] يأخذ المدينة وحدها فأصبح «الرياض»، وهو ملتبس: يقرأه المستخدم
  /// فلا يدري أهي المدينة أم المنطقة أم موضع آخر بالاسم نفسه. وهذا يهمّ حيث
  /// لا سياق حول النصّ يوضّحه — كشريط الإشعارات. مستهلكه الآن هو إشعار
  /// الأذان؛ وودجات الشاشة لا تزال على [label] لضيق مساحتها.
  ///
  /// القاعدة:
  /// • «الرياض» + «منطقة الرياض» ← «منطقة الرياض»
  ///   (المنطقة تحوي اسم المدينة، فذكرهما معًا تكرار)
  /// • «الدرعية» + «منطقة الرياض» ← «الدرعية، منطقة الرياض»
  ///   (اسمان مختلفان، وكلٌّ يضيف معنى)
  ///
  /// ويعود إلى ما توفّر — [label] ثم الدولة — إن لم يعطِ الترميز الجغرافي
  /// منطقةً إدارية.
  String get qualifiedLabel {
    final city = (locality ?? '').trim();
    final area = (administrativeArea ?? '').trim();

    if (city.isNotEmpty && area.isNotEmpty) {
      if (area.contains(city) || city.contains(area)) {
        return area.length >= city.length ? area : city;
      }
      return '$city، $area';
    }

    if (area.isNotEmpty) return area;
    if (city.isNotEmpty) return city;

    final fallback = label.trim();
    if (fallback.isNotEmpty) return fallback;

    return (country ?? '').trim();
  }

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
