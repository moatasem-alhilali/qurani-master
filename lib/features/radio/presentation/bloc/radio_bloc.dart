import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/repo/radio_repository.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';

part 'radio_event.dart';
part 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  RadioBloc({
    required RadioRepository repository,
  })  : _repository = repository,
        super(const RadioState()) {
    on<RadioInitialized>(_onInitialized);
    on<RadioStationPlayRequested>(_onPlayRequested);
    on<RadioTogglePlayPauseRequested>(_onTogglePlayPauseRequested);
    on<RadioStopRequested>(_onStopRequested);
    on<_RadioPlaybackChanged>(_onPlaybackChanged);

    _repository.audioService.playback.addListener(_onPlaybackValueChanged);
  }

  final RadioRepository _repository;

  Future<void> _onInitialized(
    RadioInitialized event,
    Emitter<RadioState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading));
    try {
      final stations = await _repository.loadStations();
      final lastStationId = _repository.getLastStationId();
      final lastStation =
          stations.where((item) => item.id == lastStationId).firstOrNull;
      _repository.audioService.seedLastStation(lastStation);

      emit(
        state.copyWith(
          loadState: RequestState.success,
          stations: stations,
          lastStationId: lastStationId,
          currentStation: lastStation,
          playbackStatus: _repository.audioService.playback.value.status,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: 'تعذر تحميل الإذاعات حاليًا.',
        ),
      );
    }
  }

  Future<void> _onPlayRequested(
    RadioStationPlayRequested event,
    Emitter<RadioState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearError: true,
        currentStation: event.station,
      ),
    );
    try {
      await _repository.playStation(event.station);
      emit(
        state.copyWith(
          actionState: RequestState.success,
          currentStation: event.station,
          lastStationId: event.station.id,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'تعذر تشغيل الإذاعة الآن.',
        ),
      );
    }
  }

  Future<void> _onTogglePlayPauseRequested(
    RadioTogglePlayPauseRequested event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await _repository.togglePlayPause();
    } catch (_) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'تعذر تغيير حالة التشغيل.',
        ),
      );
    }
  }

  Future<void> _onStopRequested(
    RadioStopRequested event,
    Emitter<RadioState> emit,
  ) async {
    try {
      await _repository.stop();
    } catch (_) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'تعذر إيقاف الإذاعة.',
        ),
      );
    }
  }

  void _onPlaybackChanged(
    _RadioPlaybackChanged event,
    Emitter<RadioState> emit,
  ) {
    emit(
      state.copyWith(
        playbackStatus: event.snapshot.status,
        currentStation: event.snapshot.station ?? state.currentStation,
        actionState: RequestState.initial,
      ),
    );
  }

  void _onPlaybackValueChanged() {
    add(_RadioPlaybackChanged(_repository.audioService.playback.value));
  }

  @override
  Future<void> close() {
    _repository.audioService.playback.removeListener(_onPlaybackValueChanged);
    return super.close();
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
