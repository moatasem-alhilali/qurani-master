import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/offline/data/offline_repository_imp.dart';

part 'offline_event.dart';
part 'offline_state.dart';

class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  final OfflineRepositoryImpl repositoryImpl;
  final ScrollController scrollController = ScrollController();

  OfflineBloc({required this.repositoryImpl}) : super(OfflineState()) {
    on<GetOfflineEvent>(_onIndex);
    on<InitOfflinePlayerEvent>(_onInitAudio);
    on<SetStateEvent>((event, emit) => emit(state.copyWith()));
  }

  Future<void> _onIndex(
      GetOfflineEvent event, Emitter<OfflineState> emit) async {
    emit(state.copyWith(getState: RequestState.loading));
    final result = await repositoryImpl.index();
    result.fold(
      (l) => emit(state.copyWith(getState: RequestState.error)),
      (r) => emit(state.copyWith(getState: RequestState.success, data: r)),
    );
  }

  Future<void> _onInitAudio(
      InitOfflinePlayerEvent event, Emitter<OfflineState> emit) async {
    emit(state.copyWith(getState: RequestState.loading));
    final result = await repositoryImpl.getByType(event.type);
    result.fold(
      (l) => emit(state.copyWith(getState: RequestState.error)),
      (filtered) =>
          emit(state.copyWith(getState: RequestState.success, data: filtered)),
    );
  }

  @override
  Future<void> close() {
    state.audioPlayer?.pause();
    state.audioPlayer?.dispose();
    return super.close();
  }
}
