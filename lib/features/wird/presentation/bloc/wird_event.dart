part of 'wird_bloc.dart';

@immutable
abstract class WirdEvent {}

class LoadWirdEvent extends WirdEvent {
  LoadWirdEvent({required this.isMorning});
  final bool isMorning;
}
