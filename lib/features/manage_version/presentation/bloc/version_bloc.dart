import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/download/data/repo/download_repo.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/features/manage_version/data/models/download_link_model.dart';
import 'package:quran_app/features/manage_version/data/repositories/version_repository_impl.dart';
import 'package:quran_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

part 'version_event.dart';
part 'version_state.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  VersionBloc({
    required VersionRepository versionRepository,
    DownloadRepo? downloadRepo,
    ConnectivityBloc? connectivityBloc,
  })  : _versionRepository = versionRepository,
        _downloadRepo = downloadRepo ?? DownloadRepo(),
        _connectivityBloc = connectivityBloc,
        super(const VersionState()) {
    on<InitializeVersionManagementEvent>(_onInitialize);
    on<CheckForUpdatesEvent>(_onCheckForUpdates);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<ConfigChangedEvent>(_onConfigChanged);
    on<GetCachedVersionEvent>(_onGetCachedVersion);
    on<GetCurrentVersionEvent>(_onGetCurrentVersion);
    on<ProcessDownloadLinkEvent>(_onProcessDownloadLink);
    on<StartDownloadEvent>(_onStartDownload);
    on<PauseDownloadEvent>(_onPauseDownload);
    on<ResumeDownloadEvent>(_onResumeDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
    on<SkipVersionEvent>(_onSkipVersion);
    on<ClearSkippedVersionEvent>(_onClearSkippedVersion);
    on<ClearVersionCacheEvent>(_onClearVersionCache);
    on<ShowUpdateDialogEvent>(_onShowUpdateDialog);
    on<DismissUpdateDialogEvent>(_onDismissUpdateDialog);
    on<DownloadProgressUpdateEvent>(_onDownloadProgressUpdate);
    on<DownloadStatusUpdateEvent>(_onDownloadStatusUpdate);
    on<OpenDownloadedFileEvent>(_onOpenDownloadedFile);
    on<ResetVersionStateEvent>(_onResetVersionState);

    _initializeDownloadCallbacks();
    _initializeConnectivityListener();
    _initializeConfigChangesListener();
  }

  final VersionRepository _versionRepository;
  final DownloadRepo _downloadRepo;
  final ConnectivityBloc? _connectivityBloc;
  String? _currentDownloadTaskId;
  StreamSubscription<ConnectivityState>? _connectivitySubscription;
  StreamSubscription<AppVersionModel>? _configChangesSubscription;

  void _initializeDownloadCallbacks() {
    _downloadRepo.onProgress = (taskId, progress) {
      if (taskId == _currentDownloadTaskId) {
        add(DownloadProgressUpdateEvent(progress: progress));
      }
    };

    _downloadRepo.onStatusChanged = (taskId, status) {
      if (taskId == _currentDownloadTaskId) {
        final downloadStatus = _mapDownloadTaskStatus(status);
        add(DownloadStatusUpdateEvent(status: downloadStatus));
      }
    };
  }

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

  DownloadStatus _mapDownloadTaskStatus(dynamic status) {
    final statusString = status.toString().toLowerCase();

    if (statusString.contains('running') || statusString.contains('enqueued')) {
      return DownloadStatus.downloading;
    } else if (statusString.contains('paused')) {
      return DownloadStatus.paused;
    } else if (statusString.contains('complete')) {
      return DownloadStatus.completed;
    } else if (statusString.contains('failed')) {
      return DownloadStatus.failed;
    } else if (statusString.contains('canceled')) {
      return DownloadStatus.cancelled;
    }

    return DownloadStatus.none;
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

    // Show update dialog if needed (automatic check)
    if (event.versionModel.isUpdateAvailable) {
      _checkAndShowUpdateDialog(event.versionModel);
    }
  }

  Future<void> _onCheckForUpdates(
    CheckForUpdatesEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
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
        (versionModel) {
          emit(
            state.copyWith(
              versionCheckState: RequestState.success,
              latestVersionInfo: versionModel,
              currentVersion: versionModel.currentVersion,
              isConnected: ISCONNECTED,
            ),
          );
          logger.d(versionModel.toString());

          // Show update dialog if needed
          if (versionModel.isUpdateAvailable) {
            _checkAndShowUpdateDialog(
              versionModel,
              isManualCheck: event.isManualCheck,
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          versionCheckState: RequestState.error,
          errorMessage: 'فشل في التحقق من التحديثات: $e',
          isConnected: ISCONNECTED,
        ),
      );
    }
  }

  Future<void> _checkAndShowUpdateDialog(
    AppVersionModel versionModel, {
    bool isManualCheck = false,
  }) async {
    try {
      // Don't show dialog if it's already visible
      if (state.isUpdateDialogVisible) return;

      final shouldShowResult = await _versionRepository.shouldShowUpdateDialog(
        versionModel,
        isManualCheck: isManualCheck,
      );

      shouldShowResult.fold(
        (failure) => logger.e('Failed to check dialog: ${failure.message}'),
        (shouldShow) {
          if (shouldShow && !state.isUpdateDialogVisible) {
            add(ShowUpdateDialogEvent(versionModel: versionModel));
          }
        },
      );
    } catch (e) {
      logger.e('Error checking update dialog: $e');
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

  Future<void> _onProcessDownloadLink(
    ProcessDownloadLinkEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      final result =
          await _versionRepository.getDownloadLink(event.downloadUrl);
      result.fold(
        (failure) => emit(
          state.copyWith(
            downloadState: RequestState.error,
            errorMessage: failure.message,
          ),
        ),
        (downloadLink) {
          emit(
            state.copyWith(
              downloadState: RequestState.success,
              downloadLink: downloadLink,
            ),
          );
          logger.d(downloadLink.toJson());
          // Automatically start download after processing the link
          add(StartDownloadEvent(downloadLink: downloadLink));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          downloadState: RequestState.error,
          errorMessage: 'فشل في معالجة رابط التحميل: $e',
        ),
      );
    }
  }

  Future<void> _onStartDownload(
    StartDownloadEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          downloadState: RequestState.loading,
          downloadStatus: DownloadStatus.initializing,
          downloadProgress: 0,
        ),
      );

      switch (event.downloadLink.downloadApproach) {
        case DownloadApproach.direct:
        case DownloadApproach.processedDirect:
          await _startDirectDownload(event.downloadLink, event.fileName, emit);
        case DownloadApproach.webView:
          await _startWebViewDownload(event.downloadLink, emit);
      }
    } catch (e) {
      emit(
        state.copyWith(
          downloadState: RequestState.error,
          downloadStatus: DownloadStatus.failed,
          errorMessage: 'فشل في بدء التحميل: $e',
        ),
      );
    }
  }

  Future<void> _startDirectDownload(
    DownloadLinkModel downloadLink,
    String? fileName,
    Emitter<VersionState> emit,
  ) async {
    final taskId = await _downloadRepo.download(
      url: downloadLink.getProcessedUrl(),
      fileName: fileName ?? 'app_update.apk',
    );

    if (taskId != null) {
      _currentDownloadTaskId = taskId;
      emit(
        state.copyWith(
          downloadState: RequestState.success,
          downloadStatus: DownloadStatus.downloading,
        ),
      );
    } else {
      throw Exception('Failed to start download');
    }
  }

  Future<void> _startWebViewDownload(
    DownloadLinkModel downloadLink,
    Emitter<VersionState> emit,
  ) async {
    final uri = Uri.parse(downloadLink.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      emit(
        state.copyWith(
          downloadState: RequestState.success,
          downloadStatus: DownloadStatus.none,
        ),
      );
    } else {
      throw Exception('Cannot launch URL: ${downloadLink.url}');
    }
  }

  Future<void> _onPauseDownload(
    PauseDownloadEvent event,
    Emitter<VersionState> emit,
  ) async {
    if (_currentDownloadTaskId != null) {
      await _downloadRepo.pause(taskId: _currentDownloadTaskId!);
      emit(state.copyWith(downloadStatus: DownloadStatus.paused));
    }
  }

  Future<void> _onResumeDownload(
    ResumeDownloadEvent event,
    Emitter<VersionState> emit,
  ) async {
    if (_currentDownloadTaskId != null) {
      final newTaskId =
          await _downloadRepo.resume(taskId: _currentDownloadTaskId!);
      if (newTaskId != null) _currentDownloadTaskId = newTaskId;
      emit(state.copyWith(downloadStatus: DownloadStatus.downloading));
    }
  }

  Future<void> _onCancelDownload(
    CancelDownloadEvent event,
    Emitter<VersionState> emit,
  ) async {
    if (_currentDownloadTaskId != null) {
      await _downloadRepo.cancel(taskId: _currentDownloadTaskId!);
      _currentDownloadTaskId = null;
      emit(
        state.copyWith(
          downloadStatus: DownloadStatus.cancelled,
          downloadProgress: 0,
        ),
      );
    }
  }

  Future<void> _onSkipVersion(
    SkipVersionEvent event,
    Emitter<VersionState> emit,
  ) async {
    final result = await _versionRepository.markVersionAsSkipped(event.version);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(DismissUpdateDialogEvent()),
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

  void _onShowUpdateDialog(
    ShowUpdateDialogEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(
      state.copyWith(
        isUpdateDialogVisible: true,
        latestVersionInfo: event.versionModel,
      ),
    );
  }

  void _onDismissUpdateDialog(
    DismissUpdateDialogEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(state.copyWith(isUpdateDialogVisible: false));
  }

  void _onDownloadProgressUpdate(
    DownloadProgressUpdateEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(
      state.copyWith(
        downloadProgress: event.progress,
        downloadedBytes: event.downloadedBytes ?? state.downloadedBytes,
        totalBytes: event.totalBytes ?? state.totalBytes,
      ),
    );
  }

  void _onDownloadStatusUpdate(
    DownloadStatusUpdateEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(state.copyWith(downloadStatus: event.status));
    if (event.status == DownloadStatus.completed) {
      _handleDownloadCompletion();
    }
  }

  Future<void> _handleDownloadCompletion() async {
    if (_currentDownloadTaskId != null) {
      final task = await _downloadRepo.getTaskById(_currentDownloadTaskId!);
      if (task != null) {
        final filePath = '${task.savedDir}/${task.fileName}';
        add(OpenDownloadedFileEvent(filePath: filePath));
      }
    }
  }

  Future<void> _onOpenDownloadedFile(
    OpenDownloadedFileEvent event,
    Emitter<VersionState> emit,
  ) async {
    try {
      final file = File(event.filePath);
      if (await file.exists()) {
        if (_currentDownloadTaskId != null) {
          await _downloadRepo.open(taskId: _currentDownloadTaskId!);
        }
        emit(state.copyWith(downloadFilePath: event.filePath));
      } else {
        emit(state.copyWith(errorMessage: 'الملف المحمل غير موجود'));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل في فتح الملف المحمل'));
    }
  }

  void _onResetVersionState(
    ResetVersionStateEvent event,
    Emitter<VersionState> emit,
  ) {
    emit(const VersionState());
    _currentDownloadTaskId = null;
  }
}
