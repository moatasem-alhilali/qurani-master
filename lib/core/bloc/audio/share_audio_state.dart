// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'share_audio_bloc.dart';

@immutable
class ShareAudioState {
  final String url;
  final RequestState loadState;
  final AudioPlayer? audioPlayer;
  const ShareAudioState({
    this.url = '',
    this.loadState = RequestState.initial,
    this.audioPlayer,
  });

  ShareAudioState copyWith({
    String? url,
    RequestState? loadState,
    AudioPlayer? audioPlayer,
  }) {
    return ShareAudioState(
      url: url ?? this.url,
      loadState: loadState ?? this.loadState,
      audioPlayer: audioPlayer ?? this.audioPlayer,
    );
  }
}
