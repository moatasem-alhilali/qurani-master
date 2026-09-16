import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_ids.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_payload.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';

const _riyadh = PrayerLocationSelection(
  latitude: 24.7136,
  longitude: 46.6753,
  label: 'الرياض',
  source: PrayerLocationSource.device,
  utcOffsetMinutes: 180,
  locality: 'الرياض',
  administrativeArea: 'منطقة الرياض',
  country: 'السعودية',
);

Map<String, Object?> _build(
  DateTime now, {
  List<WidgetVerse> pool = const [],
  List<Map<String, Object?>> previous = const [],
}) {
  return HomeWidgetPayloadBuilder.build(
    now: now,
    location: _riyadh,
    settings: PrayerCalculationSettings.defaults,
    versePool: pool,
    previousVerses: previous,
  );
}

List<Map<String, Object?>> _days(Map<String, Object?> payload) =>
    (payload['days']! as List).cast<Map<String, Object?>>();

List<Map<String, Object?>> _prayers(Map<String, Object?> day) =>
    (day['prayers']! as List).cast<Map<String, Object?>>();

/// Riyadh wall clock (UTC+3) of an absolute instant, as "HH:mm".
String _riyadhClock(int epochMillis) {
  final t = DateTime.fromMillisecondsSinceEpoch(epochMillis, isUtc: true)
      .add(const Duration(hours: 3));
  return '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  // 12:00 Riyadh on 2026-09-15.
  final noonRiyadh = DateTime.utc(2026, 9, 15, 9);

  test('computes the configured number of days with six ordered times', () {
    final days = _days(_build(noonRiyadh));

    expect(days, hasLength(HomeWidgetIds.daysAhead));
    for (final day in days) {
      final at = [for (final p in _prayers(day)) p['at']! as int];
      expect(at, hasLength(6));
      for (var i = 1; i < at.length; i++) {
        expect(at[i], greaterThan(at[i - 1]), reason: 'day ${day['date']}');
      }
    }
  });

  test('stores true instants: Riyadh Isha lands in the evening, not +3h', () {
    final today = _days(_build(noonRiyadh)).first;
    final prayers = {for (final p in _prayers(today)) p['key']: p};

    // Umm al-Qura: Maghrib ~18:10, Isha = Maghrib + 90 min in mid-September.
    final isha = _riyadhClock(prayers['isha']!['at']! as int);
    expect(isha.compareTo('19:20') > 0 && isha.compareTo('20:00') < 0, isTrue,
        reason: 'Isha at $isha Riyadh time');

    final fajr = _riyadhClock(prayers['fajr']!['at']! as int);
    expect(fajr.compareTo('04:00') > 0 && fajr.compareTo('05:00') < 0, isTrue,
        reason: 'Fajr at $fajr Riyadh time');
  });

  test('displayed label matches the stored instant', () {
    final today = _days(_build(noonRiyadh)).first;
    for (final prayer in _prayers(today)) {
      final clock = _riyadhClock(prayer['at']! as int);
      final hour24 = int.parse(clock.substring(0, 2));
      final minute = clock.substring(3);
      final expected = DateFormat.jm('ar').format(
        DateTime(2026, 9, 15, hour24, int.parse(minute)),
      );
      expect(prayer['time'], expected, reason: '${prayer['key']}');
    }
  });

  test('day starts on the city date, not the UTC date', () {
    // 01:30 Riyadh on the 16th is still the 15th in UTC.
    final afterMidnightRiyadh = DateTime.utc(2026, 9, 15, 22, 30);
    final days = _days(_build(afterMidnightRiyadh));
    expect(days.first['date'], '2026-09-16');
  });

  test('date keys stay Latin even when the default locale is Arabic', () {
    final previous = Intl.defaultLocale;
    Intl.defaultLocale = 'ar';
    addTearDown(() => Intl.defaultLocale = previous);

    final days = _days(_build(noonRiyadh));
    expect(days.first['date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
  });

  test('sunrise is kept for display but flagged as not a prayer', () {
    final today = _days(_build(noonRiyadh)).first;
    final flags = {for (final p in _prayers(today)) p['key']: p['isPrayer']};
    expect(flags['sunrise'], isFalse);
    expect(
      flags.entries
          .where((e) => e.key != 'sunrise')
          .every((e) => e.value == true),
      isTrue,
    );
  });

  group('verses', () {
    final pool = [
      for (var i = 0; i < 50; i++)
        WidgetVerse(text: 'ayah $i', source: 'source $i'),
    ];

    test('one verse per day, stable across repeated syncs', () {
      final morning = _build(DateTime.utc(2026, 9, 15, 3), pool: pool);
      final evening = _build(DateTime.utc(2026, 9, 15, 17), pool: pool);

      final first = (morning['verses']! as List).first as Map;
      final again = (evening['verses']! as List).first as Map;
      expect(first['date'], '2026-09-15');
      expect(again['text'], first['text']);
    });

    test('keeps previous future verses when the Quran cannot load', () {
      final previous = [
        {'date': '2026-09-14', 'text': 'old', 'source': 's'},
        {'date': '2026-09-15', 'text': 'today', 'source': 's'},
        {'date': '2026-09-16', 'text': 'tomorrow', 'source': 's'},
      ];
      final verses = (_build(noonRiyadh, previous: previous)['verses']! as List)
          .cast<Map>();

      expect([for (final v in verses) v['text']], ['today', 'tomorrow']);
    });
  });

  test('no saved location produces an empty schedule instead of throwing', () {
    final payload = HomeWidgetPayloadBuilder.build(
      now: noonRiyadh,
      location: null,
      settings: null,
      versePool: const [],
    );
    expect(payload['days'], isEmpty);
    expect(payload['location'], isNull);
    expect(payload['version'], HomeWidgetIds.payloadVersion);
  });

  test('stable index is deterministic and in range', () {
    const key = '2026-09-15';
    final index = HomeWidgetPayloadBuilder.stableIndex(key, 97);
    expect(HomeWidgetPayloadBuilder.stableIndex(key, 97), index);
    expect(index, inInclusiveRange(0, 96));
  });
}
