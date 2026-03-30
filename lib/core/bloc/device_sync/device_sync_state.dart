part of 'device_sync_bloc.dart';

enum DeviceSyncStatus {
  initial,
  preparing,
  waitingForConnection,
  syncing,
  synced,
  failure,
}

class DeviceSyncState extends Equatable {
  const DeviceSyncState({
    this.status = DeviceSyncStatus.initial,
    this.isConnected = false,
    this.pendingLaunches = 0,
    this.deviceId,
    this.lastSyncedAt,
    this.errorMessage,
  });

  final DeviceSyncStatus status;
  final bool isConnected;
  final int pendingLaunches;
  final String? deviceId;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  DeviceSyncState copyWith({
    DeviceSyncStatus? status,
    bool? isConnected,
    int? pendingLaunches,
    String? deviceId,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DeviceSyncState(
      status: status ?? this.status,
      isConnected: isConnected ?? this.isConnected,
      pendingLaunches: pendingLaunches ?? this.pendingLaunches,
      deviceId: deviceId ?? this.deviceId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isConnected,
        pendingLaunches,
        deviceId,
        lastSyncedAt,
        errorMessage,
      ];
}
