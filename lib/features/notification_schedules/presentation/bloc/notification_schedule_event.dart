part of 'notification_schedule_bloc.dart';

abstract class NotificationScheduleEvent {}

class LoadSchedules extends NotificationScheduleEvent {}

class AddSchedule extends NotificationScheduleEvent {
  AddSchedule(this.model);
  final NotificationScheduleCustomModel model;
}

class EditSchedule extends NotificationScheduleEvent {
  EditSchedule(this.model);
  final NotificationScheduleCustomModel model;
}

class DeleteSchedule extends NotificationScheduleEvent {
  DeleteSchedule(this.id);
  final int id;
}

class ToggleSchedule extends NotificationScheduleEvent {
  ToggleSchedule(this.model);
  final NotificationScheduleCustomModel model;
}

class ClearError extends NotificationScheduleEvent {}
