import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quran_app/core/device_sync/data/device_sync_local_store.dart';
import 'package:quran_app/core/services/device_info_service.dart';

class DeviceSyncResult {
  const DeviceSyncResult({
    required this.deviceId,
    required this.syncedAt,
    required this.pendingLaunchesAfterSync,
  });

  final String deviceId;
  final DateTime syncedAt;
  final int pendingLaunchesAfterSync;
}

class DeviceSyncRepository {
  DeviceSyncRepository({
    required FirebaseFirestore firestore,
    required FirebaseMessaging firebaseMessaging,
    required DeviceInfoService deviceInfoService,
    required DeviceSyncLocalStore localStore,
  })  : _firestore = firestore,
        _firebaseMessaging = firebaseMessaging,
        _deviceInfoService = deviceInfoService,
        _localStore = localStore;

  static const _collectionName = 'app_devices';

  final FirebaseFirestore _firestore;
  final FirebaseMessaging _firebaseMessaging;
  final DeviceInfoService _deviceInfoService;
  final DeviceSyncLocalStore _localStore;

  Stream<String> get tokenRefreshStream => _firebaseMessaging.onTokenRefresh;

  Future<void> recordLaunch() async {
    await _localStore.recordLaunch();
  }

  Future<void> cacheToken(String token) async {
    if (token.trim().isEmpty) return;
    await _localStore.saveLastKnownToken(token.trim());
  }

  Future<String> getResolvedDeviceId() async {
    final installationId = await _localStore.getOrCreateInstallationId();
    return _deviceInfoService.getResolvedUniqueDeviceId(
      installationId: installationId,
    );
  }

  Future<int> getPendingLaunchCount() async {
    return _localStore.getPendingLaunchCount();
  }

  Future<DeviceSyncResult> syncCurrentSnapshot({
    required String reason,
  }) async {
    final installationId = await _localStore.getOrCreateInstallationId();
    final firstOpenedAt = await _localStore.getOrCreateFirstOpenedAt();
    final cachedToken = _localStore.getLastKnownToken();
    final pendingLaunches = _localStore.getPendingLaunchCount();

    final payload = await _deviceInfoService.buildInstallationPayload(
      installationId: installationId,
      firstOpenedAt: firstOpenedAt,
      cachedFcmToken: cachedToken,
    );

    final document =
        _firestore.collection(_collectionName).doc(payload.deviceUniqueId);

    await document.set(
      payload.toFirestoreData(
        pendingLaunches: pendingLaunches,
        syncReason: reason,
      ),
      SetOptions(merge: true),
    );

    if (pendingLaunches > 0) {
      await _localStore.markLaunchesSynced();
    }
    final token = payload.fcmToken?.trim();
    if (token != null && token.isNotEmpty) {
      await _localStore.saveLastKnownToken(token);
    }

    return DeviceSyncResult(
      deviceId: payload.deviceUniqueId,
      syncedAt: DateTime.now().toUtc(),
      pendingLaunchesAfterSync: _localStore.getPendingLaunchCount(),
    );
  }
}
