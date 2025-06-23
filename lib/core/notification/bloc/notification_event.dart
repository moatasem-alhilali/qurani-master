part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class InitializeNotificationEvent extends NotificationEvent {}

class RescheduleNotificationEvent extends NotificationEvent {}

class GetPendingNotificationsEvent extends NotificationEvent {}

class GetActiveNotificationsEvent extends NotificationEvent {}

class CancelPendingNotificationEvent extends NotificationEvent {
  CancelPendingNotificationEvent({required this.id});
  final int id;
}
