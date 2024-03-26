import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../controller/repository/audio_player_helper.dart';

part 'audio_state.dart';

double progress = 0;

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioCubitInitial());
  static AudioCubit get(context) => BlocProvider.of(context);

  int currentReader = 0;

  void changeIndex(int index) {
    currentReader = index;
    // emit(ToggleState());
  }

  void initAudioPlayer() async {
    emit(LoadingInitAudioPlayerState());
    try {
      await AudioPlayerHelper.initPlayerOnlineListenAudioSource();
      // checkConnection();
      emit(CurrentAudioPlayerState());
    } catch (e) {
      print(e);
    }
  }
  //next player

  void nextPlayer() async {
    emit(LoadingInitAudioPlayerState());

    try {
      await AudioPlayerHelper.audioPlayerOnlineListen.seek(
        Duration.zero,
        index: AudioPlayerHelper.currentSurah,
      );
      emit(CurrentAudioPlayerState());
    } catch (e) {}
  }

  //play audio

  void playAudioSelected({required int indexSurah}) async {
    emit(PlayAudioLoadingState());

    try {
      await AudioPlayerHelper.audioPlayerOnlineListen.seek(
        Duration.zero,
        index: indexSurah,
      );
      AudioPlayerHelper.currentSurah = indexSurah;
      emit(PlayAudioSuccessState());
      await AudioPlayerHelper.audioPlayerOnlineListen.play();
    } catch (e) {
      print(e);
    }
  }

  //next player

  void playAudioNextOrPrevious({required bool isNext}) async {
    emit(NextPlayAudioLoadingState());
    try {
      if (isNext) {
        await AudioPlayerHelper.audioPlayerOnlineListen.seekToNext();
        AudioPlayerHelper.currentSurah = AudioPlayerHelper.currentSurah + 1;
        emit(NextPlayAudioSuccessState());
      } else {
        await AudioPlayerHelper.audioPlayerOnlineListen.seekToPrevious();
        AudioPlayerHelper.currentSurah = AudioPlayerHelper.currentSurah - 1;
        emit(NextPlayAudioSuccessState());
      }
    } catch (e) {
      print(e);
    }
  }

  //==================audio Player Listener =====================
  StreamSubscription? _subscription;
  //
  void audioPlayerListener() {
    _subscription = AudioPlayerHelper
        .audioPlayerOnlineListen.playbackEventStream
        .listen((event) {
      //
      AudioPlayerHelper.currentAudioData.indexSurah =
          AudioPlayerHelper.audioPlayerOnlineListen.currentIndex!;
      //
      emit(CurrentAudioPlayerState());
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }
}
