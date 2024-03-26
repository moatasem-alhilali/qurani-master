part of 'base_audio_bloc.dart';

@immutable
class BaseAudioState {
  //famous Reader
  List<dynamic> baseAudio;
  List<dynamic> baseAudioDetail;
  RequestState famousBaseAudioState;
  RequestState audioState;
  AudioPlayer? audioPlayer;

  BaseAudioState({
    //famous Reader
    this.famousBaseAudioState = RequestState.defaults,
    this.audioPlayer,
    this.audioState = RequestState.defaults,
    this.baseAudio = const [],
    this.baseAudioDetail = const [],
  });

  BaseAudioState copyWith({
    //famous Reader
    RequestState? audioState,
      AudioPlayer? audioPlayer,
    RequestState? famousBaseAudioState,
    List<dynamic>? baseAudio,
    List<dynamic>? baseAudioDetail,
  }) {
    return BaseAudioState(
      //famous Reader
      audioState: audioState ?? this.audioState,
      audioPlayer: audioPlayer ?? this.audioPlayer,
      baseAudio: baseAudio ?? this.baseAudio,
      baseAudioDetail: baseAudioDetail ?? this.baseAudioDetail,
      famousBaseAudioState: famousBaseAudioState ?? this.famousBaseAudioState,
    );
  }
}
