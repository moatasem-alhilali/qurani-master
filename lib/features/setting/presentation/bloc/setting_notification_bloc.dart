import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/setting/data/remote/manage_notification_repo.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_event.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_state.dart';

class SettingNotificationBloc
    extends Bloc<SettingNotificationEvent, SettingNotificationState> {
  final ManageNotificationRepo repo;

  SettingNotificationBloc(this.repo)
      : super(SettingNotificationState.initial()) {
    on<LoadNotificationSettings>(_onLoad);
    on<ToggleNotification>(_onToggle);
  }

  Future<void> _onLoad(
    LoadNotificationSettings event,
    Emitter<SettingNotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: LoadState.loading));
      final settings = await repo.loadAll();
      emit(state.copyWith(settings: settings, loading: LoadState.success));
    } catch (e) {
      emit(state.copyWith(loading: LoadState.error));
      rethrow;
    }
  }

  Future<void> _onToggle(
    ToggleNotification event,
    Emitter<SettingNotificationState> emit,
  ) async {
    try {
      emit(state.copyWith());
      final updated = await repo.toggle(event.key, event.value);

      emit(state.copyWith(settings: updated));

      add(LoadNotificationSettings());
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
