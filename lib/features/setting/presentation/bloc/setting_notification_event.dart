abstract class SettingNotificationEvent {}

class LoadNotificationSettings extends SettingNotificationEvent {}

class ToggleNotification extends SettingNotificationEvent {
  final String key;
  final bool value;

  ToggleNotification(this.key, this.value);
}
