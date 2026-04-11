part of 'smart_outreach_execution_bloc.dart';

class SmartOutreachExecutionState {
  const SmartOutreachExecutionState({
    this.loadState = RequestState.initial,
    this.sessionBundle,
    this.awaitingCallOutcome = false,
    this.awaitingSmsFallback = false,
    this.autoPilotEnabled = true,
    this.message,
  });

  final RequestState loadState;
  final SmartOutreachSessionBundle? sessionBundle;
  final bool awaitingCallOutcome;
  final bool awaitingSmsFallback;
  final bool autoPilotEnabled;
  final String? message;

  SmartOutreachContactModel? get currentContact =>
      sessionBundle?.currentContact;

  bool get isCompleted =>
      sessionBundle?.session.status == SmartOutreachSessionStatus.completed;

  SmartOutreachExecutionState copyWith({
    RequestState? loadState,
    SmartOutreachSessionBundle? sessionBundle,
    bool? awaitingCallOutcome,
    bool? awaitingSmsFallback,
    bool? autoPilotEnabled,
    String? message,
  }) {
    return SmartOutreachExecutionState(
      loadState: loadState ?? this.loadState,
      sessionBundle: sessionBundle ?? this.sessionBundle,
      awaitingCallOutcome: awaitingCallOutcome ?? this.awaitingCallOutcome,
      awaitingSmsFallback: awaitingSmsFallback ?? this.awaitingSmsFallback,
      autoPilotEnabled: autoPilotEnabled ?? this.autoPilotEnabled,
      message: message,
    );
  }
}
