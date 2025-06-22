import 'package:quran_app/core/notification/advanced_notification_service.dart';
import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/notification/data/notification_data_const.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/repo/setting_notification_repo.dart';

/// orchestrator: يعيد جدولة جميع أنواع الإشعارات حسب المنظومة الجديدة
class NotificationOrchestratorService {
  NotificationOrchestratorService({
    required this.advancedNotificationService,
    required this.settingRepo,
    required this.notificationSchedulesRepo,
    required this.adhanPrayerTimeService,
  });

  final AdvancedNotificationService advancedNotificationService;
  final SettingNotificationRepo settingRepo;
  final NotificationSchedulesRepo notificationSchedulesRepo;
  final AdhanPrayerTimeService adhanPrayerTimeService;

  /// جدولة جميع الإشعارات: أذان، إشعارات ثابتة، إشعارات متعددة
  Future<void> rescheduleAllNotifications() async {
    await _rescheduleAthanNotifications();
    await _rescheduleStaticNotifications();
    await _rescheduleCustomSchedules();
  }

  /// 1. جدولة إشعارات الأذان بدقة بناءً على أوقات اليوم والموقع
  Future<void> _rescheduleAthanNotifications() async {
    final mainEnabled =
        await settingRepo.getBool(NotificationKeys.isNotificationAllAthan);
    final athanKeys = [
      NotificationKeys.isNotificationAthanFagr,
      NotificationKeys.isNotificationAthanDuhr,
      NotificationKeys.isNotificationAthanAsr,
      NotificationKeys.isNotificationAthanMagrib,
      NotificationKeys.isNotificationAthanIsha,
    ];
    // IDs المخصصة للأذان (يجب أن تكون ثابتة، وتطابق نظامك)
    final athanIds = [200, 201, 202, 203, 204, 205];

    // إذا لم يتم تفعيل إشعارات الأذان كلياً: ألغ جميع إشعارات الأذان
    if (!mainEnabled) {
      for (final id in athanIds) {
        await advancedNotificationService.cancelNotification(id: id);
      }
      return;
    }

    // جدولة أوقات الصلاة لليوم الحالي
    final prayerTimes = await adhanPrayerTimeService.getTodayPrayerTimes();

    // لكل نوع أذان، إذا مفعّل من الإعدادات، جدوله حسب الوقت الفعلي
    for (var i = 0; i < athanKeys.length; i++) {
      final key = athanKeys[i];
      final enabled = await settingRepo.getBool(key);
      final info = _mapPrayerKeyToInfo(key, prayerTimes);
      if (info == null) continue;
      final id = info.id; // ID = ثابت لكل نوع أذان

      if (enabled) {
        await advancedNotificationService.scheduleNotification(
          id: id,
          title: info.name,
          body: info.description,
          channel: NotificationChannel.athan,
          schedule: NotificationScheduleModel(
            type: ScheduleType.customDates,
            customDates: [info.time], // إشعار في وقت الصلاة لهذا اليوم فقط
          ),
        );
      } else {
        await advancedNotificationService.cancelNotification(id: id);
      }
    }
  }

  /// خريطة المفتاح إلى PrayerInfoModel المناسب حسب التسلسل
  PrayerInfoModel? _mapPrayerKeyToInfo(String key, List<PrayerInfoModel> list) {
    switch (key) {
      case NotificationKeys.isNotificationAthanFagr:
        return list[0];
      case NotificationKeys.isNotificationAthanDuhr:
        return list[2];
      case NotificationKeys.isNotificationAthanAsr:
        return list[3];
      case NotificationKeys.isNotificationAthanMagrib:
        return list[4];
      case NotificationKeys.isNotificationAthanIsha:
        return list[5];
      default:
        return null;
    }
  }

  /// 2. جدولة جميع الإشعارات الثابتة (single schedule per key)
  Future<void> _rescheduleStaticNotifications() async {
    final settings = await settingRepo.getAllSettings();
    for (final setting in settings) {
      // تجاهل مفاتيح الأذان لأن لديهم منطق خاص أعلاه
      if (setting.key.startsWith('isNotificationAthan')) continue;

      // يمكن هنا أيضاً تجاهل المفاتيح التي تعتمد على multi-schedule لو تريد الفصل التام

      final id = setting.key.hashCode.abs();

      if (!setting.enabled) {
        await advancedNotificationService.cancelNotification(id: id);
        continue;
      }
      await advancedNotificationService.scheduleNotification(
        id: id,
        title: setting.label,
        body: _resolveNotificationBody(setting.key),
        channel: _resolveChannel(setting.key),
        schedule: setting.schedule,
      );
    }
  }

