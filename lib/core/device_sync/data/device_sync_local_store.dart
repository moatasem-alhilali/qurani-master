import 'package:quran_app/core/cash/cache_service.dart';
import 'package:uuid/uuid.dart';

class DeviceSyncLocalStore {
  DeviceSyncLocalStore({
    required CacheService cacheService,
  }) : _cacheService = cacheService;

  static const _installationIdKey = 'device_sync_installation_id';
  static const _launchCountKey = 'device_sync_launch_count';
  static const _lastSyncedLaunchCountKey =
      'device_sync_last_synced_launch_count';
  static const _firstOpenedAtKey = 'device_sync_first_opened_at';
  static const _lastOpenedAtKey = 'device_sync_last_opened_at';
  static const _lastKnownTokenKey = 'device_sync_last_known_fcm_token';

  final CacheService _cacheService;
  final Uuid _uuid = const Uuid();

  Future<String> getOrCreateInstallationId() async {
    final cached = _cacheService.getString(_installationIdKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final installationId = _uuid.v4();
    await _cacheService.setString(_installationIdKey, installationId);
    return installationId;
  }

  Future<DateTime> getOrCreateFirstOpenedAt() async {
    final cached = _cacheService.getString(_firstOpenedAtKey);
    if (cached != null && cached.isNotEmpty) {
      final parsed = DateTime.tryParse(cached);
      if (parsed != null) {
        return parsed;
      }
    }

    final firstOpenedAt = DateTime.now().toUtc();
    await _cacheService.setString(
      _firstOpenedAtKey,
      firstOpenedAt.toIso8601String(),
    );
    return firstOpenedAt;
  }

  Future<int> recordLaunch() async {
    final openedAt = DateTime.now().toUtc();
    final current = _cacheService.getInt(_launchCountKey) ?? 0;
    final updated = current + 1;
    await _cacheService.setInt(_launchCountKey, updated);
    await _cacheService.setString(
      _lastOpenedAtKey,
      openedAt.toIso8601String(),
    );
    return updated;
  }

  int getLaunchCount() {
    return _cacheService.getInt(_launchCountKey) ?? 0;
  }

  int getLastSyncedLaunchCount() {
    return _cacheService.getInt(_lastSyncedLaunchCountKey) ?? 0;
  }

  int getPendingLaunchCount() {
    final pending = getLaunchCount() - getLastSyncedLaunchCount();
    return pending < 0 ? 0 : pending;
  }

  DateTime? getLastOpenedAt() {
    final cached = _cacheService.getString(_lastOpenedAtKey);
    if (cached == null || cached.isEmpty) {
      return null;
    }
    return DateTime.tryParse(cached);
  }

  Future<void> markLaunchesSynced() async {
    await _cacheService.setInt(
      _lastSyncedLaunchCountKey,
      getLaunchCount(),
    );
  }

  Future<void> saveLastKnownToken(String token) async {
    await _cacheService.setString(_lastKnownTokenKey, token);
  }

  String? getLastKnownToken() {
    return _cacheService.getString(_lastKnownTokenKey);
  }
}
