import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_library/quran_library.dart';

enum RadioPlaybackStatus {
  idle,
  loading,
  playing,
  paused,
  stopped,
  error,
}

class RadioPlaybackSnapshot {
  const RadioPlaybackSnapshot({
    required this.status,
    this.station,
  });

  final RadioPlaybackStatus status;
  final RadioStationModel? station;
}

class RadioAudioService {
  RadioAudioService() {
    _playerStateSubscription =
        AudioCtrl.instance.state.audioPlayer.playerStateStream.listen(
      _handlePlayerStateChanged,
    );
  }

  final ValueNotifier<RadioPlaybackSnapshot> playback = ValueNotifier(
    const RadioPlaybackSnapshot(status: RadioPlaybackStatus.idle),
  );

  StreamSubscription<PlayerState>? _playerStateSubscription;
  RadioStationModel? _currentStation;

  RadioStationModel? get currentStation => _currentStation;

  Future<void> playStation(RadioStationModel station) async {
    playback.value = RadioPlaybackSnapshot(
      status: RadioPlaybackStatus.loading,
      station: station,
    );

    _currentStation = station;
    try {
      await AudioCtrl.instance.playRadioStream(
        id: station.id.toString(),
        title: station.name,
        url: station.streamUrl,
        imageUrl: station.imageUrl,
      );
    } catch (_) {
      playback.value = RadioPlaybackSnapshot(
        status: RadioPlaybackStatus.error,
        station: station,
      );
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    final player = AudioCtrl.instance.state.audioPlayer;
    if (player.playing) {
      await player.pause();
      return;
    }

    if (_currentStation != null &&
        player.processingState == ProcessingState.idle) {
      await playStation(_currentStation!);
      return;
    }

    await player.play();
  }

  Future<void> stop() async {
    try {
      await AudioCtrl.instance.stopRadioStream();
      playback.value = RadioPlaybackSnapshot(
        status: RadioPlaybackStatus.stopped,
        station: _currentStation,
      );
    } catch (_) {
      playback.value = RadioPlaybackSnapshot(
        status: RadioPlaybackStatus.error,
        station: _currentStation,
      );
      rethrow;
    }
  }

  void seedLastStation(RadioStationModel? station) {
    _currentStation = station;
    if (station != null && playback.value.station == null) {
      playback.value = RadioPlaybackSnapshot(
        status: RadioPlaybackStatus.idle,
        station: station,
      );
    }
  }

  void _handlePlayerStateChanged(PlayerState state) {
    final station = _currentStation;
    if (station == null) {
      playback.value =
          const RadioPlaybackSnapshot(status: RadioPlaybackStatus.idle);
      return;
    }

    final status = switch (state.processingState) {
      ProcessingState.loading ||
      ProcessingState.buffering =>
        RadioPlaybackStatus.loading,
      ProcessingState.completed => RadioPlaybackStatus.stopped,
      ProcessingState.idle =>
        state.playing ? RadioPlaybackStatus.playing : RadioPlaybackStatus.idle,
      ProcessingState.ready => state.playing
          ? RadioPlaybackStatus.playing
          : RadioPlaybackStatus.paused,
    };

    playback.value = RadioPlaybackSnapshot(
      status: status,
      station: station,
    );
  }

  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    playback.dispose();
  }
}
