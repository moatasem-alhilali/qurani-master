part of 'notification_schedule_bloc.dart';

class NotificationScheduleState {
  const NotificationScheduleState({
    this.schedules = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  final List<NotificationScheduleCustomModel> schedules;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  NotificationScheduleState copyWith({
    List<NotificationScheduleCustomModel>? schedules,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
  }) {
    return NotificationScheduleState(
      schedules: schedules ?? this.schedules,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      successMessage: successMessage,
    );
  }

  bool get hasError => error != null;
  bool get hasSuccess => successMessage != null;
  bool get isEmpty => schedules.isEmpty;
  int get enabledCount => schedules.where((s) => s.enabled).length;
  int get disabledCount => schedules.length - enabledCount;
}
