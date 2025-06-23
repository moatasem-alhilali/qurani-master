import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting_notification/data/model/notification_setting_seed_data.dart';
import 'package:quran_app/main.dart';

class NotificationSettingsSeeder {
  factory NotificationSettingsSeeder() => _instance;
  NotificationSettingsSeeder._internal();
  static final NotificationSettingsSeeder _instance =
      NotificationSettingsSeeder._internal();

  Future<void> runIfNeeded() async {
    final all = await DatabaseNotificationSettingService().getAll();

    if (all.isNotEmpty) return;
    await _seed();
  }

  Future<void> _seed() async {
    try {
      final db = DatabaseNotificationSettingService();

      // Seed notification settings with flexible scheduling options
      // Each notification type can have different schedule requirements:
      // - daily: requires hour/minute
      // - everyNMinutes: requires intervalMinutes
      // - weekly: requires weekdays/hour/minute
      // - customDates: requires customDates
      final seeds = <NotificationSettingSeedData>[
        // Master enable/disable (settings only)
        NotificationSettingSeedData(
          key: NotificationKeys.isNotify,
          label: 'اشعارات التطبيق',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 0,
          minute: 0,
          onlySetting: true,
        ),

        // Athan notifications master toggle
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAllAthan,
          label: 'إشعارات جميع الأذان',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 0,
          minute: 0,
          onlySetting: true,
        ),

        // Individual Athan notifications
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanFagr,
          label: 'أذان الفجر',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 4,
          minute: 20,
          onlySetting: true, // Managed by prayer time service
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanSunrise,
          label: 'أذان الشروق',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 6,
          minute: 0,
          onlySetting: true, // Managed by prayer time service
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanDuhr,
          label: 'أذان الظهر',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 12,
          minute: 0,
          onlySetting: true, // Managed by prayer time service
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanAsr,
          label: 'أذان العصر',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 15,
          minute: 30,
          onlySetting: true, // Managed by prayer time service
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanMagrib,
          label: 'أذان المغرب',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 18,
          minute: 15,
          onlySetting: true, // Managed by prayer time service
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAthanIsha,
          label: 'أذان العشاء',
          enabled: true,
          scheduleType: ScheduleType.daily,
          hour: 19,
          minute: 30,
          onlySetting: true, // Managed by prayer time service
        ),

        // Daily Islamic reminders
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationMiddleNight,
          label: 'قيام الليل',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 22,
          minute: 0,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationThikrMorning,
          label: 'أذكار الصباح',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 7,
          minute: 0,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationThikrNight,
          label: 'أذكار المساء',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 18,
          minute: 0,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationWridGetup,
          label: 'أذكار الاستيقاظ',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 7,
          minute: 30,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationWridSleep,
          label: 'أذكار النوم',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 20,
          minute: 0,
        ),

        // Frequent reminders
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationMohammed,
          label: 'الصلاة على محمد ﷺ',
          enabled: false,
          scheduleType: ScheduleType.everyNMinutes,
          intervalMinutes: 60, // Every hour
        ),

        // Quran reading reminders
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationReadQuran,
          label: 'الورد القرآني اليومي',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 18,
          minute: 30,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationReadSurahMulk,
          label: 'قراءة سورة الملك',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 20,
          minute: 10,
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationReadSurah,
          label: 'قراءة سورة محددة',
          enabled: false,
          scheduleType: ScheduleType.daily,
          hour: 21,
          minute: 0,
        ),

        // Weekly reminders
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationReadSurahAlkahf,
          label: 'قراءة سورة الكهف',
          enabled: false,
          scheduleType: ScheduleType.weekly,
          hour: 10,
          minute: 30,
          weekdays: [5], // Friday
        ),

        // Fasting reminders
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationFasting,
          label: 'تذكير بالصيام',
          enabled: false,
          scheduleType: ScheduleType.weekly,
          hour: 20,
          minute: 30,
          weekdays: [1, 4], // Monday and Thursday
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationFastingMonday,
          label: 'صيام الاثنين',
          enabled: false,
          scheduleType: ScheduleType.weekly,
          hour: 20,
          minute: 30,
          weekdays: [1], // Monday
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationFastingThursday,
          label: 'صيام الخميس',
          enabled: false,
          scheduleType: ScheduleType.weekly,
          hour: 20,
          minute: 30,
          weekdays: [4], // Thursday
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationAstgferAllh,
          label: 'استغفر الله',
          enabled: false,
          scheduleType: ScheduleType.everyNMinutes,
          intervalMinutes: 60, // Every hour
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationHasbnaAllh,
          label: 'أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم',
          enabled: false,
          scheduleType: ScheduleType.everyNMinutes,
          intervalMinutes: 60, // Every hour
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationLahawlaWlaquoah,
          label: 'لا حول ولا قوة الا بالله العلي العظيم',
          enabled: false,
          scheduleType: ScheduleType.everyNMinutes,
          intervalMinutes: 60, // Every hour
        ),
        NotificationSettingSeedData(
          key: NotificationKeys.isNotificationSubhanAllh,
          label: 'سبحان الله والحمدلله ولا اله الا الله والله اكبر',
          enabled: false,
          scheduleType: ScheduleType.everyNMinutes,
          intervalMinutes: 60, // Every hour
        ),
     
      ];

      // Insert seed data if it doesn't exist
      for (final seed in seeds) {
        final exists = await db.getByKey(seed.key);
        if (exists == null) {
          await db.upsert(seed.toSettingModel());
          logger.d('Seeded notification setting: ${seed.key}');
        }
      }

      logger.d('Notification settings seeding completed successfully');
    } catch (e) {
      logger.e('Error seeding notification settings: $e');
    }
  }
}
