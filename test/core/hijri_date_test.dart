import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/util/hijri_date.dart';

/// Checks [HijriDate] against the official Umm al-Qura calendar.
///
/// The reference days in `test/fixtures/hijri/` were taken from the Saudi
/// High Judiciary Council calendar (HJCoSA) — the same calendar the app's
/// prayer screen claims to show.
///
/// The arithmetic algorithm this class used before was wrong on 477 of these
/// 730 days: 411 off by one day and 66 off by two. The Ramadan boundary drives
/// the Isha adjustment, so the error was not only cosmetic.
void main() {
  group('HijriDate matches the official Umm al-Qura calendar', () {
    late List<({DateTime gregorian, int y, int m, int d})> reference;

    setUpAll(() {
      final dir = Directory('test/fixtures/hijri');
      expect(
        dir.existsSync(),
        isTrue,
        reason: 'reference days missing — see the file header',
      );

      final days = <({DateTime gregorian, int y, int m, int d})>[];
      for (final file in dir.listSync().whereType<File>()) {
        if (!file.path.endsWith('.json')) continue;
        final payload =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        for (final entry in payload['data'] as List<dynamic>) {
          final row = entry as Map<String, dynamic>;
          final g = (row['gregorian'] as Map<String, dynamic>)['date'] as String;
          final h = row['hijri'] as Map<String, dynamic>;
          final parts = g.split('-');
          days.add((
            gregorian: DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            ),
            y: int.parse(h['year'] as String),
            m: (h['month'] as Map<String, dynamic>)['number'] as int,
            d: int.parse(h['day'] as String),
          ));
        }
      }

      days.sort((a, b) => a.gregorian.compareTo(b.gregorian));
      reference = days;
    });

    test('every reference day converts exactly', () {
      expect(reference, isNotEmpty);

      final wrong = <String>[];
      for (final day in reference) {
        final got = HijriDate.fromDate(day.gregorian);
        if (got.year != day.y || got.month != day.m || got.day != day.d) {
          wrong.add(
            '${day.gregorian.toIso8601String().substring(0, 10)}: '
            'got ${got.day}/${got.month}/${got.year}, '
            'official ${day.d}/${day.m}/${day.y}',
          );
        }
      }

      expect(
        wrong,
        isEmpty,
        reason: '${wrong.length} of ${reference.length} days disagree:\n'
            '${wrong.take(10).join('\n')}',
      );
    });

    test('Ramadan is detected on the official boundary', () {
      // The Isha adjustment keys off this, so a one-day slip changes prayer
      // times for a whole night at each end of the month.
      final ramadanDays = reference.where((d) => d.m == HijriDate.ramadanMonth);
      expect(ramadanDays, isNotEmpty);

      for (final day in ramadanDays) {
        expect(
          HijriDate.fromDate(day.gregorian).month,
          HijriDate.ramadanMonth,
          reason: 'missed Ramadan on '
              '${day.gregorian.toIso8601String().substring(0, 10)}',
        );
      }
    });
  });
}
