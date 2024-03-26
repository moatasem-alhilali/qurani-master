part of 'offline_bloc.dart';

@immutable
class OfflineState {
  //famous Reader
  List<dynamic> data;
  RequestState getState;

  RequestState audioState;
  AudioPlayer? audioPlayer;

  OfflineState({
    //famous Reader
    this.audioPlayer,
    this.audioState = RequestState.defaults,
    this.getState = RequestState.defaults,
    this.data = const [],
  });

  OfflineState copyWith({
    RequestState? audioState,
    AudioPlayer? audioPlayer,
    List<dynamic>? data,
    RequestState? getState,
  }) {
    return OfflineState(
      //famous Reader
      audioState: audioState ?? this.audioState,
      getState: getState ?? this.getState,
      audioPlayer: audioPlayer ?? this.audioPlayer,
      data: data ?? this.data,
    );
  }
}
