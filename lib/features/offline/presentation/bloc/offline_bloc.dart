import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/features/offline/data/offline_repository_imp.dart';

part 'offline_event.dart';
part 'offline_state.dart';

class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  OfflineRepositoryImpl repositoryImpl;
  ScrollController scrollController = ScrollController();

  OfflineBloc({required this.repositoryImpl}) : super(OfflineState()) {
    on<GetOfflineEvent>(index);
    on<InitOfflinePlayerEvent>(initAudio);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }

  FutureOr<void> index(event, emit) async {
    emit(state.copyWith(getState: RequestState.loading));
    var result = await repositoryImpl.index();
    result.fold(
      (l) {
        emit(state.copyWith(getState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            getState: RequestState.success,
            data: r,
          ),
        );
      },
    );
  }

  FutureOr<void> initAudio(event, emit) async {
    try {
      emit(state.copyWith(getState: RequestState.loading));
      final data = await DBHelper.get('offlines');

      final filtter =
          data.where((element) => element['type'] == event.type).toList();

      emit(
        state.copyWith(
          getState: RequestState.success,
          data: filtter,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          getState: RequestState.error,
        ),
      );
      // TODO
    }
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
