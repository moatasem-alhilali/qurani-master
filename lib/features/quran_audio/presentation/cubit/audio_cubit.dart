import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/quran_audio/data/remote/audio_player_repo.dart';

part 'audio_state.dart';

double progress = 0;

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioCubitInitial());
  static AudioCubit get(BuildContext context) => BlocProvider.of(context);

  int currentReader = 0;

  void changeIndex(int index) {
    currentReader = index;
    // emit(ToggleState());
  }

  Future<void> initAudioPlayer() async {
    emit(LoadingInitAudioPlayerState());
    try {
      await AudioPlayerRepo.initPlayerOnlineListenAudioSource();
      // checkConnection();
      emit(CurrentAudioPlayerState());
    } catch (e) {
      print(e);
    }
  }
  //next player

  Future<void> nextPlayer() async {
    emit(LoadingInitAudioPlayerState());

    try {
      await AudioPlayerRepo.audioPlayerOnlineListen.seek(
        Duration.zero,
        index: AudioPlayerRepo.currentSurah,
      );
      emit(CurrentAudioPlayerState());
    } catch (e) {}
  }

  //play audio

  Future<void> playAudioSelected({required int indexSurah}) async {
    emit(PlayAudioLoadingState());

    try {
      await AudioPlayerRepo.audioPlayerOnlineListen.seek(
        Duration.zero,
        index: indexSurah,
      );
      AudioPlayerRepo.currentSurah = indexSurah;
      emit(PlayAudioSuccessState());
      await AudioPlayerRepo.audioPlayerOnlineListen.play();
    } catch (e) {
      print(e);
    }
  }

  //next player

  Future<void> playAudioNextOrPrevious({required bool isNext}) async {
    emit(NextPlayAudioLoadingState());
    try {
      if (isNext) {
        await AudioPlayerRepo.audioPlayerOnlineListen.seekToNext();
        AudioPlayerRepo.currentSurah = AudioPlayerRepo.currentSurah + 1;
        emit(NextPlayAudioSuccessState());
      } else {
        await AudioPlayerRepo.audioPlayerOnlineListen.seekToPrevious();
        AudioPlayerRepo.currentSurah = AudioPlayerRepo.currentSurah - 1;
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
    _subscription =
        AudioPlayerRepo.audioPlayerOnlineListen.playbackEventStream.listen(
      (event) {
        //
        AudioPlayerRepo.currentAudioData.indexSurah =
            AudioPlayerRepo.audioPlayerOnlineListen.currentIndex;
        //
        emit(CurrentAudioPlayerState());
      },
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
  }
}
