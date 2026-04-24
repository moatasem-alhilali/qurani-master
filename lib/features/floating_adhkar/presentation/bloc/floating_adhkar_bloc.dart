import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_counts.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_overlay_command.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_overlay_controller.dart';

part 'floating_adhkar_event.dart';
part 'floating_adhkar_state.dart';

class FloatingAdhkarBloc
    extends Bloc<FloatingAdhkarEvent, FloatingAdhkarState> {
  FloatingAdhkarBloc({
    required FloatingAdhkarRepository repository,
    required FloatingAdhkarOverlayController overlayController,
  })  : _repository = repository,
        _overlayController = overlayController,
        super(const FloatingAdhkarState()) {
    on<FloatingAdhkarLoadEvent>(_onLoad);
    on<FloatingAdhkarToggleFeatureEvent>(_onToggleFeature);
    on<FloatingAdhkarUpdateSettingsEvent>(_onUpdateSettings);
    on<FloatingAdhkarSetCustomItemEnabledEvent>(_onSetCustomItemEnabled);
    on<FloatingAdhkarSetBuiltInItemEnabledEvent>(_onSetBuiltInItemEnabled);
    on<FloatingAdhkarUpdateBuiltInItemEvent>(_onUpdateBuiltInItem);
    on<FloatingAdhkarDeleteBuiltInItemEvent>(_onDeleteBuiltInItem);
    on<FloatingAdhkarRestoreBuiltInItemEvent>(_onRestoreBuiltInItem);
    on<FloatingAdhkarResetBuiltInItemEvent>(_onResetBuiltInItem);
    on<FloatingAdhkarRequestOverlayPermissionEvent>(
      _onRequestOverlayPermission,
    );
    on<FloatingAdhkarPreviewNowEvent>(_onPreviewNow);
    on<FloatingAdhkarRefreshOverlayStatusEvent>(_onRefreshOverlayStatus);
  }

  final FloatingAdhkarRepository _repository;
  final FloatingAdhkarOverlayController _overlayController;

  Future<void> _onLoad(
    FloatingAdhkarLoadEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        loadState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );
    await _refreshState(emit, loadState: RequestState.success);
  }

  Future<void> _onToggleFeature(
    FloatingAdhkarToggleFeatureEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final settings = state.settings ?? await _repository.loadSettings();

    if (event.enabled) {
      final supported = _overlayController.isSupportedPlatform;
      if (!supported) {
        emit(
          state.copyWith(
            actionState: RequestState.error,
            errorMessage: 'الميزة متاحة على أندرويد فقط.',
          ),
        );
        return;
      }

      var granted = await _overlayController.hasPermission();
      if (!granted) {
        granted = await _overlayController.requestPermission();
      }

      if (!granted) {
        await _refreshState(
          emit,
          actionState: RequestState.error,
          errorMessage: 'يجب منح صلاحية الظهور فوق التطبيقات الأخرى أولًا.',
        );
        return;
      }
    }

    final updated = settings.copyWith(
      enabled: event.enabled,
      updatedAt: DateTime.now(),
    );
    await _repository.updateSettings(updated);

    if (event.enabled) {
      await _overlayController.startService();
      await _overlayController.sendCommand(
        const FloatingAdhkarOverlayCommand(
          type: FloatingAdhkarOverlayCommandType.previewNow,
        ),
      );
    } else {
      await _overlayController.stopService();
    }

    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onUpdateSettings(
    FloatingAdhkarUpdateSettingsEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    if (!event.settings.hasAnySource) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'فعّل مصدرًا واحدًا على الأقل للأذكار العائمة.',
        ),
      );
      return;
    }

    await _repository.updateSettings(
      event.settings.copyWith(updatedAt: DateTime.now()),
    );

    if (event.settings.enabled) {
      final granted = await _overlayController.hasPermission();
      if (!granted) {
        emit(
          state.copyWith(
            actionState: RequestState.error,
            errorMessage: 'الصلاحية مطلوبة لتشغيل النافذة العائمة.',
          ),
        );
        await _refreshState(emit);
        return;
      }

      await _overlayController.startService();
      await _overlayController.sendCommand(
        const FloatingAdhkarOverlayCommand(
          type: FloatingAdhkarOverlayCommandType.reload,
        ),
      );
    } else {
      await _overlayController.stopService();
    }

    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onSetCustomItemEnabled(
    FloatingAdhkarSetCustomItemEnabledEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    await _repository.setCustomItemEnabled(event.subihId, event.enabled);
    await _reloadOverlayIfNeeded();

    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onSetBuiltInItemEnabled(
    FloatingAdhkarSetBuiltInItemEnabledEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    await _repository.setBuiltInItemEnabled(
      itemId: event.itemId,
      enabled: event.enabled,
    );
    await _reloadOverlayIfNeeded();
    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onUpdateBuiltInItem(
    FloatingAdhkarUpdateBuiltInItemEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    if (event.title.trim().isEmpty || event.text.trim().isEmpty) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'العنوان والنص مطلوبان لتحديث الذكر الافتراضي.',
        ),
      );
      return;
    }

    await _repository.updateBuiltInItem(
      itemId: event.itemId,
      title: event.title,
      text: event.text,
    );
    await _reloadOverlayIfNeeded();
    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onDeleteBuiltInItem(
    FloatingAdhkarDeleteBuiltInItemEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    await _repository.deleteBuiltInItem(event.itemId);
    await _reloadOverlayIfNeeded();
    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onRestoreBuiltInItem(
    FloatingAdhkarRestoreBuiltInItemEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    await _repository.restoreBuiltInItem(event.itemId);
    await _reloadOverlayIfNeeded();
    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onResetBuiltInItem(
    FloatingAdhkarResetBuiltInItemEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    await _repository.resetBuiltInItem(event.itemId);
    await _reloadOverlayIfNeeded();
    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onRequestOverlayPermission(
    FloatingAdhkarRequestOverlayPermissionEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final granted = await _overlayController.requestPermission();
    await _refreshState(
      emit,
      actionState: granted ? RequestState.success : RequestState.error,
      errorMessage:
          granted ? null : 'لم يتم منح صلاحية الظهور فوق التطبيقات الأخرى.',
    );
  }

  Future<void> _onPreviewNow(
    FloatingAdhkarPreviewNowEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    emit(
      state.copyWith(
        actionState: RequestState.loading,
        clearErrorMessage: true,
      ),
    );

    final settings = state.settings ?? await _repository.loadSettings();
    if (!settings.enabled) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'فعّل الميزة أولًا ثم استخدم المعاينة المباشرة.',
        ),
      );
      return;
    }

    final granted = await _overlayController.hasPermission();
    if (!granted) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: 'الصلاحية مطلوبة لعرض الذكر العائم.',
        ),
      );
      return;
    }

    await _overlayController.startService();
    await _overlayController.sendCommand(
      const FloatingAdhkarOverlayCommand(
        type: FloatingAdhkarOverlayCommandType.previewNow,
      ),
    );

    await _refreshState(emit, actionState: RequestState.success);
  }

  Future<void> _onRefreshOverlayStatus(
    FloatingAdhkarRefreshOverlayStatusEvent event,
    Emitter<FloatingAdhkarState> emit,
  ) async {
    await _refreshState(emit);
  }

  Future<void> _refreshState(
    Emitter<FloatingAdhkarState> emit, {
    RequestState? loadState,
    RequestState? actionState,
    String? errorMessage,
  }) async {
    final settings = await _repository.loadSettings();
    final counts = await _repository.loadCounts();
    final previewItem = await _repository.loadPreviewItem(settings: settings);
    final builtInItems =
        await _repository.loadBuiltInItems(includeDeleted: true);
    final selectionMap = await _repository.loadCustomSelectionMap();
    final isSupportedPlatform = _overlayController.isSupportedPlatform;
    final hasPermission =
        isSupportedPlatform && await _overlayController.hasPermission();
    final isOverlayActive =
        isSupportedPlatform && await _overlayController.isServiceActive();

    emit(
      state.copyWith(
        loadState: loadState ?? state.loadState,
        actionState: actionState ?? state.actionState,
        settings: settings,
        counts: counts,
        previewItem: previewItem,
        builtInItems: builtInItems,
        customSelectionMap: selectionMap,
        isSupportedPlatform: isSupportedPlatform,
        hasOverlayPermission: hasPermission,
        isOverlayActive: isOverlayActive,
        errorMessage: errorMessage,
        clearErrorMessage: errorMessage == null,
      ),
    );
  }

  Future<void> _reloadOverlayIfNeeded() async {
    final settings = state.settings ?? await _repository.loadSettings();
    if (!settings.enabled) {
      return;
    }

    await _overlayController.sendCommand(
      const FloatingAdhkarOverlayCommand(
        type: FloatingAdhkarOverlayCommandType.reload,
      ),
    );
  }
}
