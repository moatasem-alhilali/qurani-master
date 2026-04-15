part of 'daily_wird_bloc.dart';

abstract class DailyWirdEvent extends Equatable {
  const DailyWirdEvent();

  @override
  List<Object?> get props => [];
}

class DailyWirdLoadEvent extends DailyWirdEvent {
  const DailyWirdLoadEvent();
}

class DailyWirdSelectPresetEvent extends DailyWirdEvent {
  const DailyWirdSelectPresetEvent(this.presetId);

  final String presetId;

  @override
  List<Object?> get props => [presetId];
}

class DailyWirdIncrementItemEvent extends DailyWirdEvent {
  const DailyWirdIncrementItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DailyWirdResetItemEvent extends DailyWirdEvent {
  const DailyWirdResetItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DailyWirdToggleItemEvent extends DailyWirdEvent {
  const DailyWirdToggleItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DailyWirdHideItemEvent extends DailyWirdEvent {
  const DailyWirdHideItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DailyWirdRestoreItemEvent extends DailyWirdEvent {
  const DailyWirdRestoreItemEvent(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class DailyWirdUpdateItemCountEvent extends DailyWirdEvent {
  const DailyWirdUpdateItemCountEvent(this.itemId, this.countRequired);

  final String itemId;
  final int countRequired;

  @override
  List<Object?> get props => [itemId, countRequired];
}

class DailyWirdMoveItemEvent extends DailyWirdEvent {
  const DailyWirdMoveItemEvent({
    required this.itemId,
    required this.direction,
  });

  final String itemId;
  final int direction;

  @override
  List<Object?> get props => [itemId, direction];
}

class DailyWirdUpdateSettingsEvent extends DailyWirdEvent {
  const DailyWirdUpdateSettingsEvent(this.settings);

  final DailyWirdSettings settings;

  @override
  List<Object?> get props => [settings];
}
