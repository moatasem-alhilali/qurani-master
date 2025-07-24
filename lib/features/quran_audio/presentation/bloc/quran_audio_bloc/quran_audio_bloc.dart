import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/quran_audio/data/models/quran_reader_model.dart';
import 'package:quran_app/features/quran_audio/data/remote/quran_audio_player_repo.dart';
import 'package:quran_app/main.dart';

part 'quran_audio_event.dart';
part 'quran_audio_state.dart';

class QuranAudioBloc extends Bloc<QuranAudioEvent, QuranAudioState> {
  QuranAudioBloc({required this.quranAudioPlayerRepo})
      : super(const QuranAudioState()) {
    on<InitQuranPlayerDataEvent>(_initQuranPlayerDataEvent);
    on<InitAndSetUrlAudioPlayerNetworkEvent>(
      _initAndSetUrlAudioPlayerNetworkEvent,
    );
    on<InitAndSetUrlAudioPlayerFileEvent>(_initAndSetUrlAudioPlayerFileEvent);
    on<InitAudioPlayerSourceEvent>(_initAudioPlayerSourceEvent);
    on<SeekToAudioPlayerSourceEvent>(_seekToAudioPlayerSourceEvent);
    on<ChangeCurrentAudioDataEvent>(_changeCurrentAudioDataEvent);
    on<PlayAudioNextOrPreviousEvent>(_playAudioNextOrPreviousEvent);
    on<ToggleShuffleEvent>((event, emit) async {
      final player = state.audioPlayerSource;
      if (player == null) return;

      final newShuffle = !state.isShuffleEnabled;
      await player.setShuffleModeEnabled(newShuffle);
      if (newShuffle) await player.shuffle(); // reorder the queue
      emit(state.copyWith(isShuffleEnabled: newShuffle));
    });

    on<CycleLoopModeEvent>((event, emit) async {
      final player = state.audioPlayerSource;
      if (player == null) return;

      // navigate between Off → One → All
      final next = switch (state.loopMode) {
        LoopMode.off => LoopMode.one,
        LoopMode.one => LoopMode.all,
        _ => LoopMode.off,
      };

      await player.setLoopMode(next);
      emit(state.copyWith(loopMode: next));
    }); // quran_audio_bloc.dart
    on<ToggleMuteEvent>((event, emit) async {
      final player = state.audioPlayerSource;
      if (player == null) return;
      final newMuted = !state.isMuted;
      // mute: setVolume(0) | unmute: setVolume(1)
      await player.setVolume(newMuted ? 0.0 : 1.0);
      emit(state.copyWith(isMuted: newMuted));
    });
  }
  final QuranAudioPlayerRepo quranAudioPlayerRepo;

  Future<void> _initQuranPlayerDataEvent(
    InitQuranPlayerDataEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));
      final mostReaderData = await quranAudioPlayerRepo.loadMostReaderData();
      final surahInfoData = await quranAudioPlayerRepo.loadSurahInfoData();
      final currentAudioData = quranAudioPlayerRepo.getCurrentAudioData(
        surahInfoData: surahInfoData,
        mostReaderData: mostReaderData,
      );
      logger.i('Load Current Audio Data: ${currentAudioData.nameReader}');
      emit(
        state.copyWith(
          loadState: RequestState.success,
          surahInfoData: surahInfoData,
          mostReaderData: mostReaderData,
          currentAudioData: currentAudioData,
        ),
      );
      add(InitAudioPlayerSourceEvent());
    } catch (e) {
      emit(state.copyWith(loadState: RequestState.error));
    }
  }

  Future<void> _initAudioPlayerSourceEvent(
    InitAudioPlayerSourceEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      emit(state.copyWith(loadAudioSourceState: RequestState.loading));
      final audioPlayer =
          await quranAudioPlayerRepo.initPlayerOnlineListenAudioSource(
        currentAudioData: event.currentAudioData ?? state.currentAudioData!,
      );
      emit(
        state.copyWith(
          loadAudioSourceState: RequestState.success,
          audioPlayerSource: audioPlayer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadAudioSourceState: RequestState.error));
    }
  }

  Future<void> _initAndSetUrlAudioPlayerNetworkEvent(
    InitAndSetUrlAudioPlayerNetworkEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      emit(state.copyWith(loadAudioPlayerNetworkState: RequestState.loading));
      final audioPlayer =
          await quranAudioPlayerRepo.initPlayerOnlineListenAudioSource(
        currentAudioData: state.currentAudioData!,
      );
      emit(
        state.copyWith(
          loadAudioPlayerNetworkState: RequestState.success,
          audioPlayerSource: audioPlayer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadAudioPlayerNetworkState: RequestState.error));
    }
  }

  Future<void> _initAndSetUrlAudioPlayerFileEvent(
    InitAndSetUrlAudioPlayerFileEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      emit(
        state.copyWith(loadAudioPlayerFileState: RequestState.loading),
      );
      final audioPlayer = await quranAudioPlayerRepo.initPlayerFile(
        event.filePath,
      );
      emit(
        state.copyWith(
          loadAudioPlayerFileState: RequestState.success,
          audioPlayerFile: audioPlayer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadAudioPlayerFileState: RequestState.error));
    }
  }

  Future<void> _seekToAudioPlayerSourceEvent(
    SeekToAudioPlayerSourceEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      await state.audioPlayerSource?.seek(
        Duration.zero,
        index: event.index,
      );
      state.audioPlayerSource?.play();
      emit(state.copyWith());
    } catch (e) {
      emit(state.copyWith());
    }
  }

  Future<void> _changeCurrentAudioDataEvent(
    ChangeCurrentAudioDataEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    state.audioPlayerSource?.stop();
    if (event.reInitialize) {
      add(InitAudioPlayerSourceEvent(currentAudioData: event.currentAudioData));
    }
    emit(state.copyWith(currentAudioData: event.currentAudioData));
  }

  Future<void> _playAudioNextOrPreviousEvent(
    PlayAudioNextOrPreviousEvent event,
    Emitter<QuranAudioState> emit,
  ) async {
    try {
      state.audioPlayerSource?.stop();

      // get current index
      final currentIndex = state.audioPlayerSource!.currentIndex!;

      // Calculate target index
      final targetIndex = event.isNext ? currentIndex + 1 : currentIndex - 1;

      // Validate bounds
      if (targetIndex < 0 || targetIndex >= state.surahInfoData.length) {
        logger.w(
          'Invalid index: $targetIndex. Bounds: 0-${state.surahInfoData.length - 1}',
        );
        return;
      }

      // Get target surah data
      final targetSurahData = state.surahInfoData[targetIndex];

      // Seek to target index
      await state.audioPlayerSource?.seek(
        Duration.zero,
        index: targetIndex,
      );

      // Update current audio data with correct target information
      final updateCurrent = state.currentAudioData!.copyWith(
        indexSurah: targetIndex,
        nameSurah: targetSurahData.surah,
        countSurahVerse: targetSurahData.ayaatiha,
      );

      emit(state.copyWith(currentAudioData: updateCurrent));

      logger.i(
        'Navigated from index $currentIndex to $targetIndex (${event.isNext ? 'next' : 'previous'})',
      );

      // Start playing
      await state.audioPlayerSource?.play();
    } catch (e) {
      logger.e('Error in _playAudioNextOrPreviousEvent: $e');
      emit(state.copyWith());
    }
  }

  @override
  Future<void> close() {
    if (state.audioPlayerSource != null) {
      state.audioPlayerSource?.dispose();
    }
    return super.close();
  }
}
