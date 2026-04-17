part of 'travel_places_bloc.dart';

class TravelPlacesState {
  const TravelPlacesState({
    required this.radiusMeters,
    this.locationContext,
    this.places = const [],
    this.selectedPlace,
    this.isLoadingLocation = true,
    this.isLoadingPlaces = false,
    this.isRestrictedForCountry = false,
    this.errorMessage,
  });

  factory TravelPlacesState.initial({required int radiusMeters}) {
    return TravelPlacesState(radiusMeters: radiusMeters);
  }

  final int radiusMeters;
  final TravelerLocationContext? locationContext;
  final List<TravelerPlace> places;
  final TravelerPlace? selectedPlace;
  final bool isLoadingLocation;
  final bool isLoadingPlaces;
  final bool isRestrictedForCountry;
  final String? errorMessage;

  TravelPlacesState copyWith({
    int? radiusMeters,
    TravelerLocationContext? locationContext,
    List<TravelerPlace>? places,
    TravelerPlace? selectedPlace,
    bool clearSelectedPlace = false,
    bool? isLoadingLocation,
    bool? isLoadingPlaces,
    bool? isRestrictedForCountry,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TravelPlacesState(
      radiusMeters: radiusMeters ?? this.radiusMeters,
      locationContext: locationContext ?? this.locationContext,
      places: places ?? this.places,
      selectedPlace: clearSelectedPlace ? null : (selectedPlace ?? this.selectedPlace),
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingPlaces: isLoadingPlaces ?? this.isLoadingPlaces,
      isRestrictedForCountry: isRestrictedForCountry ?? this.isRestrictedForCountry,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
