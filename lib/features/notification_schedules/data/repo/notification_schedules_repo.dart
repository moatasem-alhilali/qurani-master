import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/notification_schedules/data/database/database_notification_schedules_service.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';

class NotificationSchedulesRepo {
  NotificationSchedulesRepo({
    required this.notifyService,
  });

  final NotificationService notifyService;

  // Cache for better performance
  final Map<String, List<NotificationScheduleCustomModel>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// جلب كل الجداول لهذا المفتاح مع التخزين المؤقت
  Future<List<NotificationScheduleCustomModel>> getSchedules(
    String notifKey,
  ) async {
    final now = DateTime.now();
    final cachedTimestamp = _cacheTimestamps[notifKey];

    // Check if cache is valid
    if (cachedTimestamp != null &&
        now.difference(cachedTimestamp) < _cacheExpiry &&
        _cache.containsKey(notifKey)) {
      return _cache[notifKey]!;
    }

    // Fetch from database
    final schedules =
        await DatabaseNotificationSchedulesService().getSchedules(notifKey);

    // Update cache
    _cache[notifKey] = schedules;
    _cacheTimestamps[notifKey] = now;

    return schedules;
  }

  /// إضافة أو تعديل جدول مع تحسين الأداء
  Future<void> upsertSchedule(
    NotificationScheduleCustomModel model, {
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async {
    // Get old schedule for comparison (if editing)
    NotificationScheduleCustomModel? oldSchedule;
    if (model.id != null) {
      final schedules = await getSchedules(model.notifKey);
      oldSchedule = schedules.firstWhere(
        (s) => s.id == model.id,
        orElse: () => model,
      );
    }

    // Save to database
    await DatabaseNotificationSchedulesService().upsert(model);

    // Clear cache for this key
    _invalidateCache(model.notifKey);

    // Optimized notification scheduling
    await _updateNotificationsForSchedule(
      model,
      oldSchedule: oldSchedule,
      title: title,
      body: body,
      channel: channel,
    );
  }

  /// حذف جدول مع تحسين الأداء
  Future<void> deleteSchedule(
    int id,
    String notifKey, {
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async {
    // Get the schedule before deletion for notification cancellation
    final schedules = await getSchedules(notifKey);
    final scheduleToDelete = schedules.firstWhere(
      (s) => s.id == id,
      orElse: () => NotificationScheduleCustomModel(
        notifKey: notifKey,
        enabled: false,
        scheduleType: ScheduleType.daily,
      ),
    );

    // Delete from database
    await DatabaseNotificationSchedulesService().delete(id);

    // Clear cache
    _invalidateCache(notifKey);

    // Cancel only notifications for this specific schedule
    await _cancelNotificationsForSchedule(scheduleToDelete);
  }

  /// تفريغ ذاكرة التخزين المؤقت
  void _invalidateCache(String notifKey) {
    _cache.remove(notifKey);
    _cacheTimestamps.remove(notifKey);
  }

  /// تحديث الإشعارات لجدول محدد فقط (بدلاً من كل الجداول)
  Future<void> _updateNotificationsForSchedule(
    NotificationScheduleCustomModel newSchedule, {
    required String title,
    required String body,
    required NotificationChannel channel,
    NotificationScheduleCustomModel? oldSchedule,
  }) async {
    // Cancel old notifications if this is an edit
    if (oldSchedule != null) {
      await _cancelNotificationsForSchedule(oldSchedule);
    }

    // Schedule new notifications if enabled
    if (newSchedule.enabled && newSchedule.id != null) {
      await notifyService.scheduleNotificationCompatType(
        id: _buildNotificationId(newSchedule.notifKey, newSchedule.id!),
        title: title,
        body: body,
        channel: channel,
        schedule: newSchedule.toScheduleModel(),
      );
    }
  }

  /// إلغاء الإشعارات لجدول محدد فقط
  Future<void> _cancelNotificationsForSchedule(
    NotificationScheduleCustomModel schedule,
  ) async {
    if (schedule.id != null) {
      final notificationId =
          _buildNotificationId(schedule.notifKey, schedule.id!);
      await notifyService.cancelNotificationById(id: notificationId);
    }
  }

  /// إعادة جدولة كل الإشعارات لهذا notifKey (استخدم فقط عند الضرورة)
  Future<void> rescheduleAllForKey({
    required String notifKey,
    required String title,
    required String body,
    required NotificationChannel channel,
  }) async {
    final schedules = await getSchedules(notifKey);

    // Cancel all notifications for this key
    await notifyService.cancelAllForKey(notifKey);

    // Reschedule only enabled schedules
    final enabledSchedules = schedules.where((s) => s.enabled && s.id != null);

    for (final schedule in enabledSchedules) {
      try {
        await notifyService.scheduleNotificationCompatType(
          id: _buildNotificationId(notifKey, schedule.id!),
          title: title,
          body: body,
          channel: channel,
          schedule: schedule.toScheduleModel(),
        );
      } catch (e) {
        // Log error but continue with other schedules
        print('Failed to schedule notification for ${schedule.id}: $e');
      }
    }
  }

  /// بناء معرف فريد للإشعار
  int _buildNotificationId(String key, int scheduleId) =>
      key.hashCode.abs() + scheduleId;

  /// مسح كل ذاكرة التخزين المؤقت
  void clearAllCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// إحصائيات الأداء
  Map<String, dynamic> getPerformanceStats() {
    return {
      'cached_keys': _cache.keys.length,
      'total_cached_schedules': _cache.values.fold<int>(
        0,
        (sum, schedules) => sum + schedules.length,
      ),
      'cache_hit_rate': _cacheTimestamps.isNotEmpty
          ? '${(_cache.length / _cacheTimestamps.length * 100).toStringAsFixed(1)}%'
          : '0%',
    };
  }
}
