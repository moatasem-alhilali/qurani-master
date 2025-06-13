import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/tasks_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService = NotificationService();
  final TasksNotification _tasksNotification = TasksNotification();

  NotificationBloc() : super(NotificationInitial()) {
    on<InitializeNotificationEvent>(_onInitializeNotification);
    on<SchedulePrayerNotificationEvent>(_onSchedulePrayerNotification);
    on<ShowInstantNotificationEvent>(_onShowInstantNotification);
  }

  Future<void> _onInitializeNotification(
    InitializeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationService.initialize();
    await _tasksNotification.sendNotification();
    emit(NotificationInitialized());
  }

  Future<void> _onSchedulePrayerNotification(
    SchedulePrayerNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationService.scheduleNotification(
      id: event.id,
      hour: event.time.hour,
      minute: event.time.minute,
      title: event.title,
      body: event.body,
      channel: event.channel,
    );
    emit(NotificationScheduled());
  }

  Future<void> _onShowInstantNotification(
    ShowInstantNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationService.showInstantNotification(
      title: event.title,
      body: event.body,
      channel: event.channel,
    );
    emit(NotificationShown());
  }
}
