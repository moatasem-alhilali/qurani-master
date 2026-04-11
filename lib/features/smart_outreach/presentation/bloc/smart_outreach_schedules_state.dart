part of 'smart_outreach_schedules_bloc.dart';

class SmartOutreachSchedulesState {
  const SmartOutreachSchedulesState({
    this.schedules = const <SmartOutreachScheduleBundle>[],
    this.loadState = RequestState.initial,
    this.saveState = RequestState.initial,
    this.toggleState = RequestState.initial,
    this.deleteState = RequestState.initial,
    this.validationErrors = const <String>[],
    this.lastSavedScheduleId,
  });

  final List<SmartOutreachScheduleBundle> schedules;
  final RequestState loadState;
  final RequestState saveState;
  final RequestState toggleState;
  final RequestState deleteState;
  final List<String> validationErrors;
  final int? lastSavedScheduleId;

  SmartOutreachSchedulesState copyWith({
    List<SmartOutreachScheduleBundle>? schedules,
    RequestState? loadState,
    RequestState? saveState,
    RequestState? toggleState,
    RequestState? deleteState,
    List<String>? validationErrors,
    int? lastSavedScheduleId,
  }) {
    return SmartOutreachSchedulesState(
      schedules: schedules ?? this.schedules,
      loadState: loadState ?? this.loadState,
      saveState: saveState ?? this.saveState,
      toggleState: toggleState ?? this.toggleState,
      deleteState: deleteState ?? this.deleteState,
      validationErrors: validationErrors ?? this.validationErrors,
      lastSavedScheduleId: lastSavedScheduleId ?? this.lastSavedScheduleId,
    );
  }
}
