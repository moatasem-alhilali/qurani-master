part of 'radio_bloc.dart';

class RadioState extends Equatable {
  const RadioState({
    this.loadState = RequestState.initial,
    this.actionState = RequestState.initial,
    this.stations = const [],
    this.currentStation,
    this.lastStationId,
    this.playbackStatus = RadioPlaybackStatus.idle,
    this.errorMessage,
  });

  final RequestState loadState;
  final RequestState actionState;
  final List<RadioStationModel> stations;
  final RadioStationModel? currentStation;
  final int? lastStationId;
  final RadioPlaybackStatus playbackStatus;
  final String? errorMessage;

  bool get isPlaying => playbackStatus == RadioPlaybackStatus.playing;
  bool get isLoadingPlayback => playbackStatus == RadioPlaybackStatus.loading;
  bool get hasActiveStation => currentStation != null;

  RadioState copyWith({
    RequestState? loadState,
    RequestState? actionState,
    List<RadioStationModel>? stations,
    RadioStationModel? currentStation,
    int? lastStationId,
    RadioPlaybackStatus? playbackStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RadioState(
      loadState: loadState ?? this.loadState,
      actionState: actionState ?? this.actionState,
      stations: stations ?? this.stations,
      currentStation: currentStation ?? this.currentStation,
      lastStationId: lastStationId ?? this.lastStationId,
      playbackStatus: playbackStatus ?? this.playbackStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        actionState,
        stations,
        currentStation,
        lastStationId,
        playbackStatus,
        errorMessage,
      ];
}
