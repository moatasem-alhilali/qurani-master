part of 'travel_athkar_bloc.dart';

sealed class TravelAthkarEvent {}

class LoadAthkarEvent extends TravelAthkarEvent {}

class IncrementCounterEvent extends TravelAthkarEvent {
  IncrementCounterEvent(this.item);
  final TravelDhikrModel item;
}

class ResetCounterEvent extends TravelAthkarEvent {
  ResetCounterEvent(this.key);
  final String key;
}
