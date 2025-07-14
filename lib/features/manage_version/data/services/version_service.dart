import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_cache_datasource.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_remote_datasource.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/features/manage_version/data/repositories/version_repository_impl.dart';

/// High-level service for version management operations
class VersionService {
  VersionService({
    VersionRepository? versionRepository,
    VersionRemoteDataSource? remoteDataSource,
    VersionCacheDataSource? cacheDataSource,
  }) : _versionRepository = versionRepository ??
            VersionRepositoryImpl(
              remoteDataSource:
                  remoteDataSource ?? VersionRemoteDataSourceImpl(),
              cacheDataSource: cacheDataSource ?? VersionCacheDataSourceImpl(),
            );

  final VersionRepository _versionRepository;

  /// Initialize version management on app startup
  Future<bool> initialize() async {
    try {
      final result = await _versionRepository.initialize();

      return result.fold(
        (failure) => false,
        (_) => true,
      );
    } catch (e) {
      return false;
    }
  }

  /// Check for updates and return version information
  Future<AppVersionModel?> checkForUpdates({
    bool forceRefresh = false,
    bool isManualCheck = false,
  }) async {
    try {
      final result = await _versionRepository.checkForUpdates(
        forceRefresh: forceRefresh,
        isManualCheck: isManualCheck,
      );

      return result.fold(
        (failure) => null,
        (versionModel) => versionModel,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get cached version information for offline use
  Future<AppVersionModel?> getCachedVersionInfo() async {
    try {
      final result = await _versionRepository.getCachedVersionInfo();

      return result.fold(
        (failure) => null,
        (cachedVersion) => cachedVersion,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get current app version from package info
  Future<String> getCurrentAppVersion() async {
    try {
      final result = await _versionRepository.getCurrentAppVersion();

      return result.fold(
        (failure) => '1.0.0', // Fallback
        (version) => version,
      );
    } catch (e) {
      return '1.0.0'; // Fallback
    }
  }

  /// Mark a version as skipped by the user
  Future<bool> skipVersion(String version) async {
    try {
      final result = await _versionRepository.markVersionAsSkipped(version);

      return result.fold(
        (failure) => false,
        (_) => true,
      );
    } catch (e) {
      return false;
    }
  }

  /// Check if user has skipped a specific version
  Future<bool> hasUserSkippedVersion(String version) async {
    try {
      final result = await _versionRepository.hasUserSkippedVersion(version);

      return result.fold(
        (failure) => false,
        (hasSkipped) => hasSkipped,
      );
    } catch (e) {
      return false;
    }
  }

  /// Clear skipped version (allow showing update again)
  Future<bool> clearSkippedVersion() async {
    try {
      final result = await _versionRepository.clearSkippedVersion();

      return result.fold(
        (failure) => false,
        (_) => true,
      );
    } catch (e) {
      return false;
    }
  }

  /// Clear version cache
  Future<bool> clearVersionCache() async {
    try {
      final result = await _versionRepository.clearVersionCache();

      return result.fold(
        (failure) => false,
        (_) => true,
      );
    } catch (e) {
      return false;
    }
  }

  /// Perform complete version check with automatic caching
  Future<VersionCheckResult> performVersionCheck({
    bool forceRefresh = false,
    bool checkSkippedVersions = true,
    bool isManualCheck = false,
  }) async {
    try {
      // Check for updates
      final versionModel = await checkForUpdates(
        forceRefresh: forceRefresh,
        isManualCheck: isManualCheck,
      );

      if (versionModel == null) {
        return const VersionCheckResult(
          status: VersionCheckStatus.error,
          message: 'فشل في التحقق من التحديثات',
        );
      }

      // No update available
      if (!versionModel.isUpdateAvailable) {
        return VersionCheckResult(
          status: VersionCheckStatus.upToDate,
          versionModel: versionModel,
          message: 'التطبيق محدث بأحدث إصدار',
        );
      }

      // Update required
      if (versionModel.isUpdateRequired) {
        return VersionCheckResult(
          status: VersionCheckStatus.updateRequired,
          versionModel: versionModel,
          message: 'يجب تحديث التطبيق للمتابعة',
        );
      }

      // Check if user has skipped this version (only for non-manual checks)
      if (checkSkippedVersions && !isManualCheck) {
        final hasSkipped =
            await hasUserSkippedVersion(versionModel.latestVersion);
        if (hasSkipped) {
          return VersionCheckResult(
            status: VersionCheckStatus.updateSkipped,
            versionModel: versionModel,
            message: 'تم تخطي هذا التحديث مسبقاً',
          );
        }
      }

      // Update available and not skipped
      return VersionCheckResult(
        status: VersionCheckStatus.updateAvailable,
        versionModel: versionModel,
        message: 'تحديث جديد متاح',
      );
    } catch (e) {
      return VersionCheckResult(
        status: VersionCheckStatus.error,
        message: 'حدث خطأ أثناء التحقق من التحديثات: $e',
      );
    }
  }

  /// Quick check using cached data only
  Future<VersionCheckResult> quickVersionCheck() async {
    try {
      final cachedVersion = await getCachedVersionInfo();

      if (cachedVersion == null) {
        return const VersionCheckResult(
          status: VersionCheckStatus.noCache,
          message: 'لا توجد بيانات محفوظة للتحديثات',
        );
      }

      // Check if cache is still valid
      if (!cachedVersion.isCacheValid()) {
        return VersionCheckResult(
          status: VersionCheckStatus.cacheExpired,
          versionModel: cachedVersion,
          message: 'البيانات المحفوظة منتهية الصلاحية',
        );
      }

      // Use cached data for quick check
      return await performVersionCheck();
    } catch (e) {
      return const VersionCheckResult(
        status: VersionCheckStatus.error,
        message: 'فشل في الفحص السريع للتحديثات',
      );
    }
  }

  /// Get app information summary
  Future<Map<String, dynamic>> getAppSummary() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final cachedVersion = await getCachedVersionInfo();

      return {
        'app_name': packageInfo.appName,
        'package_name': packageInfo.packageName,
        'current_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'has_cached_version': cachedVersion != null,
        'cached_latest_version': cachedVersion?.latestVersion,
        'is_update_available': cachedVersion?.isUpdateAvailable ?? false,
        'is_update_required': cachedVersion?.isUpdateRequired ?? false,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// Result of version check operation
class VersionCheckResult {
  const VersionCheckResult({
    required this.status,
    this.versionModel,
    this.message,
  });

  final VersionCheckStatus status;
  final AppVersionModel? versionModel;
  final String? message;

  bool get isSuccessful => status != VersionCheckStatus.error;
  bool get hasUpdate =>
      status == VersionCheckStatus.updateAvailable ||
      status == VersionCheckStatus.updateRequired;
  bool get requiresAction => status == VersionCheckStatus.updateRequired;
}

/// Status of version check operation
enum VersionCheckStatus {
  upToDate,
  updateAvailable,
  updateRequired,
  updateSkipped,
  noCache,
  cacheExpired,
  error;

  String get displayText {
    switch (this) {
      case VersionCheckStatus.upToDate:
        return 'محدث';
      case VersionCheckStatus.updateAvailable:
        return 'تحديث متاح';
      case VersionCheckStatus.updateRequired:
        return 'تحديث مطلوب';
      case VersionCheckStatus.updateSkipped:
        return 'تم التخطي';
      case VersionCheckStatus.noCache:
        return 'لا توجد بيانات';
      case VersionCheckStatus.cacheExpired:
        return 'البيانات منتهية';
      case VersionCheckStatus.error:
        return 'خطأ';
    }
  }
}
