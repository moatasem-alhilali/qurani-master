import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/ayah_reminder/domain/ayah_reminder_slots.dart';

void main() {
  group('يوميّ', () {
    test('يبدأ باليوم إن لم يمضِ موعده', () {
      final slots = AyahReminderSlots.daily(
        hour: 20,
        minute: 0,
        now: DateTime(2026, 10, 21, 9),
        count: 3,
      );

      expect(slots, <DateTime>[
        DateTime(2026, 10, 21, 20),
        DateTime(2026, 10, 22, 20),
        DateTime(2026, 10, 23, 20),
      ]);
    });

    test('يبدأ بالغد إن مضى موعد اليوم، ويبقى بطوله الكامل', () {
      final slots = AyahReminderSlots.daily(
        hour: 8,
        minute: 0,
        now: DateTime(2026, 10, 21, 9),
        count: 3,
      );

      // لا موعدًا في الماضي، ولا طابورًا ناقصًا.
      expect(slots, <DateTime>[
        DateTime(2026, 10, 22, 8),
        DateTime(2026, 10, 23, 8),
        DateTime(2026, 10, 24, 8),
      ]);
    });

    test('يتجاوز آخر الشهر', () {
      final slots = AyahReminderSlots.daily(
        hour: 8,
        minute: 0,
        now: DateTime(2026, 10, 30, 9),
        count: 3,
      );

      expect(slots, <DateTime>[
        DateTime(2026, 10, 31, 8),
        DateTime(2026, 11, 1, 8),
        DateTime(2026, 11, 2, 8),
      ]);
    });
  });

  group('أسبوعيّ', () {
    test('يقع على الأيام المختارة وحدها', () {
      // 21 أكتوبر 2026 أربعاء.
      final slots = AyahReminderSlots.weekly(
        weekdays: <int>[DateTime.friday, DateTime.monday],
        hour: 7,
        minute: 30,
        now: DateTime(2026, 10, 21, 9),
        count: 4,
      );

      expect(
        slots.map((slot) => slot.weekday).toList(),
        <int>[DateTime.friday, DateTime.monday, DateTime.friday, DateTime.monday],
      );
      expect(slots.first, DateTime(2026, 10, 23, 7, 30));
    });

    test('يوم واحد في الأسبوع يملأ الطابور على أسابيع', () {
      final slots = AyahReminderSlots.weekly(
        weekdays: <int>[DateTime.friday],
        hour: 7,
        minute: 0,
        now: DateTime(2026, 10, 21, 9),
        count: 7,
      );

      // المدى يتجاوز الأسبوع، فلا يعود بموعدٍ واحد ثم يسكت.
      expect(slots, hasLength(7));
      expect(
        slots.every((slot) => slot.weekday == DateTime.friday),
        isTrue,
      );
      expect(slots.last.difference(slots.first).inDays, 42);
    });

    test('بلا أيام مختارة يُقرأ يوميًّا', () {
      final slots = AyahReminderSlots.weekly(
        weekdays: const <int>[],
        hour: 20,
        minute: 0,
        now: DateTime(2026, 10, 21, 9),
        count: 2,
      );

      expect(slots, <DateTime>[
        DateTime(2026, 10, 21, 20),
        DateTime(2026, 10, 22, 20),
      ]);
    });
  });

  group('مواعيد محدّدة', () {
    test('يُسقط ما مضى ويرتّب الباقي', () {
      final slots = AyahReminderSlots.custom(
        dates: <DateTime>[
          DateTime(2026, 10, 25, 8),
          DateTime(2026, 10, 20, 8),
          DateTime(2026, 10, 22, 8),
        ],
        now: DateTime(2026, 10, 21, 9),
        count: 7,
      );

      expect(slots, <DateTime>[
        DateTime(2026, 10, 22, 8),
        DateTime(2026, 10, 25, 8),
      ]);
    });

    test('لا يتجاوز طول الطابور', () {
      final slots = AyahReminderSlots.custom(
        dates: <DateTime>[
          for (var day = 22; day < 31; day++) DateTime(2026, 10, day, 8),
        ],
        now: DateTime(2026, 10, 21, 9),
        count: 3,
      );

      expect(slots, hasLength(3));
    });
  });
}
