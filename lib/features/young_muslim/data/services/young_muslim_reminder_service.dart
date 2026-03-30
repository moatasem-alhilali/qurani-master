import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_local_data_source.dart';

class YoungMuslimReminderService {
  YoungMuslimReminderService({
    required NotificationService notificationService,
    required YoungMuslimLocalDataSource localDataSource,
  })  : _notificationService = notificationService,
        _localDataSource = localDataSource;

  final NotificationService _notificationService;
  final YoungMuslimLocalDataSource _localDataSource;

  Future<void> scheduleResumeReminder({
    required String videoId,
    required String title,
    required String body,
  }) async {
    final reminderTime = _nextReminderTime();
    final notificationId = _notificationId(videoId);

    await _notificationService.scheduleNotificationCompatType(
      id: notificationId,
      title: title,
      body: body,
      channel: NotificationChannel.defaultChannel,
      schedule: NotificationScheduleModel.customDates([reminderTime]),
      payload: 'young_muslim:$videoId',
    );

    await _localDataSource.updateReminderScheduledAt(videoId, reminderTime);
  }

  Future<void> cancelResumeReminder(String videoId) async {
    await _notificationService.cancelNotificationById(
      id: _notificationId(videoId),
      range: 1,
    );
    await _localDataSource.updateReminderScheduledAt(videoId, null);
  }

  DateTime _nextReminderTime() {
    final now = DateTime.now();
    final laterToday = DateTime(now.year, now.month, now.day, 18);
    if (laterToday.isAfter(now.add(const Duration(hours: 2)))) {
      return laterToday;
    }
    return DateTime(now.year, now.month, now.day + 1, 10);
  }

  int _notificationId(String videoId) {
    return ('young_muslim_$videoId').hashCode.abs() % 100000;
  }
}
