import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_channel.dart';

Future<void> initAllAndroidChannels({
  required FlutterLocalNotificationsPlugin plugin,
}) async {
  final androidPlugin = plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  for (final channel in NotificationChannel.values) {
    final data = channel.data;

    final androidChannel = AndroidNotificationChannel(
      data.id,
      data.name,
      description: 'Channel for ${data.name}',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(data.sound),
    );

    await androidPlugin?.createNotificationChannel(androidChannel);
  }
}
