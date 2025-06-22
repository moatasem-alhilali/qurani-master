// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

class NotificationState {
  NotificationState({
    this.pendingNotifications = const [],
    this.activeNotifications = const [],
    this.state = RequestState.initial,
  });
  final List<PendingNotificationRequest> pendingNotifications;
  final List<ActiveNotification> activeNotifications;
  final RequestState state;

  NotificationState copyWith({
    List<PendingNotificationRequest>? pendingNotifications,
    List<ActiveNotification>? activeNotifications,
    RequestState? state,
  }) {
    return NotificationState(
      pendingNotifications: pendingNotifications ?? this.pendingNotifications,
      activeNotifications: activeNotifications ?? this.activeNotifications,
      state: state ?? this.state,
    );
  }
}
