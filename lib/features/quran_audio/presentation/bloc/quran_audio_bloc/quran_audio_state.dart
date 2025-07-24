part of 'quran_audio_bloc.dart';

@immutable
class QuranAudioState {
  const QuranAudioState({
    this.loadState = RequestState.initial,
    this.loadAudioSourceState = RequestState.initial,
    this.loadAudioPlayerNetworkState = RequestState.initial,
    this.loadAudioPlayerFileState = RequestState.initial,
    this.audioPlayerSource,
    this.audioPlayerFile,
    this.currentAudioData,
    this.surahInfoData = const [],
    this.mostReaderData = const [],
  });
  final RequestState loadState;
  final RequestState loadAudioSourceState;
  final RequestState loadAudioPlayerNetworkState;
  final RequestState loadAudioPlayerFileState;

  //
  final AudioPlayer? audioPlayerSource;
  final AudioPlayer? audioPlayerFile;
  final CurrentQuranAudioModel? currentAudioData;
  final List<SurahInfoModel> surahInfoData;
  final List<QuranReaderModel> mostReaderData;

  QuranAudioState copyWith({
    RequestState? loadState,
    RequestState? loadAudioSourceState,
    RequestState? loadAudioPlayerNetworkState,
    RequestState? loadAudioPlayerFileState,
    AudioPlayer? audioPlayerSource,
    AudioPlayer? audioPlayerFile,
    CurrentQuranAudioModel? currentAudioData,
    List<SurahInfoModel>? surahInfoData,
    List<QuranReaderModel>? mostReaderData,
  }) {
    return QuranAudioState(
      loadState: loadState ?? this.loadState,
      loadAudioSourceState: loadAudioSourceState ?? this.loadAudioSourceState,
      loadAudioPlayerNetworkState:
          loadAudioPlayerNetworkState ?? this.loadAudioPlayerNetworkState,
      loadAudioPlayerFileState:
          loadAudioPlayerFileState ?? this.loadAudioPlayerFileState,
      audioPlayerSource: audioPlayerSource ?? this.audioPlayerSource,
      audioPlayerFile: audioPlayerFile ?? this.audioPlayerFile,
      currentAudioData: currentAudioData ?? this.currentAudioData,
      surahInfoData: surahInfoData ?? this.surahInfoData,
      mostReaderData: mostReaderData ?? this.mostReaderData,
    );
  }
}
