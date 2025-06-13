part of 'notification_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationInitialized extends NotificationState {}

class NotificationScheduled extends NotificationState {}

class NotificationShown extends NotificationState {}
