// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_quran_audio_bloc.dart';

@immutable
class DownloadQuranAudioState {
  final RequestState loadState;
 

  

  const DownloadQuranAudioState({
    this.loadState = RequestState.initial,

  });

  DownloadQuranAudioState copyWith({
    RequestState? loadState,
  }) {
    return DownloadQuranAudioState(
      loadState: loadState ?? this.loadState,
    );
  }
}
