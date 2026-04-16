part of 'radio_bloc.dart';

sealed class RadioEvent extends Equatable {
  const RadioEvent();

  @override
  List<Object?> get props => [];
}

class RadioInitialized extends RadioEvent {
  const RadioInitialized();
}

class RadioStationPlayRequested extends RadioEvent {
  const RadioStationPlayRequested(this.station);

  final RadioStationModel station;

  @override
  List<Object?> get props => [station];
}

class RadioTogglePlayPauseRequested extends RadioEvent {
  const RadioTogglePlayPauseRequested();
}

class RadioStopRequested extends RadioEvent {
  const RadioStopRequested();
}

class _RadioPlaybackChanged extends RadioEvent {
  const _RadioPlaybackChanged(this.snapshot);

  final RadioPlaybackSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot.status, snapshot.station];
}
