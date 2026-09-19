import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'notification_schedule_event.dart';
part 'notification_schedule_state.dart';

class NotificationScheduleBloc
    extends Bloc<NotificationScheduleEvent, NotificationScheduleState> {
  NotificationScheduleBloc({
    required this.repo,
    required this.notifKey,
    required this.title,
    required this.body,
    required this.channel,
  }) : super(const NotificationScheduleState()) {
    on<LoadSchedules>(_onLoad);
    on<AddSchedule>(_onAdd);
    on<EditSchedule>(_onEdit);
    on<DeleteSchedule>(_onDelete);
    on<ToggleSchedule>(_onToggle);
    on<ClearError>(_onClearError);
  }

  final NotificationSchedulesRepo repo;
  final String notifKey;
  final String title;
  final String body;
  final NotificationChannel channel;

  Future<void> _onLoad(
    LoadSchedules event,
    Emitter<NotificationScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final schedules = await repo.getSchedules(notifKey);
      emit(
        state.copyWith(
          schedules: schedules,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: L10nService.current.notifScheduleLoadFailed('$e'),
        ),
      );
    }
  }

  Future<void> _onAdd(
    AddSchedule event,
    Emitter<NotificationScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      await repo.upsertSchedule(
        event.model,
        title: title,
        body: body,
        channel: channel,
      );

      // Optimized: Add to existing list instead of full reload
      final updatedSchedules = [...state.schedules, event.model];
      emit(
        state.copyWith(
          schedules: updatedSchedules,
          isSubmitting: false,
          successMessage: L10nService.current.notifScheduleAdded,
        ),
      );

      // Reload to get the ID from database
      add(LoadSchedules());
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: L10nService.current.notifScheduleAddFailed('$e'),
        ),
      );
    }
  }

  Future<void> _onEdit(
    EditSchedule event,
    Emitter<NotificationScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      await repo.upsertSchedule(
        event.model,
        title: title,
        body: body,
        channel: channel,
      );

      // Optimized: Update specific item in list
      final updatedSchedules = state.schedules.map((s) {
        return s.id == event.model.id ? event.model : s;
      }).toList();

      emit(
        state.copyWith(
          schedules: updatedSchedules,
          isSubmitting: false,
          successMessage: L10nService.current.notifScheduleUpdated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: L10nService.current.notifScheduleUpdateFailed('$e'),
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteSchedule event,
    Emitter<NotificationScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      await repo.deleteSchedule(
        event.id,
        notifKey,
        title: title,
        body: body,
        channel: channel,
      );

      // Optimized: Remove from existing list
      final updatedSchedules =
          state.schedules.where((s) => s.id != event.id).toList();

      emit(
        state.copyWith(
          schedules: updatedSchedules,
          isSubmitting: false,
          successMessage: L10nService.current.notifScheduleDeleted,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: L10nService.current.notifScheduleDeleteFailed('$e'),
        ),
      );
    }
  }

  Future<void> _onToggle(
    ToggleSchedule event,
    Emitter<NotificationScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));

      final toggledModel = event.model.copyWith(enabled: !event.model.enabled);

      await repo.upsertSchedule(
        toggledModel,
        title: title,
        body: body,
        channel: channel,
      );

      // Update in list
      final updatedSchedules = state.schedules.map((s) {
        return s.id == event.model.id ? toggledModel : s;
      }).toList();

      emit(
        state.copyWith(
          schedules: updatedSchedules,
          isSubmitting: false,
          successMessage: toggledModel.enabled
              ? L10nService.current.notifScheduleActivated
              : L10nService.current.notifScheduleDeactivated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: L10nService.current.notifScheduleToggleFailed('$e'),
        ),
      );
    }
  }

  void _onClearError(
    ClearError event,
    Emitter<NotificationScheduleState> emit,
  ) {
    emit(state.copyWith());
  }
}
