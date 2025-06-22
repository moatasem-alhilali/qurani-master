part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class InitializeNotificationEvent extends NotificationEvent {}

class SchedulePrayerNotificationEvent extends NotificationEvent {
  SchedulePrayerNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.channel = NotificationChannel.defaultChannel,
  });
  final int id;
  final String title;
  final String body;
  final TimeOfDay time;
  final NotificationChannel channel;
}

class ShowInstantNotificationEvent extends NotificationEvent {
  ShowInstantNotificationEvent({
    required this.title,
    required this.body,
    this.channel = NotificationChannel.defaultChannel,
  });
  final String title;
  final String body;
  final NotificationChannel channel;
}

class GetPendingNotificationsEvent extends NotificationEvent {}

class GetActiveNotificationsEvent extends NotificationEvent {}