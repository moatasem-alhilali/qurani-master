part of 'wird_bloc.dart';

@immutable
abstract class WirdEvent {}

class LoadWirdEvent extends WirdEvent {
  LoadWirdEvent({
    required this.isMorning,
    this.assetPath = JsonLoaderService.wirdsPath,
    this.filterByPeriod = true,
  });

  final bool isMorning;
  final String assetPath;
  final bool filterByPeriod;
}
