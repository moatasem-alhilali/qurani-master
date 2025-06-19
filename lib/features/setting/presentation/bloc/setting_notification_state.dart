part of 'setting_notification_bloc.dart';

class SettingNotificationState {
  const SettingNotificationState({
    required this.settings,
    this.loading = LoadState.initial,
  });
  final Map<String, NotificationSettingModel> settings;
  final LoadState loading;

  SettingNotificationState copyWith({
    Map<String, NotificationSettingModel>? settings,
    LoadState? loading,
  }) {
    return SettingNotificationState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }

  static SettingNotificationState initial() =>
      const SettingNotificationState(settings: {});
}
