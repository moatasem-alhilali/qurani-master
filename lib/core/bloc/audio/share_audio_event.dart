part of 'share_audio_bloc.dart';

@immutable
abstract class ShareAudioEvent {}

class InitAndSetUrlAudioPlayerEvent extends ShareAudioEvent {
  InitAndSetUrlAudioPlayerEvent({required this.url});
  String url;
}

class InitAudioPlayerEvent extends ShareAudioEvent {
  InitAudioPlayerEvent();
}

class SetUrlAudioPlayerEvent extends ShareAudioEvent {
  SetUrlAudioPlayerEvent({required this.url});
  String url;
}
