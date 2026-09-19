import 'package:quran_app/l10n/l10n.dart';

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
  static const Map<NotificationChannel, ({String id, String sound})> _map = {
    NotificationChannel.athan: (id: 'athan_android_channel_v2', sound: 'athan'),
    NotificationChannel.mohammed: (
      id: 'sound_mohamed_android_channel',
      sound: 'mohummed'
    ),
    NotificationChannel.morning: (
      id: 'sound_morning_android_channel',
      sound: 'morning'
    ),
    NotificationChannel.night: (
      id: 'sound_night_android_channel',
      sound: 'night'
    ),
    NotificationChannel.sleep: (
      id: 'thikr_sleep_channel',
      sound: 'default_custom'
    ),
    NotificationChannel.getUp: (
      id: 'thikr_getup_channel',
      sound: 'default_custom'
    ),
    NotificationChannel.middleNight: (
      id: 'sound_middle_night_android_channel',
      sound: 'middlenight'
    ),
    NotificationChannel.randomThikr: (
      id: 'random_thikr_channel',
      sound: 'default_custom'
    ),
    NotificationChannel.astgferAllh: (
      id: 'astgfer_allh_id',
      sound: 'astgfer_allh'
    ),
    NotificationChannel.hasbnaAllh: (
      id: 'hasbna_allh_id',
      sound: 'hasbna_allh'
    ),
    NotificationChannel.laHawla: (
      id: 'lahawla_wlaquoah_id',
      sound: 'lahawla_wlaquoah'
    ),
    NotificationChannel.subhanAllh: (
      id: 'subhan_allh_id',
      sound: 'subhan_allh'
    ),
    NotificationChannel.defaultChannel: (
      id: 'default_android_channel',
      sound: 'default_custom'
    ),
    NotificationChannel.smartOutreach: (
      id: 'smart_outreach_channel',
      sound: 'default_custom'
    ),
  };

  /// Channel metadata. The name is shown in the system notification settings,
  /// so it is resolved in the saved app language (no BuildContext here).
  NotificationChannelData get data {
    final spec = _map[this]!;
    return NotificationChannelData(
      id: spec.id,
      name: localizedName(L10nService.current),
      sound: spec.sound,
    );
  }

  String localizedName(L10n l10n) {
    switch (this) {
      case NotificationChannel.athan:
        return l10n.coreChannelAthan;
      case NotificationChannel.mohammed:
        return l10n.coreChannelMohammed;
      case NotificationChannel.morning:
        return l10n.coreChannelMorning;
      case NotificationChannel.night:
        return l10n.coreChannelNight;
      case NotificationChannel.sleep:
        return l10n.coreChannelSleep;
      case NotificationChannel.getUp:
        return l10n.coreChannelGetUp;
      case NotificationChannel.middleNight:
        return l10n.coreChannelMiddleNight;
      case NotificationChannel.randomThikr:
        return l10n.coreChannelRandomThikr;
      case NotificationChannel.astgferAllh:
        return l10n.coreChannelAstgferAllh;
      case NotificationChannel.hasbnaAllh:
        return l10n.coreChannelHasbnaAllh;
      case NotificationChannel.laHawla:
        return l10n.coreChannelLaHawla;
      case NotificationChannel.subhanAllh:
        return l10n.coreChannelSubhanAllh;
      case NotificationChannel.defaultChannel:
        return l10n.coreChannelDefaultChannel;
      case NotificationChannel.smartOutreach:
        return l10n.coreChannelSmartOutreach;
    }
  }
}
