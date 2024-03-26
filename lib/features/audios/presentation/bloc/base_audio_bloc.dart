import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/audios/data/base_audio_repository_imp.dart';

part 'base_audio_event.dart';
part 'base_audio_state.dart';

class BaseAudioBloc extends Bloc<BaseAudioEvent, BaseAudioState> {
  BaseAudioRepositoryImpl repositoryImpl;
  ScrollController scrollController = ScrollController();

  BaseAudioBloc({required this.repositoryImpl}) : super(BaseAudioState()) {
    on<GetBaseAudioEvent>(baseAudio);
    on<BaseAudioDetailEvent>(baseAudioDetail);
    on<InitBaseAudioPlayerEvent>(initAudio);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }

  FutureOr<void> baseAudio(event, emit) async {
    emit(state.copyWith(famousBaseAudioState: RequestState.loading));
    var result = await repositoryImpl.famousReader(event.id);
    result.fold(
      (l) {
        emit(state.copyWith(famousBaseAudioState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            famousBaseAudioState: RequestState.success,
            baseAudio: r,
          ),
        );
      },
    );
  }

  FutureOr<void> baseAudioDetail(event, emit) async {
    emit(state.copyWith(famousBaseAudioState: RequestState.loading));
    var result = await repositoryImpl.famousReaderDetail(event.url);
    result.fold(
      (l) {
        emit(
          state.copyWith(
            famousBaseAudioState: RequestState.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            famousBaseAudioState: RequestState.success,
            baseAudioDetail: r,
          ),
        );
        add(InitBaseAudioPlayerEvent(r));
      },
    );
  }

  FutureOr<void> initAudio(event, emit) async {
    emit(state.copyWith(audioState: RequestState.loading));
    var result = await repositoryImpl.initAudio(event.data);
    result.fold(
      (l) {
        emit(
          state.copyWith(
            audioState: RequestState.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            audioState: RequestState.success,
            audioPlayer: r,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    if (state.audioPlayer != null) {
      state.audioPlayer!.pause();
      state.audioPlayer!.dispose();
    }

    return super.close();
  }
}
