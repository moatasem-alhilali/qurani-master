enum TravelerPlaceType {
  mosque,
  halalRestaurant,
}

extension TravelerPlaceTypeX on TravelerPlaceType {
  String get title {
    switch (this) {
      case TravelerPlaceType.mosque:
        return 'المساجد القريبة';
      case TravelerPlaceType.halalRestaurant:
        return 'مطاعم حلال قريبة';
    }
  }

  String get emptyMessage {
    switch (this) {
      case TravelerPlaceType.mosque:
        return 'لم نعثر على مساجد في النطاق الحالي.';
      case TravelerPlaceType.halalRestaurant:
        return 'لم نعثر على مطاعم حلال في هذا النطاق.';
    }
  }

  String get queryLabel {
    switch (this) {
      case TravelerPlaceType.mosque:
        return 'Mosque';
      case TravelerPlaceType.halalRestaurant:
        return 'Halal Restaurant';
    }
  }
}

class TravelerPlace {
  const TravelerPlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.address,
    this.phone,
    this.openingHours,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final String address;
  final String? phone;
  final String? openingHours;

  String get distanceLabel {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} م';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)} كم';
  }

  String get walkingEtaLabel {
    final walkingMinutes = (distanceMeters / 80).round().clamp(1, 120);
    return '$walkingMinutes دقيقة مشيًا';
  }
}
