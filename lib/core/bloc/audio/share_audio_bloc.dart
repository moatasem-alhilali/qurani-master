import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';

part 'share_audio_event.dart';
part 'share_audio_state.dart';

class ShareAudioBloc extends Bloc<ShareAudioEvent, ShareAudioState> {
  ShareAudioBloc() : super(const ShareAudioState()) {
    on<InitAndSetUrlAudioPlayerEvent>(_onInitAndSetUrlAudioPlayerEvent);
    on<InitAudioPlayerEvent>(_onInitAudioPlayerEvent);
    on<SetUrlAudioPlayerEvent>(_onSetUrlAudioPlayerEvent);
  }
  FutureOr<void> _onInitAndSetUrlAudioPlayerEvent(
    InitAndSetUrlAudioPlayerEvent event,
    Emitter<ShareAudioState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));
      final audioPlayer = AudioPlayer();
      await audioPlayer.setUrl(event.url);

      emit(
        state.copyWith(
          url: event.url,
          loadState: RequestState.success,
          audioPlayer: audioPlayer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadState: RequestState.error));
    }
  }

  FutureOr<void> _onInitAudioPlayerEvent(
    InitAudioPlayerEvent event,
    Emitter<ShareAudioState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading));
  }

  FutureOr<void> _onSetUrlAudioPlayerEvent(
    SetUrlAudioPlayerEvent event,
    Emitter<ShareAudioState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final audioPlayer = AudioPlayer();
      await audioPlayer.setUrl(event.url);

      emit(
        state.copyWith(
          loadState: RequestState.success,
          url: event.url,
          audioPlayer: audioPlayer,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadState: RequestState.error));
    }
  }

  @override
  Future<void> close() {
    if (state.audioPlayer != null) {
      state.audioPlayer?.dispose();
    }
    return super.close();
  }
}
