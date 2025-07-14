import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_cache_datasource.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_remote_datasource.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/main.dart';

/// Abstract repository for version management
abstract class VersionRepository {
  Future<Either<Failure, AppVersionModel>> checkForUpdates({
    bool forceRefresh = false,
    bool isManualCheck = false,
  });
  Future<Either<Failure, AppVersionModel?>> getCachedVersionInfo();
  Future<Either<Failure, String>> getCurrentAppVersion();
  Future<Either<Failure, void>> markVersionAsSkipped(String version);
  Future<Either<Failure, bool>> hasUserSkippedVersion(String version);
  Future<Either<Failure, void>> clearSkippedVersion();
  Future<Either<Failure, void>> clearVersionCache();
  Future<Either<Failure, void>> initialize();
  Stream<AppVersionModel> watchConfigChanges();
  Future<Either<Failure, void>> startListening();
  Future<Either<Failure, void>> stopListening();
  bool get isConnected;
  bool get isListening;
}

/// Implementation of version repository
class VersionRepositoryImpl implements VersionRepository {
  VersionRepositoryImpl({
    required VersionRemoteDataSource remoteDataSource,
    required VersionCacheDataSource cacheDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _cacheDataSource = cacheDataSource;

  final VersionRemoteDataSource _remoteDataSource;
  final VersionCacheDataSource _cacheDataSource;

  @override
  bool get isConnected => ISCONNECTED;

  @override
  bool get isListening => _remoteDataSource.isListening;

  @override
  Future<Either<Failure, AppVersionModel>> checkForUpdates({
    bool forceRefresh = false,
    bool isManualCheck = false,
  }) async {
    try {
      // For manual checks, always try to connect regardless of global connectivity state
      // For automatic checks, respect the connectivity state
      final shouldUseRemote = ISCONNECTED || isManualCheck;

      if (!shouldUseRemote) {
        // Only for automatic checks when offline - use cache only
        final cached = await _cacheDataSource.getCachedVersionInfo();
        if (cached != null) return right(cached);
        return left(
          ServerFailure('لا توجد معلومات محفوظة. يرجى الاتصال بالإنترنت.'),
        );
      }

      // Check cache first unless forcing refresh or manual check
      if (!forceRefresh && !isManualCheck) {
        final hasValidCache = await _cacheDataSource.hasValidCache();
        if (hasValidCache) {
          final cached = await _cacheDataSource.getCachedVersionInfo();
          if (cached != null) return right(cached);
        }
      }

      // Attempt to fetch from remote (this might fail if actually offline)
      try {
        final versionModel = await _remoteDataSource.checkForUpdates(
          forceRefresh: forceRefresh,
          isManualCheck: isManualCheck,
        );

        // Cache the result if successful
        await _cacheDataSource.cacheVersionInfo(versionModel);
        return right(versionModel);
      } catch (e) {
        logger.e('Remote fetch failed: $e');

        // For manual checks that fail, try fallback to cache with a different message
        if (isManualCheck) {
          final cached = await _cacheDataSource.getCachedVersionInfo();
          if (cached != null) {
            return right(
              cached.copyWith(
                lastChecked: DateTime.now(), // Update last checked time
              ),
            );
          }
          return left(
            ServerFailure(
              'فشل في الاتصال بالخادم. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
            ),
          );
        }

        // For automatic checks, fallback to cache silently
        final cached = await _cacheDataSource.getCachedVersionInfo();
        if (cached != null) return right(cached);

        return left(ServerFailure('فشل في التحقق من التحديثات: $e'));
      }
    } catch (e) {
      logger.e('Unexpected error in checkForUpdates: $e');

      // Last resort fallback to cache
      try {
        final cached = await _cacheDataSource.getCachedVersionInfo();
        if (cached != null) return right(cached);
      } catch (cacheError) {
        logger.e('Cache fallback also failed: $cacheError');
      }

      return left(ServerFailure('فشل في التحقق من التحديثات: $e'));
    }
  }

  @override
  Future<Either<Failure, AppVersionModel?>> getCachedVersionInfo() async {
    try {
      final cached = await _cacheDataSource.getCachedVersionInfo();
      return right(cached);
    } catch (e) {
      return left(ServerFailure('فشل في الحصول على المعلومات المحفوظة: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentAppVersion() async {
    try {
      final version = await _remoteDataSource.getCurrentAppVersion();
      return right(version);
    } catch (e) {
      return left(ServerFailure('فشل في الحصول على نسخة التطبيق: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markVersionAsSkipped(String version) async {
    try {
      await _cacheDataSource.cacheUserSkippedVersion(version);
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في تسجيل تخطي النسخة: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserSkippedVersion(String version) async {
    try {
      final hasSkipped = await _cacheDataSource.hasUserSkippedVersion(version);
      return right(hasSkipped);
    } catch (e) {
      return left(ServerFailure('فشل في التحقق من تخطي النسخة: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearSkippedVersion() async {
    try {
      await _cacheDataSource.clearSkippedVersion();
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في إزالة النسخة المتخطاة: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearVersionCache() async {
    try {
      await _cacheDataSource.clearVersionCache();
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في إزالة بيانات النسخ المحفوظة: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      if (ISCONNECTED) {
        await _remoteDataSource.initialize();
      }
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في تهيئة إدارة النسخ: $e'));
    }
  }

  @override
  Stream<AppVersionModel> watchConfigChanges() {
    if (!ISCONNECTED) return const Stream.empty();

    return _remoteDataSource.watchConfigChanges().map((versionModel) {
      _cacheDataSource.cacheVersionInfo(versionModel).catchError((_) {});
      return versionModel;
    });
  }

  @override
  Future<Either<Failure, void>> startListening() async {
    try {
      if (!ISCONNECTED)
        return left(ServerFailure('لا يمكن بدء المراقبة بدون إنترنت'));
      await _remoteDataSource.startListening();
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في بدء مراقبة التحديثات: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> stopListening() async {
    try {
      await _remoteDataSource.stopListening();
      return right(null);
    } catch (e) {
      return left(ServerFailure('فشل في إيقاف مراقبة التحديثات: $e'));
    }
  }
}
