import 'package:flutter/foundation.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_adapters.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_payload_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_scheduler.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_picker.dart';

/// يملأ طابور «آية اليوم» من عزلة الخلفية.
///
/// الطابور سبعة أيام تُستهلك يومًا بيوم، ومن لا يفتح التطبيق أسبوعًا ينقطع
/// عنه الإشعار — وهو بالضبط المستخدم الذي يُفترض أن يُعيده الإشعار. فيُملأ
/// مع مزامنة الودجات كل 12 ساعة.
///
/// **لا `sl` هنا:** موضِع الخدمات لا يُهيَّأ في عزلة الخلفية، فتُبنى الخدمات
/// يدويًا. ومثلها قابس الإشعارات: `zonedSchedule` يحتاج تهيئته والمنطقة
/// الزمنية في العزلة التي تجدول منها، لا في عزلة الواجهة.
abstract final class AyahReminderBackgroundTopUp {
  /// يعيد `true` إن جُدِّل الطابور، و`false` إن تعذّر ذلك.
  ///
  /// لا يرمي أبدًا: ينادى من موزّع المهامّ الخلفية الذي عمله الأصلي مزامنة
  /// الودجات، وفشلُ إشعارٍ لا يجوز أن يُسقط تلك.
  static Future<bool> run() async {
    try {
      final notifications = NotificationService();
      await notifications.initialize();

      final scheduler = AyahReminderScheduler(
        notificationService: notifications,
        payloadService: AyahReminderPayloadService(),
        picker: AyahReminderPicker(
          mushaf: QuranAyahReminderMushafSource(),
        ),
      );

      final plan = await scheduler.reschedule();
      return plan != null && !plan.isEmpty;
    } catch (error) {
      // `logger` يعيش في `main.dart` مع تهيئة الواجهة؛ في الخلفية يُستعمل
      // `debugPrint` كما تفعل بقيّة مسارات هذه العزلة.
      debugPrint('AyahReminderBackgroundTopUp: failed: $error');
      return false;
    }
  }
}
