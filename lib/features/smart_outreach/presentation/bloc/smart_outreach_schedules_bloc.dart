import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';

part 'smart_outreach_schedules_event.dart';
part 'smart_outreach_schedules_state.dart';

class SmartOutreachSchedulesBloc
    extends Bloc<SmartOutreachSchedulesEvent, SmartOutreachSchedulesState> {
  SmartOutreachSchedulesBloc(this._repository)
      : super(const SmartOutreachSchedulesState()) {
    on<LoadSmartOutreachSchedulesEvent>(_onLoadSchedules);
    on<SaveSmartOutreachScheduleEvent>(_onSaveSchedule);
    on<ToggleSmartOutreachScheduleEnabledEvent>(_onToggleEnabled);
    on<DeleteSmartOutreachScheduleEvent>(_onDeleteSchedule);
    on<PreviewSmartOutreachScheduleNotificationEvent>(_onPreviewNotification);
    on<ClearSmartOutreachScheduleFeedbackEvent>(_onClearFeedback);
  }

  final SmartOutreachScheduleRepository _repository;

  Future<void> _onLoadSchedules(
    LoadSmartOutreachSchedulesEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) async {
    if (event.changeState) {
      emit(state.copyWith(loadState: RequestState.loading));
    }

    final schedules = await _repository.getAllSchedules();
    emit(
      state.copyWith(
        schedules: schedules,
        loadState: RequestState.success,
      ),
    );
  }

  Future<void> _onSaveSchedule(
    SaveSmartOutreachScheduleEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) async {
    emit(
      state.copyWith(
        saveState: RequestState.loading,
        validationErrors: const <String>[],
        lastSavedScheduleId: null,
      ),
    );

    final saveResult = await _repository.saveSchedule(
      scheduleId: event.scheduleId,
      title: event.title,
      note: event.note,
      hour: event.hour,
      minute: event.minute,
      isEnabled: event.isEnabled,
      smsTemplate: event.smsTemplate,
      contacts: event.contacts,
    );

    if (!saveResult.validation.isValid) {
      emit(
        state.copyWith(
          saveState: RequestState.error,
          validationErrors: saveResult.validation.errors,
        ),
      );
      return;
    }

    add(const LoadSmartOutreachSchedulesEvent(changeState: false));

    emit(
      state.copyWith(
        saveState: RequestState.success,
        validationErrors: const <String>[],
        lastSavedScheduleId: saveResult.scheduleId,
      ),
    );
  }

  Future<void> _onToggleEnabled(
    ToggleSmartOutreachScheduleEnabledEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) async {
    emit(
      state.copyWith(
        toggleState: RequestState.loading,
        validationErrors: const <String>[],
      ),
    );

    final validation = await _repository.toggleScheduleEnabled(
      event.scheduleId,
      event.enabled,
    );

    if (!validation.isValid) {
      emit(
        state.copyWith(
          toggleState: RequestState.error,
          validationErrors: validation.errors,
        ),
      );
      return;
    }

    add(const LoadSmartOutreachSchedulesEvent(changeState: false));

    emit(
      state.copyWith(
        toggleState: RequestState.success,
        validationErrors: const <String>[],
      ),
    );
  }

  Future<void> _onDeleteSchedule(
    DeleteSmartOutreachScheduleEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) async {
    emit(state.copyWith(deleteState: RequestState.loading));
    await _repository.deleteSchedule(event.scheduleId);
    add(const LoadSmartOutreachSchedulesEvent(changeState: false));
    emit(state.copyWith(deleteState: RequestState.success));
  }

  Future<void> _onPreviewNotification(
    PreviewSmartOutreachScheduleNotificationEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) async {
    final scheduled =
        await _repository.schedulePreviewNotification(event.scheduleId);

    emit(
      state.copyWith(
        validationErrors: <String>[
          scheduled
              ? 'تمت جدولة إشعار تجريبي بعد 5 ثوانٍ.'
              : 'تعذر جدولة الإشعار التجريبي حاليًا.',
        ],
      ),
    );
  }

  void _onClearFeedback(
    ClearSmartOutreachScheduleFeedbackEvent event,
    Emitter<SmartOutreachSchedulesState> emit,
  ) {
    emit(
      state.copyWith(
        validationErrors: const <String>[],
        saveState: RequestState.initial,
        toggleState: RequestState.initial,
        deleteState: RequestState.initial,
      ),
    );
  }
}
