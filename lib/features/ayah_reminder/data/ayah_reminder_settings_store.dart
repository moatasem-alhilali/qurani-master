import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_source.dart';

/// مصدر آية الإشعار كما اختاره المستخدم.
///
/// في التفضيلات لا في صفّ الإشعار: `NotificationSettingModel` يحمل الجدولة
/// وحدها (ساعة، تكرار، أيام)، وإضافة عمود لخيارٍ يخصّ إشعارًا واحدًا تُثقل
/// جدولًا تشترك فيه ثلاثون إشعارًا.
class AyahReminderSettingsStore {
  AyahReminderSettingsStore({CacheService? cache})
      : _cache = cache ?? CacheService();

  static const String sourceKey = 'AYAH_REMINDER_SOURCE';

  final CacheService _cache;

  AyahReminderSource readSource() =>
      AyahReminderSource.parse(_cache.getString(sourceKey));

  Future<void> writeSource(AyahReminderSource source) =>
      _cache.setString(sourceKey, source.name);
}
