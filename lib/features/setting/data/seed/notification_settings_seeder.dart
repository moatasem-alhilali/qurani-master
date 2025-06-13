import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/setting/data/database/database_notification_setting_service.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';

class NotificationSettingsSeeder {
  static final NotificationSettingsSeeder _instance =
      NotificationSettingsSeeder._internal();

  factory NotificationSettingsSeeder() => _instance;

  NotificationSettingsSeeder._internal();

  static const String _hasSeededKey = 'has_seeded_notification_settings';

  Future<void> runIfNeeded() async {
    final alreadySeeded = CacheService().getBool(_hasSeededKey) ?? false;

    if (alreadySeeded) return;

    await _seed();
    await CacheService().setBool(_hasSeededKey, true);
  }

  Future<void> _seed() async {
    final db = sl.get<DatabaseNotificationSettingService>();
    final settings = <String, Map<String, dynamic>>{
      'ISNOTIFY': {'label': 'تشغيل الإشعارات', 'value': true},

      // ── الأذان ─────────────────────────────
      'isNotificationAllAthan': {'label': 'إشعارات جميع الأذان', 'value': true},
      'isNotificationAthanFagr': {'label': 'أذان الفجر', 'value': true},
      'isNotificationAthanDuhr': {'label': 'أذان الظهر', 'value': true},
      'isNotificationAthanAsr': {'label': 'أذان العصر', 'value': true},
      'isNotificationAthanMagrib': {'label': 'أذان المغرب', 'value': true},
      'isNotificationAthanIsha': {'label': 'أذان العشاء', 'value': true},

      // ── أذكار وأوراد ────────────────────────
      'isNotificationMiddleNight': {
        'label': 'قيام الليل',
        'value': false,
        'time': '22:00'
      },
      'isNotificationThikrMorning': {
        'label': 'أذكار الصباح',
        'value': false,
        'time': '7:00'
      },
      'isNotificationThikrNight': {
        'label': 'أذكار المساء',
        'value': false,
        'time': '18:00'
      },
      'isNotificationWridGetup': {
        'label': 'أذكار الاستيقاظ',
        'value': false,
        'time': '7:30'
      },
      'isNotificationWridSleep': {
        'label': 'أذكار النوم',
        'value': false,
        'time': '20:00'
      },

      // ── قراءة وذكر ──────────────────────────
      'isNotificationMohammed': {
        'label': 'الصلاة على محمد ﷺ',
        'value': true,
        'time': '14:00'
      },
      'isNotificationRandomThikr': {'label': 'أذكار عشوائية', 'value': true},

      'isNotificationReadQuran': {
        'label': 'الورد القرآني اليومي',
        'value': false,
        'time': '18:30'
      },
      'isNotificationReadSurahMulk': {
        'label': 'قراءة سورة الملك',
        'value': false,
        'time': '20:10'
      },
      'isNotificationReadSurah': {
        'label': 'قراءة سورة محددة',
        'value': false,
        'time': ''
      },
      'isNotificationReadSurahAlkahf': {
        'label': 'قراءة سورة الكهف',
        'value': false,
        'time': '10:30'
      },

      // ── صيام ────────────────────────────────
      'isNotificationFasting': {
        'label': 'تذكير بالصيام',
        'value': false,
        'time': '20:30'
      },
      'isNotificationFastingMonday': {
        'label': 'صيام الاثنين',
        'value': false,
        'time': '20:30'
      },
      'isNotificationFastingThursday': {
        'label': 'صيام الخميس',
        'value': false,
        'time': '20:30'
      },
    };

    for (final entry in settings.entries) {
      final exists = await db.getByKey(entry.key);
      if (exists == null) {
        await db.upsert(NotificationSettingModel(
          key: entry.key,
          label: entry.value['label'] as String,
          value: entry.value['value'] as bool,
          time: entry.value['time'] as String,
        ));
      }
    }
  }
}
