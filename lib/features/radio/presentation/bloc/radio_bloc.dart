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
  RadioBloc({required RadioRepository repository})
      : _repository = repository,
        super(const RadioState()) {
    on<RadioInitialized>(_onInitialized);
    on<RadioStationPlayRequested>(_onPlayRequested);
    on<RadioStationPreviewed>(_onPreviewed);
    on<RadioTogglePlayPauseRequested>(_onTogglePlayPause);
    on<RadioStopRequested>(_onStop);
    on<_RadioPlaybackChanged>(_onPlaybackChanged);

    _repository.audioService.playback.addListener(_onPlaybackValueChanged);
  }

  final RadioRepository _repository;

  RadioRepository get repository => _repository;

  Future<void> _onInitialized(
    RadioInitialized event,
    Emitter<RadioState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading));
    try {
      final stations = await _repository.loadStations();
      final lastStationId = _repository.getLastStationId();
      final lastStation = _findById(stations, lastStationId);

      // بلا محطة محفوظة يبدأ المؤشّر على الأولى بدل فراغ: القرص لا يكون
      // فارغًا في راديو حقيقي.
      final seed = lastStation ?? (stations.isEmpty ? null : stations.first);
      _repository.audioService.seedLastStation(seed);

      emit(
        state.copyWith(
          loadState: RequestState.success,
          stations: stations,
          currentStation: seed,
          playbackStatus: _repository.audioService.playback.value.status,
        ),
      );
    } catch (_) {
      emit(_withError('تعذّر تحميل الإذاعات حاليًا.',
          loadState: RequestState.error));
    }
  }

  Future<void> _onPlayRequested(
    RadioStationPlayRequested event,
    Emitter<RadioState> emit,
  ) async {
    emit(state.copyWith(currentStation: event.station, clearError: true));
    try {
      await _repository.playStation(event.station);
    } catch (_) {
      emit(_withError('تعذّر تشغيل الإذاعة الآن.'));
    }
  }

  void _onPreviewed(RadioStationPreviewed event, Emitter<RadioState> emit) {
    emit(state.copyWith(currentStation: event.station, clearError: true));
  }

  Future<void> _onTogglePlayPause(
    RadioTogglePlayPauseRequested event,
    Emitter<RadioState> emit,
  ) async {
    // الجهاز مطفأ والمستخدم يضغط «تشغيل»: المطلوب فتح المحطة المعروضة على
    // المؤشّر، لا استئناف مشغّل لا مصدر له.
    if (!state.isPowered) {
      final station = state.currentStation;
      if (station != null) {
        add(RadioStationPlayRequested(station));
        return;
      }
    }

    try {
      await _repository.togglePlayPause();
    } catch (_) {
      emit(_withError('تعذّر تغيير حالة التشغيل.'));
    }
  }

  Future<void> _onStop(
      RadioStopRequested event, Emitter<RadioState> emit) async {
    try {
      await _repository.stop();
    } catch (_) {
      emit(_withError('تعذّر إيقاف الإذاعة.'));
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
      ),
    );
  }

  void _onPlaybackValueChanged() {
    if (isClosed) return;
    add(_RadioPlaybackChanged(_repository.audioService.playback.value));
  }

  RadioState _withError(String message, {RequestState? loadState}) {
    return state.copyWith(
      loadState: loadState,
      errorMessage: message,
      errorTick: state.errorTick + 1,
    );
  }

  static RadioStationModel? _findById(
    List<RadioStationModel> stations,
    int? id,
  ) {
    if (id == null) return null;
    for (final station in stations) {
      if (station.id == id) return station;
    }
    return null;
  }

  @override
  Future<void> close() {
    _repository.audioService.playback.removeListener(_onPlaybackValueChanged);
    return super.close();
  }
}
