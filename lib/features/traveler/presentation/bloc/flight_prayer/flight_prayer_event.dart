part of 'flight_prayer_bloc.dart';

sealed class FlightPrayerEvent {}

class SearchFlightEvent extends FlightPrayerEvent {
  SearchFlightEvent(this.rawFlightNumber);
  final String rawFlightNumber;
}
