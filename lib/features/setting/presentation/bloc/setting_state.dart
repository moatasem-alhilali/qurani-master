part of 'setting_bloc.dart';

class SettingState {
  const SettingState({
    this.settings = const {},
    this.loading = RequestState.initial,
  });
  final Map<String, NotificationSettingModel> settings;
  final RequestState loading;

  SettingState copyWith({
    Map<String, NotificationSettingModel>? settings,
    RequestState? loading,
  }) {
    return SettingState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }


}
