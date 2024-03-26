part of 'base_audio_bloc.dart';

@immutable
abstract class BaseAudioEvent {}

class SetStateEvent extends BaseAudioEvent {}

class GetBaseAudioEvent extends BaseAudioEvent {
  final String id;
  GetBaseAudioEvent(this.id);
}

class InitBaseAudioPlayerEvent extends BaseAudioEvent {
  final dynamic data;
  InitBaseAudioPlayerEvent(this.data);
}

class BaseAudioDetailEvent extends BaseAudioEvent {
  final String url;
  BaseAudioDetailEvent(this.url);
}
