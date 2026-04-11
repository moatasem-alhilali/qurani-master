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
      id: 'athan_android_channel',
      name: 'Athan',
      sound: 'athan',
    ),
    NotificationChannel.mohammed: NotificationChannelData(
      id: 'sound_mohamed_android_channel',
      name: 'Mohammed',
      sound: 'mohummed',
    ),
    NotificationChannel.morning: NotificationChannelData(
      id: 'sound_morning_android_channel',
      name: 'Morning Azkar',
      sound: 'morning',
    ),
    NotificationChannel.night: NotificationChannelData(
      id: 'sound_night_android_channel',
      name: 'Night Azkar',
      sound: 'night',
    ),
    NotificationChannel.sleep: NotificationChannelData(
      id: 'thikr_sleep_channel',
      name: 'Sleep Thikr',
      sound: 'default_custom',
    ),
    NotificationChannel.getUp: NotificationChannelData(
      id: 'thikr_getup_channel',
      name: 'Wake Up Thikr',
      sound: 'default_custom',
    ),
    NotificationChannel.middleNight: NotificationChannelData(
      id: 'sound_middle_night_android_channel',
      name: 'Middle Night',
      sound: 'middlenight',
    ),
    NotificationChannel.randomThikr: NotificationChannelData(
      id: 'random_thikr_channel',
      name: 'Random Thikr',
      sound: 'default_custom',
    ),
    NotificationChannel.astgferAllh: NotificationChannelData(
      id: 'astgfer_allh_id',
      name: 'Astaghfirullah',
      sound: 'astgfer_allh',
    ),
    NotificationChannel.hasbnaAllh: NotificationChannelData(
      id: 'hasbna_allh_id',
      name: 'Hasbuna Allah',
      sound: 'hasbna_allh',
    ),
    NotificationChannel.laHawla: NotificationChannelData(
      id: 'lahawla_wlaquoah_id',
      name: 'La Hawla',
      sound: 'lahawla_wlaquoah',
    ),
    NotificationChannel.subhanAllh: NotificationChannelData(
      id: 'subhan_allh_id',
      name: 'Subhan Allah',
      sound: 'subhan_allh',
    ),
    NotificationChannel.defaultChannel: NotificationChannelData(
      id: 'default_android_channel',
      name: 'Default',
      sound: 'default_custom',
    ),
    NotificationChannel.smartOutreach: NotificationChannelData(
      id: 'smart_outreach_channel',
      name: 'Smart Outreach',
      sound: 'default_custom',
    ),
  };

  NotificationChannelData get data => _map[this]!;
}
