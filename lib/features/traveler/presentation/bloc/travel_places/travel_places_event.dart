part of 'travel_places_bloc.dart';

sealed class TravelPlacesEvent {}

class BootstrapPlacesEvent extends TravelPlacesEvent {}

class LoadNearbyPlacesEvent extends TravelPlacesEvent {}

class SelectPlaceEvent extends TravelPlacesEvent {
  SelectPlaceEvent(this.place);
  final TravelerPlace place;
}

class ChangeRadiusEvent extends TravelPlacesEvent {
  ChangeRadiusEvent(this.radius);
  final int radius;
}
