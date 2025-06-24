import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/notification_orchestrator_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/setting_notification/data/seed/notification_settings_seeder.dart';
import 'package:quran_app/main.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState()) {
    on<InitializeNotificationEvent>(_onInitializeNotification);
    on<RescheduleNotificationEvent>(_onRescheduleNotification);
    on<CancelPendingNotificationEvent>(_onCancelPendingNotification);

    on<GetPendingNotificationsEvent>(_onGetPendingNotifications);
    on<GetActiveNotificationsEvent>(_onGetActiveNotifications);
  }
  final NotificationService _notificationService = sl();
  final NotificationOrchestratorService _tasksNotification = sl();

  Future<void> _onInitializeNotification(
    InitializeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationService.initialize();
    await NotificationSettingsSeeder().runIfNeeded();

    await _tasksNotification.rescheduleAllNotifications();
    emit(state.copyWith(state: RequestState.success));
    add(GetPendingNotificationsEvent());
    add(GetActiveNotificationsEvent());
  }

  Future<void> _onRescheduleNotification(
    RescheduleNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _tasksNotification.rescheduleAllNotifications();
  }

  Future<void> _onCancelPendingNotification(
    CancelPendingNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _tasksNotification.notificationService
          .cancelNotificationById(id: event.id);
      emit(state.copyWith(state: RequestState.success));
      add(GetPendingNotificationsEvent());
    } catch (e) {
      emit(state.copyWith(state: RequestState.error));
      logger.e('error in cancel pending notification: $e');
    }
  }

  Future<void> _onGetPendingNotifications(
    GetPendingNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(pendingNotificationsState: RequestState.loading));
      final pendingNotifications = await _tasksNotification.notificationService
          .getPendingNotifications();

      // logger.d(pendingNotifications);
      emit(
        state.copyWith(
          pendingNotifications: pendingNotifications,
          pendingNotificationsState: RequestState.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(pendingNotificationsState: RequestState.error));
      logger.e('error in get pending notifications: $e');
    }
  }

  Future<void> _onGetActiveNotifications(
    GetActiveNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(activeNotificationsState: RequestState.loading));
      final activeNotifications =
          await _tasksNotification.notificationService.getActiveNotifications();

      emit(
        state.copyWith(
          activeNotifications: activeNotifications,
          activeNotificationsState: RequestState.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(activeNotificationsState: RequestState.error));
      logger.e('error in get active notifications: $e');
    }
  }
}
