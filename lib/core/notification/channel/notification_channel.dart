class NotificationChannelData {
  const NotificationChannelData({
    required this.id,
    required this.name,
    required this.sound,
  });
  final String id;
  final String name;
  final String sound;
}

enum NotificationChannel {
  defaultChannel,
  athan,
  mohammed,
  morning,
  night,
  sleep,
  getUp,
  middleNight,
  randomThikr,
  astgferAllh,
  hasbnaAllh,
  laHawla,
  subhanAllh,
  smartOutreach,
}

extension NotificationChannelMeta on NotificationChannel {
  static const Map<NotificationChannel, NotificationChannelData> _map = {
    NotificationChannel.athan: NotificationChannelData(
      id: 'athan_android_channel_v2',
      name: 'طمأنينة - الأذان',
      sound: 'athan',
    ),
    NotificationChannel.mohammed: NotificationChannelData(
      id: 'sound_mohamed_android_channel',
      name: 'طمأنينة - الصلاة على النبي',
      sound: 'mohummed',
    ),
    NotificationChannel.morning: NotificationChannelData(
      id: 'sound_morning_android_channel',
      name: 'طمأنينة - أذكار الصباح',
      sound: 'morning',
    ),
    NotificationChannel.night: NotificationChannelData(
      id: 'sound_night_android_channel',
      name: 'طمأنينة - أذكار المساء',
      sound: 'night',
    ),
    NotificationChannel.sleep: NotificationChannelData(
      id: 'thikr_sleep_channel',
      name: 'طمأنينة - أذكار النوم',
      sound: 'default_custom',
    ),
    NotificationChannel.getUp: NotificationChannelData(
      id: 'thikr_getup_channel',
      name: 'طمأنينة - أذكار الاستيقاظ',
      sound: 'default_custom',
    ),
    NotificationChannel.middleNight: NotificationChannelData(
      id: 'sound_middle_night_android_channel',
      name: 'طمأنينة - قيام الليل',
      sound: 'middlenight',
    ),
    NotificationChannel.randomThikr: NotificationChannelData(
      id: 'random_thikr_channel',
      name: 'طمأنينة - أذكار عشوائية',
      sound: 'default_custom',
    ),
    NotificationChannel.astgferAllh: NotificationChannelData(
      id: 'astgfer_allh_id',
      name: 'طمأنينة - الاستغفار',
      sound: 'astgfer_allh',
    ),
    NotificationChannel.hasbnaAllh: NotificationChannelData(
      id: 'hasbna_allh_id',
      name: 'طمأنينة - حسبنا الله',
      sound: 'hasbna_allh',
    ),
    NotificationChannel.laHawla: NotificationChannelData(
      id: 'lahawla_wlaquoah_id',
      name: 'طمأنينة - لا حول ولا قوة إلا بالله',
      sound: 'lahawla_wlaquoah',
    ),
    NotificationChannel.subhanAllh: NotificationChannelData(
      id: 'subhan_allh_id',
      name: 'طمأنينة - سبحان الله',
      sound: 'subhan_allh',
    ),
    NotificationChannel.defaultChannel: NotificationChannelData(
      id: 'default_android_channel',
      name: 'طمأنينة - الإشعارات العامة',
      sound: 'default_custom',
    ),
    NotificationChannel.smartOutreach: NotificationChannelData(
      id: 'smart_outreach_channel',
      name: 'طمأنينة - صحبة الفجر',
      sound: 'default_custom',
    ),
  };

  NotificationChannelData get data => _map[this]!;
}
