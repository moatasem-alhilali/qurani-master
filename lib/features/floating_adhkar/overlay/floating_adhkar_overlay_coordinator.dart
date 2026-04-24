import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_overlay_command.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/overlay/floating_adhkar_overlay_state.dart';

class FloatingAdhkarOverlayCoordinator {
  FloatingAdhkarOverlayCoordinator({
    required FloatingAdhkarRepository repository,
  }) : _repository = repository;

  static const int overlayWidth = 250;
  static const int overlayWindowWidth = overlayWidth + 22;
  static const int minVisibleHeight = 92;
  static const int maxVisibleHeight = 250;
  static const int hiddenHeight = 1;

  final FloatingAdhkarRepository _repository;
  final ValueNotifier<FloatingAdhkarOverlayState> notifier =
      ValueNotifier(const FloatingAdhkarOverlayState());

  StreamSubscription<dynamic>? _commandSubscription;
  Timer? _nextAppearanceTimer;
  Timer? _autoHideTimer;

  Future<void> initialize() async => _runGuarded('initialize', () async {
        _commandSubscription = FlutterOverlayWindow.overlayListener.listen(
          (raw) {
            unawaited(_handleRawCommand(raw));
          },
          onError: (Object error, StackTrace stackTrace) {
            _debugLog('overlayListener error: $error');
            debugPrintStack(stackTrace: stackTrace);
          },
        );

        await _hideOverlay();
        await reload();
      });

  Future<void> dispose() async {
    _cancelTimers();
    await _commandSubscription?.cancel();
    notifier.dispose();
  }

  Future<void> reload() async => _runGuarded('reload', () async {
        _cancelTimers();

        final settings = await _repository.loadSettings();
        notifier.value = notifier.value.copyWith(
          visible: false,
          settings: settings,
          clearCurrentItem: true,
        );

        if (!settings.enabled || !settings.hasAnySource) {
          await _hideOverlay();
          return;
        }

        if (!await _isServiceActive()) {
          await _hideOverlay();
          return;
        }

        _scheduleNextAppearance(
          Duration(minutes: settings.intervalMinutes),
        );
      });

  Future<void> showNow() async => _runGuarded('showNow', () async {
        _cancelTimers();

        final settings = await _repository.loadSettings();
        if (!settings.enabled || !settings.hasAnySource) {
          await _hideOverlay();
          notifier.value = notifier.value.copyWith(
            visible: false,
            settings: settings,
            clearCurrentItem: true,
          );
          return;
        }

        if (!await _isServiceActive()) {
          await _hideOverlay();
          notifier.value = notifier.value.copyWith(
            visible: false,
            settings: settings,
            clearCurrentItem: true,
          );
          return;
        }

        final nextItem = await _repository.pickNextItem(settings: settings);
        if (nextItem == null) {
          await _hideOverlay();
          notifier.value = notifier.value.copyWith(
            visible: false,
            settings: settings,
            clearCurrentItem: true,
          );
          return;
        }

        await _repository.recordShownItem(nextItem);
        await _showOverlay(nextItem);

        notifier.value = notifier.value.copyWith(
          visible: true,
          currentItem: nextItem,
          settings: settings,
        );

        _autoHideTimer = Timer(
          Duration(seconds: settings.visibleSeconds),
          () {
            unawaited(dismissCurrent());
          },
        );
      });

  Future<void> dismissCurrent() async =>
      _runGuarded('dismissCurrent', () async {
        _autoHideTimer?.cancel();
        _autoHideTimer = null;

        final settings = await _repository.loadSettings();
        await _hideOverlay();

        notifier.value = notifier.value.copyWith(
          visible: false,
          settings: settings,
        );

        if (settings.enabled &&
            settings.hasAnySource &&
            await _isServiceActive()) {
          _scheduleNextAppearance(Duration(minutes: settings.intervalMinutes));
        }
      });

  Future<void> _handleRawCommand(dynamic raw) async =>
      _runGuarded('handleRawCommand', () async {
        if (raw is! String || raw.trim().isEmpty) {
          return;
        }

        final command = FloatingAdhkarOverlayCommand.fromEncoded(raw);
        switch (command.type) {
          case FloatingAdhkarOverlayCommandType.reload:
            await reload();
          case FloatingAdhkarOverlayCommandType.previewNow:
            await showNow();
        }
      });

  void _scheduleNextAppearance(Duration delay) {
    _nextAppearanceTimer?.cancel();
    _nextAppearanceTimer = Timer(delay, () {
      unawaited(showNow());
    });
  }

  void _cancelTimers() {
    _nextAppearanceTimer?.cancel();
    _nextAppearanceTimer = null;
    _autoHideTimer?.cancel();
    _autoHideTimer = null;
  }

  Future<void> _showOverlay(FloatingAdhkarItem item) async {
    await _safeResizeOverlay(
      overlayWindowWidth,
      _estimateVisibleHeight(item),
      false,
    );
    await _safeUpdateFlag(OverlayFlag.focusPointer);
  }

  Future<void> _hideOverlay() async {
    await _safeUpdateFlag(OverlayFlag.clickThrough);
    await _safeResizeOverlay(
      overlayWindowWidth,
      hiddenHeight,
      false,
    );
  }

  Future<void> _safeUpdateFlag(OverlayFlag flag) async {
    try {
      await FlutterOverlayWindow.updateFlag(flag);
    } on MissingPluginException {
      _debugLog(
        'updateFlag(${flag.name}) skipped because overlay channel is '
        'unavailable.',
      );
    } on PlatformException catch (error) {
      _debugLog('updateFlag(${flag.name}) failed: $error');
    }
  }

  Future<void> _safeResizeOverlay(
    int width,
    int height,
    bool enableDrag,
  ) async {
    try {
      await FlutterOverlayWindow.resizeOverlay(width, height, enableDrag);
    } on MissingPluginException {
      _debugLog(
        'resizeOverlay($width, $height) skipped because overlay channel is '
        'unavailable.',
      );
    } on PlatformException catch (error) {
      _debugLog('resizeOverlay($width, $height) failed: $error');
    }
  }

  Future<bool> _isServiceActive() async {
    try {
      return await FlutterOverlayWindow.isActive();
    } on MissingPluginException {
      _debugLog('isActive skipped because overlay channel is unavailable.');
      return false;
    } on PlatformException catch (error) {
      _debugLog('isActive failed: $error');
      return false;
    }
  }

  Future<void> _runGuarded(
    String operation,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (error, stackTrace) {
      _debugLog('$operation failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _debugLog(String message) {
    debugPrint('FloatingAdhkarOverlayCoordinator: $message');
  }

  int _estimateVisibleHeight(FloatingAdhkarItem item) {
    final normalizedLength = item.normalizedText.length;
    final estimatedLines = (normalizedLength / 14).ceil().clamp(2, 8);
    final estimatedHeight = 40 + (estimatedLines * 24);
    return estimatedHeight.clamp(minVisibleHeight, maxVisibleHeight);
  }
}
