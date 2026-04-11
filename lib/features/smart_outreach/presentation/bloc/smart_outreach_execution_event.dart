part of 'smart_outreach_execution_bloc.dart';

abstract class SmartOutreachExecutionEvent {
  const SmartOutreachExecutionEvent();
}

class StartSmartOutreachSessionEvent extends SmartOutreachExecutionEvent {
  const StartSmartOutreachSessionEvent({
    required this.scheduleId,
    this.launchedFromNotification = false,
  });

  final int scheduleId;
  final bool launchedFromNotification;
}

class RefreshSmartOutreachSessionEvent extends SmartOutreachExecutionEvent {
  const RefreshSmartOutreachSessionEvent();
}

class LaunchCurrentContactCallEvent extends SmartOutreachExecutionEvent {
  const LaunchCurrentContactCallEvent();
}

class SendCurrentContactSmsEvent extends SmartOutreachExecutionEvent {
  const SendCurrentContactSmsEvent();
}

class MarkCurrentContactAnsweredEvent extends SmartOutreachExecutionEvent {
  const MarkCurrentContactAnsweredEvent();
}

class MarkCurrentContactNotAnsweredEvent extends SmartOutreachExecutionEvent {
  const MarkCurrentContactNotAnsweredEvent();
}

class SkipCurrentContactEvent extends SmartOutreachExecutionEvent {
  const SkipCurrentContactEvent();
}

class MoveToNextContactEvent extends SmartOutreachExecutionEvent {
  const MoveToNextContactEvent();
}

class FinishSmartOutreachSessionEvent extends SmartOutreachExecutionEvent {
  const FinishSmartOutreachSessionEvent();
}

class ClearSmartOutreachExecutionFeedbackEvent
    extends SmartOutreachExecutionEvent {
  const ClearSmartOutreachExecutionFeedbackEvent();
}
