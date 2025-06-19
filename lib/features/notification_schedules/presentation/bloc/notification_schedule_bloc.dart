import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';

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
          error: 'فشل في تحميل المواعيد: $e',
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
          successMessage: 'تم إضافة الموعد بنجاح',
        ),
      );

      // Reload to get the ID from database
      add(LoadSchedules());
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'فشل في إضافة الموعد: $e',
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
          successMessage: 'تم تحديث الموعد بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'فشل في تحديث الموعد: $e',
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
          successMessage: 'تم حذف الموعد بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'فشل في حذف الموعد: $e',
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
              ? 'تم تفعيل الموعد'
              : 'تم إلغاء تفعيل الموعد',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'فشل في تغيير حالة الموعد: $e',
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
