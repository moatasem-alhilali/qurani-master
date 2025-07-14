import 'dart:convert';

import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/main.dart';

/// Cache data source for version management
abstract class VersionCacheDataSource {
  Future<void> cacheVersionInfo(AppVersionModel versionModel);
  Future<AppVersionModel?> getCachedVersionInfo();
  Future<void> clearVersionCache();
  Future<bool> hasValidCache([Duration maxAge]);
  Future<void> cacheUserSkippedVersion(String version);
  Future<String?> getUserSkippedVersion();
  Future<void> clearSkippedVersion();
  Future<bool> hasUserSkippedVersion(String version);
  Future<Map<String, dynamic>> getCacheStats();
}

class VersionCacheDataSourceImpl implements VersionCacheDataSource {
  VersionCacheDataSourceImpl({CacheService? cacheService})
      : _cacheService = cacheService ?? CacheService();

  final CacheService _cacheService;

  // Cache keys
  static const String _versionInfoKey = 'app_version_info';
  static const String _userSkippedVersionKey = 'user_skipped_version';
  static const String _lastVersionCheckKey = 'last_version_check_time';

  @override
  Future<void> cacheVersionInfo(AppVersionModel versionModel) async {
    try {
      logger.i('Caching version information: ${versionModel.latestVersion}');

      // Convert model to JSON string and cache it
      final versionJson = jsonEncode(versionModel.toCache());
      await _cacheService.setString(_versionInfoKey, versionJson);

      // Cache the check timestamp
      await _cacheService.setInt(
        _lastVersionCheckKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      logger.i('Version information cached successfully');
    } catch (e) {
      logger.e('Failed to cache version information: $e');
      rethrow;
    }
  }

  @override
  Future<AppVersionModel?> getCachedVersionInfo() async {
    try {
      final versionJson = _cacheService.getString(_versionInfoKey);

      if (versionJson == null || versionJson.isEmpty) {
        logger.d('No cached version information found');
        return null;
      }

      final versionData = jsonDecode(versionJson) as Map<String, dynamic>;
      final versionModel = AppVersionModel.fromCache(versionData);

      logger.i(
        'Cached version information retrieved: ${versionModel.latestVersion}',
      );
      return versionModel;
    } catch (e) {
      logger.e('Failed to get cached version information: $e');
      // Clear corrupted cache
      await clearVersionCache();
      return null;
    }
  }

  @override
  Future<void> clearVersionCache() async {
    try {
      logger.i('Clearing version cache');

      await Future.wait([
        _cacheService.remove(_versionInfoKey),
        _cacheService.remove(_lastVersionCheckKey),
      ]);

      logger.i('Version cache cleared successfully');
    } catch (e) {
      logger.e('Failed to clear version cache: $e');
    }
  }

  @override
  Future<bool> hasValidCache([Duration? maxAge]) async {
    try {
      maxAge ??= const Duration(hours: 6); // Default cache validity

      // Check if we have cached version info
      final cachedVersion = await getCachedVersionInfo();
      if (cachedVersion == null) return false;

      // Check if cache is still valid based on timestamp
      final lastCheckTime = _cacheService.getInt(_lastVersionCheckKey);
      if (lastCheckTime == null) return false;

      final lastCheck = DateTime.fromMillisecondsSinceEpoch(lastCheckTime);
      final isStillValid = DateTime.now().difference(lastCheck) < maxAge;

      logger.d(
        'Cache validity check - Last check: $lastCheck, '
        'Max age: $maxAge, Is valid: $isStillValid',
      );

      return isStillValid;
    } catch (e) {
      logger.e('Failed to check cache validity: $e');
      return false;
    }
  }

  @override
  Future<void> cacheUserSkippedVersion(String version) async {
    try {
      logger.i('Caching user skipped version: $version');
      await _cacheService.setString(_userSkippedVersionKey, version);
    } catch (e) {
      logger.e('Failed to cache skipped version: $e');
    }
  }

  @override
  Future<String?> getUserSkippedVersion() async {
    try {
      final skippedVersion = _cacheService.getString(_userSkippedVersionKey);
      logger.d('Retrieved skipped version: $skippedVersion');
      return skippedVersion;
    } catch (e) {
      logger.e('Failed to get skipped version: $e');
      return null;
    }
  }

  @override
  Future<void> clearSkippedVersion() async {
    try {
      logger.i('Clearing skipped version');
      await _cacheService.remove(_userSkippedVersionKey);
    } catch (e) {
      logger.e('Failed to clear skipped version: $e');
    }
  }

  /// Get cache statistics for debugging
  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final cachedVersion = await getCachedVersionInfo();
      final lastCheckTime = _cacheService.getInt(_lastVersionCheckKey);
      final skippedVersion = await getUserSkippedVersion();

      return {
        'has_cached_version': cachedVersion != null,
        'cached_version': cachedVersion?.latestVersion,
        'last_check_time': lastCheckTime != null
            ? DateTime.fromMillisecondsSinceEpoch(lastCheckTime)
                .toIso8601String()
            : null,
        'skipped_version': skippedVersion,
        'is_cache_valid': await hasValidCache(),
      };
    } catch (e) {
      logger.e('Failed to get cache stats: $e');
      return {'error': e.toString()};
    }
  }

  /// Force update cache timestamp (useful for testing)
  Future<void> updateCacheTimestamp([DateTime? timestamp]) async {
    try {
      final time = timestamp ?? DateTime.now();
      await _cacheService.setInt(
        _lastVersionCheckKey,
        time.millisecondsSinceEpoch,
      );
      logger.d('Cache timestamp updated to: $time');
    } catch (e) {
      logger.e('Failed to update cache timestamp: $e');
    }
  }

  /// Check if user has skipped a specific version
  @override
  Future<bool> hasUserSkippedVersion(String version) async {
    try {
      final skippedVersion = await getUserSkippedVersion();
      return skippedVersion == version;
    } catch (e) {
      logger.e('Failed to check if user skipped version: $e');
      return false;
    }
  }
}
