part of 'base_audio_bloc.dart';

@immutable
abstract class BaseAudioEvent {}

class SetStateEvent extends BaseAudioEvent {}

class GetBaseAudioEvent extends BaseAudioEvent {
  GetBaseAudioEvent(this.id);
  final String id;
}

class InitBaseAudioPlayerEvent extends BaseAudioEvent {
  InitBaseAudioPlayerEvent(this.data);
  final dynamic data;
}

class BaseAudioDetailEvent extends BaseAudioEvent {
  BaseAudioDetailEvent(this.url);
  final String url;
}
