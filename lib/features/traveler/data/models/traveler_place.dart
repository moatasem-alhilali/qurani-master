import 'package:quran_app/l10n/l10n.dart';

enum TravelerPlaceType {
  mosque,
  halalRestaurant,
}

extension TravelerPlaceTypeX on TravelerPlaceType {
  String title(L10n l10n) {
    switch (this) {
      case TravelerPlaceType.mosque:
        return l10n.travelerNearbyMosques;
      case TravelerPlaceType.halalRestaurant:
        return l10n.travelerNearbyHalalRestaurants;
    }
  }

  String emptyMessage(L10n l10n) {
    switch (this) {
      case TravelerPlaceType.mosque:
        return l10n.travelerNoMosquesFound;
      case TravelerPlaceType.halalRestaurant:
        return l10n.travelerNoRestaurantsFound;
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

  String distanceLabel(L10n l10n) {
    if (distanceMeters < 1000) {
      return l10n.travelerDistanceMeters('${distanceMeters.round()}');
    }
    return l10n.travelerDistanceKm((distanceMeters / 1000).toStringAsFixed(1));
  }

  String walkingEtaLabel(L10n l10n) {
    final walkingMinutes = (distanceMeters / 80).round().clamp(1, 120);
    return l10n.travelerWalkingMinutes(walkingMinutes);
  }
}
