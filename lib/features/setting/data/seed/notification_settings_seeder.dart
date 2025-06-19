import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_seed_data.dart';

class NotificationSettingsSeeder {
  factory NotificationSettingsSeeder() => _instance;
  NotificationSettingsSeeder._internal();
  static final NotificationSettingsSeeder _instance =
      NotificationSettingsSeeder._internal();

  static const String _hasSeededKey = 'has_seeded_notification_settings';

  Future<void> runIfNeeded() async {
    final alreadySeeded = CacheService().getBool(_hasSeededKey) ?? false;
    if (alreadySeeded) return;
    await _seed();
    await CacheService().setBool(_hasSeededKey, true);
  }

  Future<void> _seed() async {
    final db = DatabaseNotificationSettingService();

    // مرونة في جدولة كل إشعار:
    // - daily: يحتاج hour/minute
    // - everyNMinutes: يحتاج intervalMinutes
    // - weekly: يحتاج weekdays/hour/minute
    // - customDates: يحتاج customDates
    // - others: scheduleType فقط
    final seeds = <NotificationSettingSeedData>[
      // Master enable/disable (بدون جدولة)
      NotificationSettingSeedData(
        key: NotificationKeys.isNotify,
        label: 'تشغيل الإشعارات',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 0,
        minute: 0,
      ),
      // Athan notifications
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAllAthan,
        label: 'إشعارات جميع الأذان',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 0,
        minute: 0,
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAthanFagr,
        label: 'أذان الفجر',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 4,
        minute: 20,
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAthanDuhr,
        label: 'أذان الظهر',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 12,
        minute: 0,
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAthanAsr,
        label: 'أذان العصر',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 15,
        minute: 30,
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAthanMagrib,
        label: 'أذان المغرب',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 18,
        minute: 15,
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationAthanIsha,
        label: 'أذان العشاء',
        enabled: true,
        scheduleType: ScheduleType.daily,
        hour: 19,
        minute: 30,
      ),
      // Azkar & other reminders
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
      // Mohammed Salawat every hour example (can be more advanced)
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationMohammed,
        label: 'الصلاة على محمد ﷺ',
        enabled: true,
        scheduleType: ScheduleType.hourly,
        minute: 10, // every hour at 10min
      ),
      // Random Thikr every 10 minutes as an example
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationRandomThikr,
        label: 'أذكار عشوائية',
        enabled: true,
        scheduleType: ScheduleType.everyNMinutes,
        intervalMinutes: 10,
      ),
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
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationReadSurahAlkahf,
        label: 'قراءة سورة الكهف',
        enabled: false,
        scheduleType: ScheduleType.weekly,
        hour: 10,
        minute: 30,
        weekdays: [5], // الجمعة
      ),
      // Fasting notifications
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationFasting,
        label: 'تذكير بالصيام',
        enabled: false,
        scheduleType: ScheduleType.weekly,
        hour: 20,
        minute: 30,
        weekdays: [1, 4], // الاثنين والخميس
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationFastingMonday,
        label: 'صيام الاثنين',
        enabled: false,
        scheduleType: ScheduleType.weekly,
        hour: 20,
        minute: 30,
        weekdays: [1], // الاثنين
      ),
      NotificationSettingSeedData(
        key: NotificationKeys.isNotificationFastingThursday,
        label: 'صيام الخميس',
        enabled: false,
        scheduleType: ScheduleType.weekly,
        hour: 20,
        minute: 30,
        weekdays: [4], // الخميس
      ),
    ];

    for (final seed in seeds) {
      final exists = await db.getByKey(seed.key);
      if (exists == null) {
        await db.upsert(seed.toSettingModel());
      }
    }
  }
}
