import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/features/manage_version/data/repositories/version_repository_impl.dart';
import 'package:quran_app/main.dart';

part 'version_event.dart';
part 'version_state.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  VersionBloc({
    required VersionRepository versionRepository,
    ConnectivityBloc? connectivityBloc,
  })  : _versionRepository = versionRepository,
        _connectivityBloc = connectivityBloc,
        super(const VersionState()) {
    on<InitializeVersionManagementEvent>(_onInitialize);
    on<CheckForUpdatesEvent>(_onCheckForUpdates);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<ConfigChangedEvent>(_onConfigChanged);
    on<GetCachedVersionEvent>(_onGetCachedVersion);
    on<GetCurrentVersionEvent>(_onGetCurrentVersion);
    on<OpenDownloadLinkEvent>(_onOpenDownloadLink);
    on<SkipVersionEvent>(_onSkipVersion);
    on<ClearSkippedVersionEvent>(_onClearSkippedVersion);
    on<ClearVersionCacheEvent>(_onClearVersionCache);
    on<ResetVersionStateEvent>(_onResetVersionState);

    _initializeConnectivityListener();
    _initializeConfigChangesListener();
  }

  final VersionRepository _versionRepository;
  final ConnectivityBloc? _connectivityBloc;
  StreamSubscription<ConnectivityState>? _connectivitySubscription;
  StreamSubscription<AppVersionModel>? _configChangesSubscription;

  void _initializeConnectivityListener() {
    _connectivitySubscription =
        _connectivityBloc?.stream.listen((connectivityState) {
      add(ConnectivityChangedEvent(isConnected: connectivityState.isConnected));
    });
  }

  void _initializeConfigChangesListener() {
    _configChangesSubscription = _versionRepository.watchConfigChanges().listen(
      (versionModel) {
        add(ConfigChangedEvent(versionModel: versionModel));
      },
      onError: (error) {
        logger.e('Config changes stream error: $error');
      },
    );
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _configChangesSubscription?.cancel();
    await _versionRepository.stopListening();
    return super.close();
  }

  Future<void> _onInitialize(
    InitializeVersionManagementEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          versionCheckState: RequestState.loading,
          isConnected: ISCONNECTED,
          isListening: false,
        ),
      );

      final result = await _versionRepository.initialize();

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              versionCheckState: RequestState.error,
              errorMessage: failure.message,
              isConnected: ISCONNECTED,
            ),
          );
        },
        (_) {
          emit(
            state.copyWith(
              versionCheckState: RequestState.success,
              isConnected: ISCONNECTED,
              isListening: _versionRepository.isListening,
            ),
          );

          // Start listening and check for updates
          if (ISCONNECTED) {
            _versionRepository.startListening();
          }
          add(CheckForUpdatesEvent());
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          versionCheckState: RequestState.error,
          errorMessage: 'فشل في تهيئة إدارة النسخ: $e',
          isConnected: ISCONNECTED,
        ),
      );
    }
  }

  Future<void> _onConnectivityChanged(
    ConnectivityChangedEvent event,
    Emitter<VersionState> emit,
  ) async {
    emit(state.copyWith(isConnected: event.isConnected));

    if (event.isConnected) {
      // When going online, start listening and check for updates
      _versionRepository.startListening();
      add(CheckForUpdatesEvent(forceRefresh: true));
    } else {
      // When going offline, stop listening
      _versionRepository.stopListening();
    }
  }

  Future<void> _onConfigChanged(
    ConfigChangedEvent event,
    Emitter<VersionState> emit,
  ) async {
    emit(
      state.copyWith(
        latestVersionInfo: event.versionModel,
        currentVersion: event.versionModel.currentVersion,
        versionCheckState: RequestState.success,
      ),
    );
  }

  Future<void> _onCheckForUpdates(
    CheckForUpdatesEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      logger.d('=== Starting update check ===');
      logger.d('Force refresh: ${event.forceRefresh}');
      logger.d('Is manual check: ${event.isManualCheck}');
      logger.d('Current ISCONNECTED: $ISCONNECTED');
      logger.d('Current state has update: ${state.hasUpdateAvailable}');

      emit(
        state.copyWith(
          versionCheckState: RequestState.loading,
          isConnected: ISCONNECTED,
        ),
      );

      final result = await _versionRepository.checkForUpdates(
        forceRefresh: event.forceRefresh,
        isManualCheck: event.isManualCheck,
      );

      await result.fold(
        (failure) async {
          logger.e('Update check failed: ${failure.message}');
          emit(
            state.copyWith(
              versionCheckState: RequestState.error,
              errorMessage: failure.message,
              isConnected: ISCONNECTED,
            ),
          );
        },
        (versionModel) async {
          logger.d('Update check successful!');
          emit(
            state.copyWith(
              versionCheckState: RequestState.success,
              latestVersionInfo: versionModel,
              currentVersion: versionModel.currentVersion,
              isConnected: ISCONNECTED,
            ),
          );

          logger.d('Version check result: $versionModel');
          logger.d('Update available: ${versionModel.isUpdateAvailable}');
          logger.d('Current version: ${versionModel.currentVersion}');
          logger.d('Latest version: ${versionModel.latestVersion}');

          // No dialog logic needed - version management screen will handle display
          if (versionModel.isUpdateAvailable) {
            logger.d(
              'Update is available - can be viewed in version management screen',
            );
          } else {
            logger.d('No update available');
          }
        },
      );

      logger.d('=== Update check completed ===');
    } catch (e) {
      logger.e('Unexpected error in _onCheckForUpdates: $e');
      emit(
        state.copyWith(
          versionCheckState: RequestState.error,
          errorMessage: 'فشل في التحقق من التحديثات: $e',
          isConnected: ISCONNECTED,
        ),
      );
    }
  }

  Future<void> _onGetCachedVersion(
    GetCachedVersionEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.getCachedVersionInfo();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (cachedVersion) {
        if (cachedVersion != null) {
          emit(
            state.copyWith(
              latestVersionInfo: cachedVersion,
              currentVersion: cachedVersion.currentVersion,
            ),
          );
        }
      },
    );
  }

  Future<void> _onGetCurrentVersion(
    GetCurrentVersionEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.getCurrentAppVersion();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (version) => emit(state.copyWith(currentVersion: version)),
    );
  }

  Future<void> _onOpenDownloadLink(
    OpenDownloadLinkEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      if (await UrlLauncherUtils.canLaunchWebUrl(event.downloadUrl)) {
        await UrlLauncherUtils.launchWebUrl(event.downloadUrl);
        emit(state.copyWith(downloadFilePath: event.downloadUrl));
      } else {
        logger.d('لا يمكن فتح الرابط: ${event.downloadUrl}');
        emit(
          state.copyWith(
            errorMessage: 'لا يمكن فتح الرابط: ${event.downloadUrl}',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل في فتح الرابط: $e'));
    }
  }

  Future<void> _onSkipVersion(
    SkipVersionEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.markVersionAsSkipped(event.version);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => null, // No dialog to dismiss
    );
  }

  Future<void> _onClearSkippedVersion(
    ClearSkippedVersionEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.clearSkippedVersion();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => null,
    );
  }

  Future<void> _onClearVersionCache(
    ClearVersionCacheEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.clearVersionCache();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(versionCheckState: RequestState.initial)),
    );
  }

  void _onResetVersionState(
    ResetVersionStateEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(const VersionState());
  }
}
