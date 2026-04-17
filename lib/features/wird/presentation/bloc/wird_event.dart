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

class ToggleAudioWirdEvent extends WirdEvent {
  ToggleAudioWirdEvent(this.itemIndex);
  final int itemIndex;
}

class TogglePlayAllWirdEvent extends WirdEvent {}

class AudioPlayerStateChangedEvent extends WirdEvent {
  AudioPlayerStateChangedEvent({
    required this.isPlaying,
    required this.processingState,
  });
  final bool isPlaying;
  final ProcessingState processingState;
}

class AudioIndexChangedEvent extends WirdEvent {
  AudioIndexChangedEvent(this.currentIndex);
  final int? currentIndex;
}

class UpdateRemainingCounterEvent extends WirdEvent {
  UpdateRemainingCounterEvent(this.index, this.remaining);
  final int index;
  final int remaining;
}

class ResetRemainingCounterEvent extends WirdEvent {
  ResetRemainingCounterEvent(this.index);
  final int index;
}

class ChangeDisplayModeEvent extends WirdEvent {}

class ChangePageEvent extends WirdEvent {
  ChangePageEvent(this.pageIndex);
  final int pageIndex;
}
