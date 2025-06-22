part of 'setting_notification_bloc.dart';

class SettingNotificationState {
  const SettingNotificationState({
    this.settings = const {},
    this.loading = RequestState.initial,
  });
  final Map<String, NotificationSettingModel> settings;
  final RequestState loading;

  SettingNotificationState copyWith({
    Map<String, NotificationSettingModel>? settings,
    RequestState? loading,
  }) {
    return SettingNotificationState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }

 
}
