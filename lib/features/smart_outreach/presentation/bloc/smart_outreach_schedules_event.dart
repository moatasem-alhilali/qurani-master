part of 'smart_outreach_schedules_bloc.dart';

abstract class SmartOutreachSchedulesEvent {
  const SmartOutreachSchedulesEvent();
}

class LoadSmartOutreachSchedulesEvent extends SmartOutreachSchedulesEvent {
  const LoadSmartOutreachSchedulesEvent({this.changeState = true});

  final bool changeState;
}

class SaveSmartOutreachScheduleEvent extends SmartOutreachSchedulesEvent {
  const SaveSmartOutreachScheduleEvent({
    this.scheduleId,
    required this.title,
    this.note,
    required this.hour,
    required this.minute,
    required this.isEnabled,
    this.smsTemplate,
    required this.contacts,
  });

  final int? scheduleId;
  final String title;
  final String? note;
  final int hour;
  final int minute;
  final bool isEnabled;
  final String? smsTemplate;
  final List<SmartOutreachContactDraft> contacts;
}

class ToggleSmartOutreachScheduleEnabledEvent
    extends SmartOutreachSchedulesEvent {
  const ToggleSmartOutreachScheduleEnabledEvent({
    required this.scheduleId,
    required this.enabled,
  });

  final int scheduleId;
  final bool enabled;
}

class DeleteSmartOutreachScheduleEvent extends SmartOutreachSchedulesEvent {
  const DeleteSmartOutreachScheduleEvent(this.scheduleId);

  final int scheduleId;
}

class PreviewSmartOutreachScheduleNotificationEvent
    extends SmartOutreachSchedulesEvent {
  const PreviewSmartOutreachScheduleNotificationEvent(this.scheduleId);

  final int scheduleId;
}

class ClearSmartOutreachScheduleFeedbackEvent
    extends SmartOutreachSchedulesEvent {
  const ClearSmartOutreachScheduleFeedbackEvent();
}
