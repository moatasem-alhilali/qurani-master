import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/database/notification_configs.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';

/// حدود جدولة «آية اليوم» — ما لا يجوز أن يُعرض لها.
///
/// الاختبار هنا ليس على الشكل بل على ما يحميه: المسار العامّ للمواعيد
/// الإضافية والأنواع الدوريّة كلاهما يُنتج إشعارًا كاذبًا لهذا المفتاح.
void main() {
  const key = NotificationKeys.isNotificationAyahReminder;

  test('المفتاح معلَن أنه يملك جدولته', () {
    expect(NotificationKeys.ownsItsSchedule(key), isTrue);
    expect(
      NotificationKeys.ownsItsSchedule(NotificationKeys.isNotificationReadQuran),
      isFalse,
    );
  });

  test('لا يوجد له NotificationConfig — وهذا سبب إخفاء المواعيد الإضافية', () {
    // الدالّة ترمي للمفتاح غير المسجَّل، فشاشة المواعيد الإضافية تسقط لو
    // عُرض صفّها. هذا الاختبار يربط الإخفاء بسببه: لو سُجِّل المفتاح يومًا
    // في NotificationConfigs لزم إعادة النظر في الإخفاء، لا شطب السطر.
    expect(() => NotificationConfigs.of(key), throwsException);
  });

  test('كل مفتاح يملك جدولته يجب أن يبقى خارج المواعيد الإضافية', () {
    for (final owned in NotificationKeys.featureOwnedScheduleKeys) {
      expect(
        NotificationKeys.ownsItsSchedule(owned),
        isTrue,
        reason: '$owned في القائمة ولا يُقرّ به المُحدِّد',
      );
    }
  });

  group('أنواع الجدولة المعروضة', () {
    test('آية اليوم: يوميّ وأسبوعيّ ومواعيد محدّدة فقط', () {
      final allowed = NotificationKeys.allowedScheduleTypes(key);

      expect(allowed, contains(ScheduleType.daily));
      expect(allowed, contains(ScheduleType.weekly));
      expect(allowed, contains(ScheduleType.customDates));

      // هذان لا يحفظان ساعة، فالمجدول يقرؤهما يوميًّا بينما يقول الوصف
      // «كل خمس دقائق» — إعدادٌ يعرض شيئًا وينفّذ غيره.
      expect(allowed, isNot(contains(ScheduleType.hourly)));
      expect(allowed, isNot(contains(ScheduleType.everyNMinutes)));
    });

    test('بقيّة المفاتيح تبقى على كل الأنواع', () {
      expect(
        NotificationKeys.allowedScheduleTypes(
          NotificationKeys.isNotificationThikrMorning,
        ),
        ScheduleType.values,
      );
    });
  });
}
