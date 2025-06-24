import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';
import 'package:quran_app/main.dart';

part 'setting_notification_event.dart';
part 'setting_notification_state.dart';

class SettingNotificationBloc
    extends Bloc<SettingNotificationEvent, SettingNotificationState> {
  SettingNotificationBloc(this.repo) : super(const SettingNotificationState()) {
    on<LoadNotificationSettings>(_onLoad);
    on<ToggleNotification>(_onToggle);
    on<EditNotificationSchedule>(_onEditSchedule);
  }
  final SettingNotificationRepo repo;

  Future<void> _onLoad(
    LoadNotificationSettings event,
    Emitter<SettingNotificationState> emit,
  ) async {
    try {
      if (event.changeState) {
        emit(state.copyWith(loading: RequestState.loading));
      }
      final settingsList = await repo.getAllSettings();
      final settingsMap = {for (final e in settingsList) e.key: e};
      if (event.changeState) {
        emit(
          state.copyWith(
            settings: settingsMap,
            loading: RequestState.success,
          ),
        );
      } else {
        emit(state.copyWith(settings: settingsMap));
      }
    } catch (e) {
      logger.e('error: $e');
      if (event.changeState) {
        emit(state.copyWith(loading: RequestState.error));
      } else {
        emit(state.copyWith());
      }
    }
  }

  Future<void> _onToggle(
    ToggleNotification event,
    Emitter<SettingNotificationState> emit,
  ) async {
    try {
      await repo.toggle(event.key, event.value);
      add(LoadNotificationSettings(changeState: false));
    } catch (e) {
      logger.e('error: $e');
      emit(state.copyWith());
    }
  }

  Future<void> _onEditSchedule(
    EditNotificationSchedule event,
    Emitter<SettingNotificationState> emit,
  ) async {
    try {
      logger.d(event.updatedModel.toMap());
      await repo.updateSchedule(event.key, event.updatedModel);
      add(LoadNotificationSettings(changeState: false));
    } catch (e) {
      logger.e('error: $e');
      emit(state.copyWith());
    }
  }
}
