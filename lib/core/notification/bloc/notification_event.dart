part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class InitializeNotificationEvent extends NotificationEvent {}

class SchedulePrayerNotificationEvent extends NotificationEvent {
  final int id;
  final String title;
  final String body;
  final TimeOfDay time;
  final NotificationChannel channel;

  SchedulePrayerNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.channel = NotificationChannel.defaultChannel,
  });
}

class ShowInstantNotificationEvent extends NotificationEvent {
  final String title;
  final String body;
  final NotificationChannel channel;

  ShowInstantNotificationEvent({
    required this.title,
    required this.body,
    this.channel = NotificationChannel.defaultChannel,
  });
}
