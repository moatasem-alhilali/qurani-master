import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';

part 'wird_event.dart';
part 'wird_state.dart';

class WirdBloc extends Bloc<WirdEvent, WirdState> {
  WirdBloc() : super(const WirdState()) {
    on<LoadWirdEvent>(_onLoad);
    on<ToggleAudioWirdEvent>(_onToggleAudio);
    on<TogglePlayAllWirdEvent>(_onTogglePlayAll);
    on<AudioPlayerStateChangedEvent>(_onAudioPlayerStateChanged);
    on<AudioIndexChangedEvent>(_onAudioIndexChanged);
    on<UpdateRemainingCounterEvent>(_onUpdateRemainingCounter);
    on<ResetRemainingCounterEvent>(_onResetRemainingCounter);
    on<ChangeDisplayModeEvent>(_onChangeDisplayMode);
    on<ChangePageEvent>(_onChangePage);
  }

  AudioService? _audioService;
  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  final Map<int, int> _itemIndexToQueueIndex = {};
  final Map<int, int> _queueIndexToItemIndex = {};
  final Map<int, List<int>> _itemIndexToQueueIndices = {};

  String _audioSignature = '';
  int _setupToken = 0;

  @override
  Future<void> close() async {
    await _disposeAudioPlayer();
    return super.close();
  }

