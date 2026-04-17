part of 'flight_prayer_bloc.dart';

sealed class FlightPrayerState {
  const FlightPrayerState({required this.remainingAttempts});
  final int remainingAttempts;
}

class FlightPrayerInitial extends FlightPrayerState {
  const FlightPrayerInitial({required super.remainingAttempts});
}

class FlightPrayerLoading extends FlightPrayerState {
  const FlightPrayerLoading({required super.remainingAttempts});
}

class FlightPrayerSuccess extends FlightPrayerState {
  const FlightPrayerSuccess({
    required this.result,
    required super.remainingAttempts,
  });
  final FlightPrayerTimelineResult result;
}

class FlightPrayerFailure extends FlightPrayerState {
  const FlightPrayerFailure({
    required this.errorMessage,
    required super.remainingAttempts,
  });
  final String errorMessage;
}
