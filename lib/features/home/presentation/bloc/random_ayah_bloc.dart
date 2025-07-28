import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

part 'random_ayah_event.dart';
part 'random_ayah_state.dart';

class RandomAyahBloc extends Bloc<RandomAyahEvent, RandomAyahState> {
  RandomAyahBloc({required this.ayahDataSource})
      : super(const RandomAyahState()) {
    on<GetRandomAyahEvent>(_onGetRandomAyah);
    on<RefreshRandomAyahEvent>(_onRefreshRandomAyah);
  }
  final AyahDataSource ayahDataSource;

  Future<void> _onGetRandomAyah(
    GetRandomAyahEvent event,
    Emitter<RandomAyahState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final randomAyah = await ayahDataSource.getRandomAyah();

      emit(
        state.copyWith(
          loadState: RequestState.success,
          randomAyah: randomAyah,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to get random ayah: $e',
        ),
      );
    }
  }

  Future<void> _onRefreshRandomAyah(
    RefreshRandomAyahEvent event,
    Emitter<RandomAyahState> emit,
  ) async {
    try {
      emit(state.copyWith(loadState: RequestState.loading));

      final randomAyah = await ayahDataSource.getRandomAyah();

      if (randomAyah != null) {
        emit(
          state.copyWith(
            loadState: RequestState.success,
            randomAyah: randomAyah,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadState: RequestState.error,
            errorMessage: 'Failed to refresh random ayah',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'Failed to refresh random ayah: $e',
        ),
      );
    }
  }
}