  FutureOr<void> _onLoad(
    LoadWirdEvent event,
    Emitter<WirdState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));

    try {
      final list = await JsonLoaderService.loadJsonList(
        event.assetPath,
      );

      final allItems = list.map(WirdModel.fromJson).toList();
      final items = event.filterByPeriod
          ? allItems.where((item) => item.isForPeriod(event.isMorning)).toList()
          : allItems;

      final remainingCounters = <int, int>{};
      for (var i = 0; i < items.length; i++) {
        remainingCounters[i] = items[i].counter;
      }

      emit(state.copyWith(
        data: items,
        state: RequestState.success,
        remainingCounters: remainingCounters,
      ));

      // After loading data, configure initial single-play queue
      unawaited(_setupAudioQueue(items, emit));
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
    }
  }

  Future<void> _setupAudioQueue(List<WirdModel> items, Emitter<WirdState>? emit) async {
    final signature = _buildAudioSignature(items);
    if (_audioSignature == signature && _audioService != null) {
      return;
    }

    _audioSignature = signature;
    final setupId = ++_setupToken;

    final updateState = (WirdState newState) {
      if (emit != null && !isClosed) {
        emit(newState);
      } else if (!isClosed) {
        // ignore: invalid_use_of_visible_for_testing_member
        this.emit(newState);
      }
    };

    updateState(state.copyWith(
      isAudioInitializing: true,
      isAudioReady: false,
      isPlaying: false,
      processingState: ProcessingState.idle,
      activeItemIndex: -1, // Use -1 as null equivalent in copyWith
      currentRepeatIndex: 0,
      currentRepeatTotal: 0,
      isQueueRepeated: false,
      itemsWithAudio: {},
    ));

    await _disposeAudioPlayer();
    if (isClosed || setupId != _setupToken) return;

    final indexedAudioItems = items.asMap().entries.where(
          (entry) => entry.value.audioUrl.trim().isNotEmpty,
        );

    if (indexedAudioItems.isEmpty) {
      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: false,
      ));
      return;
    }

    _itemIndexToQueueIndex.clear();
    _queueIndexToItemIndex.clear();
    _itemIndexToQueueIndices.clear();

    final audioUrls = <String>[];
    final itemsWithAudio = <int>{};
    var queueIndex = 0;
    
    for (final entry in indexedAudioItems) {
      _itemIndexToQueueIndex[entry.key] = queueIndex;
      _queueIndexToItemIndex[queueIndex] = entry.key;
      _itemIndexToQueueIndices[entry.key] = [queueIndex];
      itemsWithAudio.add(entry.key);
      audioUrls.add(entry.value.audioUrl.trim());
      queueIndex += 1;
    }

    final service = AudioService();

    try {
      await service.initAudiosNetworks(audioUrls);

      if (isClosed || setupId != _setupToken) {
        await service.audioPlayer.dispose();
        return;
      }

      _audioService = service;

      _indexSubscription = service.audioPlayer.currentIndexStream.listen((currentQueueIndex) {
        if (!isClosed) {
          add(AudioIndexChangedEvent(currentQueueIndex));
        }
      });

      _playerStateSubscription = service.audioPlayer.playerStateStream.listen((playerState) {
        if (!isClosed) {
          add(AudioPlayerStateChangedEvent(
            isPlaying: playerState.playing,
            processingState: playerState.processingState,
          ));
        }
      });

      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: true,
        itemsWithAudio: itemsWithAudio,
      ));
    } catch (_) {
      await service.audioPlayer.dispose();
      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: false,
      ));
    }
  }

  Future<void> _disposeAudioPlayer() async {
    await _indexSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    _indexSubscription = null;
    _playerStateSubscription = null;

    final service = _audioService;
    _audioService = null;

    if (service == null) return;

    try {
      await service.audioPlayer.pause();
      await service.audioPlayer.dispose();
    } catch (_) {}
  }

  String _buildAudioSignature(List<WirdModel> items, {bool repeated = false}) {
    final base = items.map((item) => item.audioUrl.trim()).where((url) => url.isNotEmpty).join('|');
    return '${repeated ? 'r' : 's'}:$base';
  }

  FutureOr<void> _onToggleAudio(ToggleAudioWirdEvent event, Emitter<WirdState> emit) async {
    if (state.isAudioInitializing || !state.isAudioReady) return;

    final service = _audioService;
    final queueIndex = _itemIndexToQueueIndex[event.itemIndex];

    if (service == null || queueIndex == null) return;

    final player = service.audioPlayer;
    final currentState = player.playerState;
    final isCurrentItem = state.activeItemIndex == event.itemIndex;
    final isCompleted = currentState.processingState == ProcessingState.completed;

    try {
      if (state.isQueueRepeated) {
        await _setupAudioQueue(state.data ?? [], null);
      }

      if (isCurrentItem && currentState.playing) {
        await player.pause();
        return;
      }

      if (isCurrentItem && !isCompleted) {
        await player.play();
        return;
      }

      await service.playSeek(queueIndex);
      await player.play();
    } catch (_) {}
  }

  FutureOr<void> _onTogglePlayAll(TogglePlayAllWirdEvent event, Emitter<WirdState> emit) async {
    if (state.isAudioInitializing || !state.isAudioReady) return;

    if (state.isQueueRepeated) {
      if (state.isPlaying) {
        await _audioService?.audioPlayer.pause();
        return;
      }
      await _audioService?.audioPlayer.play();
      return;
    }

    await _setupRepeatedAudioQueue(state.data ?? []);
    if (!isClosed) {
      await _audioService?.audioPlayer.play();
    }
  }

  Future<void> _setupRepeatedAudioQueue(List<WirdModel> items) async {
    final signature = _buildAudioSignature(items, repeated: true);
    if (_audioSignature == signature && _audioService != null) return;

    _audioSignature = signature;
    final setupId = ++_setupToken;

    void updateState(WirdState newState) {
      if (!isClosed) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(newState);
      }
    }

    updateState(state.copyWith(
      isAudioInitializing: true,
      isAudioReady: false,
      isPlaying: false,
      processingState: ProcessingState.idle,
      activeItemIndex: -1,
      currentRepeatIndex: 0,
      currentRepeatTotal: 0,
    ));

    await _disposeAudioPlayer();
    if (isClosed || setupId != _setupToken) return;

    final indexedAudioItems = items.asMap().entries.where(
          (entry) => entry.value.audioUrl.trim().isNotEmpty,
        );

    if (indexedAudioItems.isEmpty) {
      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: false,
        isQueueRepeated: false,
      ));
      return;
    }

    _itemIndexToQueueIndex.clear();
    _queueIndexToItemIndex.clear();
    _itemIndexToQueueIndices.clear();

    final audioUrls = <String>[];
    final itemsWithAudio = <int>{};
    var queueIndex = 0;

    for (final entry in indexedAudioItems) {
      final repeatCount = entry.value.counter <= 0 ? 1 : entry.value.counter;
      final indices = <int>[];
      for (var i = 0; i < repeatCount; i += 1) {
        indices.add(queueIndex);
        _queueIndexToItemIndex[queueIndex] = entry.key;
        audioUrls.add(entry.value.audioUrl.trim());
        queueIndex += 1;
      }
      itemsWithAudio.add(entry.key);
      _itemIndexToQueueIndex[entry.key] = indices.first;
      _itemIndexToQueueIndices[entry.key] = indices;
    }

    final service = AudioService();

    try {
      await service.initAudiosNetworks(audioUrls);

      if (isClosed || setupId != _setupToken) {
        await service.audioPlayer.dispose();
        return;
      }

      _audioService = service;

      _indexSubscription = service.audioPlayer.currentIndexStream.listen((currentQueueIndex) {
        if (!isClosed) add(AudioIndexChangedEvent(currentQueueIndex));
      });

      _playerStateSubscription = service.audioPlayer.playerStateStream.listen((playerState) {
        if (!isClosed) {
          add(AudioPlayerStateChangedEvent(
            isPlaying: playerState.playing,
            processingState: playerState.processingState,
          ));
        }
      });

      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: true,
        isQueueRepeated: true,
        itemsWithAudio: itemsWithAudio,
      ));
    } catch (_) {
      await service.audioPlayer.dispose();
      updateState(state.copyWith(
        isAudioInitializing: false,
        isAudioReady: false,
        isQueueRepeated: false,
      ));
    }
  }

  FutureOr<void> _onAudioPlayerStateChanged(AudioPlayerStateChangedEvent event, Emitter<WirdState> emit) {
    emit(state.copyWith(
      isPlaying: event.isPlaying,
      processingState: event.processingState,
    ));
    _syncActiveQueueState(emit);
  }

  FutureOr<void> _onAudioIndexChanged(AudioIndexChangedEvent event, Emitter<WirdState> emit) {
    _syncActiveQueueState(emit, indexOffset: event.currentIndex);
  }

  void _syncActiveQueueState(Emitter<WirdState> emit, {int? indexOffset}) {
    final currentQueueIndex = indexOffset ?? _audioService?.audioPlayer.currentIndex;
    final itemIndex = _queueIndexToItemIndex[currentQueueIndex ?? -1];
    final indices = itemIndex == null ? null : _itemIndexToQueueIndices[itemIndex];

    var repeatIndex = 0;
    var repeatTotal = 0;
    if (indices != null && indices.isNotEmpty && currentQueueIndex != null) {
      repeatTotal = indices.length;
      final position = indices.indexOf(currentQueueIndex);
      repeatIndex = position == -1 ? 0 : position + 1;
    }

    emit(state.copyWith(
      activeItemIndex: itemIndex ?? -1,
      currentRepeatIndex: repeatIndex,
      currentRepeatTotal: repeatTotal,
    ));
  }

  FutureOr<void> _onUpdateRemainingCounter(UpdateRemainingCounterEvent event, Emitter<WirdState> emit) {
    final timers = Map<int, int>.from(state.remainingCounters);
    timers[event.index] = event.remaining;
    emit(state.copyWith(remainingCounters: timers));
  }

  FutureOr<void> _onResetRemainingCounter(ResetRemainingCounterEvent event, Emitter<WirdState> emit) {
    final timers = Map<int, int>.from(state.remainingCounters);
    timers[event.index] = state.data?[event.index].counter ?? 0;
    emit(state.copyWith(remainingCounters: timers));
  }

  FutureOr<void> _onChangeDisplayMode(ChangeDisplayModeEvent event, Emitter<WirdState> emit) {
    final newMode = state.displayMode == WirdDisplayMode.listView ? WirdDisplayMode.pageView : WirdDisplayMode.listView;
    emit(state.copyWith(displayMode: newMode));
  }

  FutureOr<void> _onChangePage(ChangePageEvent event, Emitter<WirdState> emit) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }
}
