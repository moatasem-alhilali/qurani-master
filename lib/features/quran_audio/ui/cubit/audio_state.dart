part of 'audio_cubit.dart';

@immutable
abstract class AudioCubitState {}

class AudioCubitInitial extends AudioCubitState {}

//
class InitAudioAudioLoadingState extends AudioCubitState {}

class InitAudioAudioSuccessState extends AudioCubitState {}

class InitAudioAudioErrorState extends AudioCubitState {}

//

class CurrentAudioPlayerState extends AudioCubitState {}
class UpdateAudioPlayerState extends AudioCubitState {}

class LoadingInitAudioPlayerState extends AudioCubitState {}

//
class PlayAudioLoadingState extends AudioCubitState {}

class PlayAudioSuccessState extends AudioCubitState {}

//
class NextPlayAudioLoadingState extends AudioCubitState {}

class NextPlayAudioSuccessState extends AudioCubitState {}
