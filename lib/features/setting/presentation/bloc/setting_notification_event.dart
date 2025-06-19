part of 'setting_notification_bloc.dart';

abstract class SettingNotificationEvent {}

class LoadNotificationSettings extends SettingNotificationEvent {
  LoadNotificationSettings({this.changeState = true});
  final bool changeState;
}

class ToggleNotification extends SettingNotificationEvent {
  ToggleNotification(this.key, this.value);
  final String key;
  final bool value;
}

class EditNotificationSchedule extends SettingNotificationEvent {
  EditNotificationSchedule(this.key, this.updatedModel);
  final String key;
  final NotificationSettingModel updatedModel;
}
