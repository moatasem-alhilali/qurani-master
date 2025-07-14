import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/main.dart';

/// Remote data source for version management using Firebase Remote Config
abstract class VersionRemoteDataSource {
  Future<AppVersionModel> checkForUpdates(
      {bool forceRefresh = false, bool isManualCheck = false});
  Future<String> getCurrentAppVersion();
  Future<void> initialize();
  Stream<AppVersionModel> watchConfigChanges();
  Future<void> startListening();
  Future<void> stopListening();
  bool get isListening;
  void dispose();
}

class VersionRemoteDataSourceImpl implements VersionRemoteDataSource {
  VersionRemoteDataSourceImpl({
    FirebaseRemoteConfig? remoteConfig,
    PackageInfo? packageInfo,
  })  : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance,
        _packageInfo = packageInfo;

  final FirebaseRemoteConfig _remoteConfig;
  PackageInfo? _packageInfo;
  StreamSubscription<RemoteConfigUpdate>? _configSubscription;
  final StreamController<AppVersionModel> _configChangesController =
      StreamController<AppVersionModel>.broadcast();

  // Remote Config keys
  static const _keys = {
    'latest': 'app_latest_version',
    'minimum': 'app_minimum_version',
    'url': 'app_download_url',
    'notes': 'app_release_notes',
    'priority': 'app_update_priority',
    'size': 'app_download_size',
  };

  // Default values
  static const _defaults = {
    'app_latest_version': '1.0.0',
    'app_minimum_version': '1.0.0',
    'app_download_url': '',
    'app_release_notes': 'تحديث جديد متاح',
    'app_update_priority': 'normal',
    'app_download_size': '',
  };

  @override
  bool get isListening => _configSubscription != null;

  @override
  Future<void> initialize() async {
    try {
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: const Duration(minutes: 5),
        ),
      );
      await _remoteConfig.fetchAndActivate();

      if (ISCONNECTED) await startListening();
    } catch (e) {
      logger.e('Failed to initialize Remote Config: $e');
      rethrow;
    }
  }

  @override
  Future<String> getCurrentAppVersion() async {
    try {
      _packageInfo ??= await PackageInfo.fromPlatform();
      return _packageInfo!.version;
    } catch (e) {
      logger.e('Failed to get app version: $e');
      return '1.0.0';
    }
  }

  @override
  Future<AppVersionModel> checkForUpdates(
      {bool forceRefresh = false, bool isManualCheck = false}) async {
    // For manual checks, attempt to connect regardless of global connectivity state
    // For automatic checks, respect the connectivity state
    if (!ISCONNECTED && !isManualCheck) {
      throw Exception('Device is offline');
    }

    try {
      if (forceRefresh) {
        await _remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 30),
            minimumFetchInterval: Duration.zero,
          ),
        );
        await _remoteConfig.fetchAndActivate();
        await _remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 30),
            minimumFetchInterval: const Duration(minutes: 5),
          ),
        );
      } else {
        await _remoteConfig.fetchAndActivate();
      }

      final currentVersion = await getCurrentAppVersion();
      final configData = <String, dynamic>{
        'latest_version': _remoteConfig.getString(_keys['latest']!),
        'minimum_required_version': _remoteConfig.getString(_keys['minimum']!),
        'download_url': _remoteConfig.getString(_keys['url']!),
        'release_notes': _remoteConfig.getString(_keys['notes']!),
        'update_priority': _remoteConfig.getString(_keys['priority']!),
        'download_size': _remoteConfig.getString(_keys['size']!),
      };

      return AppVersionModel.fromRemoteConfig(
        remoteConfigData: configData,
        currentVersion: currentVersion,
      );
    } catch (e) {
      logger.e('Failed to check for updates: $e');

      // For manual checks, provide a more informative error
      if (isManualCheck) {
        throw Exception(
            'فشل في الاتصال بالخادم. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.');
      }

      // For automatic checks, fall back to current version
      final currentVersion = await getCurrentAppVersion();
      return AppVersionModel(
        latestVersion: currentVersion,
        currentVersion: currentVersion,
        downloadUrl: '',
        isUpdateRequired: false,
        isUpdateAvailable: false,
        lastChecked: DateTime.now(),
      );
    }
  }

  @override
  Stream<AppVersionModel> watchConfigChanges() =>
      _configChangesController.stream;

  @override
  Future<void> startListening() async {
    if (!ISCONNECTED || isListening) return;

    try {
      _configSubscription = _remoteConfig.onConfigUpdated.listen(
        (event) async {
          if (event.updatedKeys.any((key) => _keys.values.contains(key))) {
            await _remoteConfig.activate();
            final versionModel = await checkForUpdates();
            _configChangesController.add(versionModel);
          }
        },
        onError: (error) => logger.e('Config stream error: $error'),
      );
    } catch (e) {
      logger.e('Failed to start listening: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    await _configSubscription?.cancel();
    _configSubscription = null;
  }

  @override
  void dispose() {
    stopListening();
    _configChangesController.close();
  }
}
