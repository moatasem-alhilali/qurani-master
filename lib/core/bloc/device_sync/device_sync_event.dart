part of 'device_sync_bloc.dart';

abstract class DeviceSyncEvent extends Equatable {
  const DeviceSyncEvent();

  @override
  List<Object?> get props => [];
}

class DeviceSyncStarted extends DeviceSyncEvent {
  const DeviceSyncStarted();
}

class DeviceSyncConnectivityChanged extends DeviceSyncEvent {
  const DeviceSyncConnectivityChanged({
    required this.isConnected,
  });

  final bool isConnected;

  @override
  List<Object?> get props => [isConnected];
}

class DeviceSyncTokenChanged extends DeviceSyncEvent {
  const DeviceSyncTokenChanged(this.token);

  final String token;

  @override
  List<Object?> get props => [token];
}

class DeviceSyncSyncRequested extends DeviceSyncEvent {
  const DeviceSyncSyncRequested({
    required this.reason,
  });

  final String reason;

  @override
  List<Object?> get props => [reason];
}