  /// 3. جدولة كل جداول multi-schedule (لكل مفتاح يدعم جداول فرعية)
  Future<void> _rescheduleCustomSchedules() async {
    // لو عندك قائمة مفاتيح تدعم multi-schedule أضفها هنا
    final multiScheduleKeys = [
      NotificationKeys.isNotificationThikrMorning,
      NotificationKeys.isNotificationThikrNight,
      NotificationKeys.isNotificationMiddleNight,
      NotificationKeys.isNotificationMohammed,
      NotificationKeys.isNotificationRandomThikr,
      NotificationKeys.isNotificationReadQuran,
      NotificationKeys.isNotificationReadSurahMulk,
      NotificationKeys.isNotificationWridSleep,
      NotificationKeys.isNotificationWridGetup,
    ];
    for (final key in multiScheduleKeys) {
      final schedules = await notificationSchedulesRepo.getSchedules(key);
      for (final schedule in schedules) {
        if (schedule.enabled) {
          final id = _buildNotificationId(key, schedule.id!);
          await advancedNotificationService.scheduleNotification(
            id: id,
            title: schedule.label ?? _resolveTitle(key),
            body: schedule.label ?? _resolveNotificationBody(key),
            channel: _resolveChannel(key),
            schedule: schedule.toScheduleModel(),
          );
        } else {
          await advancedNotificationService.cancelNotification(
            id: _buildNotificationId(key, schedule.id!),
          );
        }
      }
    }
  }

  /// بناء ID فريد لكل جدول إشعار فرعي
  int _buildNotificationId(String key, int scheduleId) =>
      key.hashCode.abs() + scheduleId;

  /// تعيين channel المناسب لكل مفتاح
  NotificationChannel _resolveChannel(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return NotificationChannel.morning;
      case NotificationKeys.isNotificationThikrNight:
        return NotificationChannel.night;
      case NotificationKeys.isNotificationMohammed:
        return NotificationChannel.mohammed;
      case NotificationKeys.isNotificationRandomThikr:
        return NotificationChannel.randomThikr;
      case NotificationKeys.isNotificationReadQuran:
      case NotificationKeys.isNotificationReadSurahMulk:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationMiddleNight:
        return NotificationChannel.middleNight;
      case NotificationKeys.isNotificationWridSleep:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationChannel.defaultChannel;
      case NotificationKeys.isNotificationAllAthan:
      case NotificationKeys.isNotificationAthanFagr:
      case NotificationKeys.isNotificationAthanDuhr:
      case NotificationKeys.isNotificationAthanAsr:
      case NotificationKeys.isNotificationAthanMagrib:
      case NotificationKeys.isNotificationAthanIsha:
        return NotificationChannel.athan;
      default:
        return NotificationChannel.defaultChannel;
    }
  }

  /// جلب عنوان الإشعار الافتراضي حسب المفتاح (لو ما كان معرف)
  String _resolveTitle(String key) {
    final seeder = NotificationDataConst();
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return seeder.thikrMorning.title;
      case NotificationKeys.isNotificationThikrNight:
        return seeder.thikrNight.title;
      case NotificationKeys.isNotificationMohammed:
        return seeder.notificationMohummed.title;
      case NotificationKeys.isNotificationRandomThikr:
        return 'ذكر عشوائي';
      case NotificationKeys.isNotificationReadQuran:
        return seeder.readQuran.title;
      case NotificationKeys.isNotificationReadSurahMulk:
        return seeder.readSurahMulk.title;
      case NotificationKeys.isNotificationMiddleNight:
        return seeder.middleNight.title;
      case NotificationKeys.isNotificationWridSleep:
        return seeder.thikrSleep.title;
      case NotificationKeys.isNotificationWridGetup:
        return NotificationDataConst().thikrGetup.title;
      case NotificationKeys.isNotificationAllAthan:
        return 'أذان الصلاة';
      case NotificationKeys.isNotificationAthanFagr:
        return 'أذان الفجر';
      case NotificationKeys.isNotificationAthanDuhr:
        return 'أذان الظهر';
      case NotificationKeys.isNotificationAthanAsr:
        return 'أذان ا لعصر';
      case NotificationKeys.isNotificationAthanMagrib:
        return 'أذان المغرب';
      case NotificationKeys.isNotificationAthanIsha:
        return 'أذان العشاء';
      default:
        return key;
    }
  }

  /// نص الإشعار الافتراضي حسب المفتاح (يمكن تخصصه أكثر)
  String _resolveNotificationBody(String key) {
    switch (key) {
      case NotificationKeys.isNotificationThikrMorning:
        return 'لا تنس أذكار الصباح!';
      case NotificationKeys.isNotificationThikrNight:
        return 'لا تنس أذكار المساء!';
      case NotificationKeys.isNotificationMohammed:
        return 'صلى الله عليه وسلم';
      case NotificationKeys.isNotificationRandomThikr:
        return 'ذكر عشوائي';
      case NotificationKeys.isNotificationReadQuran:
        return 'اقرأ القرآن';
      case NotificationKeys.isNotificationReadSurahMulk:
        return 'اقرأ سور ة الملك';
      case NotificationKeys.isNotificationMiddleNight:
        return 'صلاة الليل';
      case NotificationKeys.isNotificationWridSleep:
        return 'أذكار النوم';
      case NotificationKeys.isNotificationWridGetup:
        return 'أذكار الاستيقاظ';
      case NotificationKeys.isNotificationAllAthan:
        return 'حان وقت الأذان';
      case NotificationKeys.isNotificationAthanFagr:
        return 'حان وقت أذان الفجر';
      case NotificationKeys.isNotificationAthanDuhr:
        return 'حان وقت أذان الظهر';
      case NotificationKeys.isNotificationAthanAsr:
        return 'حان وقت أذان العصر';
      case NotificationKeys.isNotificationAthanMagrib:
        return 'حان وقت أذان المغرب';
      case NotificationKeys.isNotificationAthanIsha:
        return 'حان وقت أذان العشاء';
      default:
        return '';
    }
  }
}
