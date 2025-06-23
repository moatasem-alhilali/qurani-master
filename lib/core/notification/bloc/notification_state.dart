// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

class NotificationState {
  NotificationState({
    this.pendingNotifications = const [],
    this.activeNotifications = const [],
    this.pendingNotificationsState = RequestState.initial,
    this.activeNotificationsState = RequestState.initial,
    this.state = RequestState.initial,
  });
  final List<PendingNotificationRequest> pendingNotifications;
  final RequestState pendingNotificationsState;
  final List<ActiveNotification> activeNotifications;
  final RequestState activeNotificationsState;
  final RequestState state;

  NotificationState copyWith({
    List<PendingNotificationRequest>? pendingNotifications,
    RequestState? pendingNotificationsState,
    List<ActiveNotification>? activeNotifications,
    RequestState? activeNotificationsState,
    RequestState? state,
  }) {
    return NotificationState(
      pendingNotifications: pendingNotifications ?? this.pendingNotifications,
      pendingNotificationsState:
          pendingNotificationsState ?? this.pendingNotificationsState,
      activeNotifications: activeNotifications ?? this.activeNotifications,
      activeNotificationsState:
          activeNotificationsState ?? this.activeNotificationsState,
      state: state ?? this.state,
    );
  }
}
