part of 'audio_cubit.dart';

@immutable
abstract class AudioState {}

class AudioCubitInitial extends AudioState {}

//
class InitAudioAudioLoadingState extends AudioState {}

class InitAudioAudioSuccessState extends AudioState {}

class InitAudioAudioErrorState extends AudioState {}

//

class CurrentAudioPlayerState extends AudioState {}

class UpdateAudioPlayerState extends AudioState {}

class LoadingInitAudioPlayerState extends AudioState {}

//
class PlayAudioLoadingState extends AudioState {}

class PlayAudioSuccessState extends AudioState {}

//
class NextPlayAudioLoadingState extends AudioState {}

class NextPlayAudioSuccessState extends AudioState {}
