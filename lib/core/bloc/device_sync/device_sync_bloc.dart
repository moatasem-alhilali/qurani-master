import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/device_sync/data/device_sync_repository.dart';
import 'package:quran_app/main.dart';

part 'device_sync_event.dart';
part 'device_sync_state.dart';

class DeviceSyncBloc extends Bloc<DeviceSyncEvent, DeviceSyncState> {
  DeviceSyncBloc({
    required DeviceSyncRepository repository,
    required ConnectivityBloc connectivityBloc,
  })  : _repository = repository,
        _connectivityBloc = connectivityBloc,
        super(
          DeviceSyncState(
            isConnected: connectivityBloc.state.isConnected,
          ),
        ) {
    on<DeviceSyncStarted>(_onStarted);
    on<DeviceSyncConnectivityChanged>(_onConnectivityChanged);
    on<DeviceSyncTokenChanged>(_onTokenChanged);
    on<DeviceSyncSyncRequested>(_onSyncRequested);
  }

  final DeviceSyncRepository _repository;
  final ConnectivityBloc _connectivityBloc;

  StreamSubscription<ConnectivityState>? _connectivitySubscription;
  StreamSubscription<String>? _tokenSubscription;
  bool _hasStarted = false;
  bool _isSyncing = false;

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _tokenSubscription?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    DeviceSyncStarted event,
    Emitter<DeviceSyncState> emit,
  ) async {
    if (_hasStarted) {
      return;
    }
    _hasStarted = true;

    emit(
      state.copyWith(
        status: DeviceSyncStatus.preparing,
        clearErrorMessage: true,
      ),
    );

    try {
      await _repository.recordLaunch();
      final deviceId = await _repository.getResolvedDeviceId();
      final pendingLaunches = await _repository.getPendingLaunchCount();

      emit(
        state.copyWith(
          status: DeviceSyncStatus.waitingForConnection,
          deviceId: deviceId,
          pendingLaunches: pendingLaunches,
          isConnected: _connectivityBloc.state.isConnected,
          clearErrorMessage: true,
        ),
      );

      _connectivitySubscription = _connectivityBloc.stream.listen((value) {
        add(DeviceSyncConnectivityChanged(isConnected: value.isConnected));
      });
      _tokenSubscription = _repository.tokenRefreshStream.listen((token) {
        add(DeviceSyncTokenChanged(token));
      });

      if (_connectivityBloc.state.isConnected) {
        add(const DeviceSyncSyncRequested(reason: 'launch'));
      }
    } catch (error, stackTrace) {
      logger.e(
        'Device sync start failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: DeviceSyncStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onConnectivityChanged(
    DeviceSyncConnectivityChanged event,
    Emitter<DeviceSyncState> emit,
  ) {
    emit(
      state.copyWith(
        isConnected: event.isConnected,
        status: event.isConnected
            ? state.status
            : DeviceSyncStatus.waitingForConnection,
      ),
    );

    if (event.isConnected) {
      add(const DeviceSyncSyncRequested(reason: 'connectivity_restored'));
    }
  }

  Future<void> _onTokenChanged(
    DeviceSyncTokenChanged event,
    Emitter<DeviceSyncState> emit,
  ) async {
    await _repository.cacheToken(event.token);
    if (state.isConnected) {
      add(const DeviceSyncSyncRequested(reason: 'token_refresh'));
    }
  }

  Future<void> _onSyncRequested(
    DeviceSyncSyncRequested event,
    Emitter<DeviceSyncState> emit,
  ) async {
    if (!state.isConnected || _isSyncing) {
      return;
    }

    _isSyncing = true;
    emit(
      state.copyWith(
        status: DeviceSyncStatus.syncing,
        clearErrorMessage: true,
      ),
    );

    try {
      final result = await _repository.syncCurrentSnapshot(
        reason: event.reason,
      );
      emit(
        state.copyWith(
          status: DeviceSyncStatus.synced,
          deviceId: result.deviceId,
          lastSyncedAt: result.syncedAt,
          pendingLaunches: result.pendingLaunchesAfterSync,
          clearErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      logger.e('Device sync failed', error: error, stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: DeviceSyncStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } finally {
      _isSyncing = false;
    }
  }
}
