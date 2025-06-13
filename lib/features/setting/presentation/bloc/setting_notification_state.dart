import 'package:quran_app/core/failure/request_state.dart';

class SettingNotificationState {
  final Map<String, bool> settings;
  final LoadState loading;

  const SettingNotificationState({
    required this.settings,
    this.loading = LoadState.initial,
  });

  SettingNotificationState copyWith({
    Map<String, bool>? settings,
    LoadState ? loading,
  }) {
    return SettingNotificationState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }

  static SettingNotificationState initial() =>
      const SettingNotificationState(settings: {});
}
