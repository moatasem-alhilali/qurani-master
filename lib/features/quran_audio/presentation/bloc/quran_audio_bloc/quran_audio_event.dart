part of 'quran_audio_bloc.dart';

@immutable
abstract class QuranAudioEvent {}

class SetStateQuranAudioEvent extends QuranAudioEvent {}

class InitQuranPlayerDataEvent extends QuranAudioEvent {}

class InitAndSetUrlAudioPlayerNetworkEvent extends QuranAudioEvent {
  InitAndSetUrlAudioPlayerNetworkEvent({required this.url});
  String url;
}

class InitAndSetUrlAudioPlayerFileEvent extends QuranAudioEvent {
  InitAndSetUrlAudioPlayerFileEvent({required this.filePath});
  String filePath;
}

class InitAudioPlayerSourceEvent extends QuranAudioEvent {
  InitAudioPlayerSourceEvent({this.currentAudioData});
  final CurrentQuranAudioModel? currentAudioData;
}

class SeekToAudioPlayerSourceEvent extends QuranAudioEvent {
  SeekToAudioPlayerSourceEvent({
    required this.index,
  });
  final int index;
}

class SeekToAudioPlayerFileEvent extends QuranAudioEvent {
  SeekToAudioPlayerFileEvent({
    required this.index,
  });
  final int index;
}

class PlayAudioNextOrPreviousEvent extends QuranAudioEvent {
  PlayAudioNextOrPreviousEvent({required this.isNext});
  final bool isNext;
}

class ChangeCurrentAudioDataEvent extends QuranAudioEvent {
  ChangeCurrentAudioDataEvent({
    required this.currentAudioData,
    required this.reInitialize,
  });
  final bool reInitialize;
  final CurrentQuranAudioModel currentAudioData;
}

class ToggleShuffleEvent extends QuranAudioEvent {
  ToggleShuffleEvent();
}

class CycleLoopModeEvent extends QuranAudioEvent {
  CycleLoopModeEvent(); // off ➜ one ➜ all ➜ off
}

class ToggleMuteEvent extends QuranAudioEvent {
  ToggleMuteEvent();
}
