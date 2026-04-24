import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';

void main() {
  group('FloatingAdhkarSelector', () {
    test('avoids repeating the same item immediately in mixed mode', () {
      final selector = FloatingAdhkarSelector(random: _FakeRandom(0));
      final settings = FloatingAdhkarSettings(
        enabled: true,
        intervalMinutes: 30,
        visibleSeconds: 20,
        includeBuiltIn: true,
        includeCustom: true,
        mixSources: true,
        lastItemId: 'builtin:a',
        updatedAt: DateTime(2026),
      );

      final result = selector.pickNext(
        settings: settings,
        builtInItems: [
          _builtInItem('builtin:a'),
          _builtInItem('builtin:b'),
        ],
        customItems: [
          _customItem('custom:c'),
        ],
      );

      expect(result, isNotNull);
      expect(result!.id, isNot('builtin:a'));
      expect(result.id, 'builtin:b');
    });

    test('alternates to custom items when last shown item was built in', () {
      final selector = FloatingAdhkarSelector(random: _FakeRandom(0));
      final settings = FloatingAdhkarSettings(
        enabled: true,
        intervalMinutes: 30,
        visibleSeconds: 20,
        includeBuiltIn: true,
        includeCustom: true,
        mixSources: false,
        lastItemId: 'builtin:a',
        lastSourceType: FloatingAdhkarSourceType.builtIn,
        updatedAt: DateTime(2026),
      );

      final result = selector.pickNext(
        settings: settings,
        builtInItems: [
          _builtInItem('builtin:a'),
        ],
        customItems: [
          _customItem('custom:c'),
        ],
      );

      expect(result, isNotNull);
      expect(result!.sourceType, FloatingAdhkarSourceType.custom);
      expect(result.id, 'custom:c');
    });

    test('falls back to the secondary source when the primary source repeats',
        () {
      final selector = FloatingAdhkarSelector(random: _FakeRandom(0));
      final settings = FloatingAdhkarSettings(
        enabled: true,
        intervalMinutes: 30,
        visibleSeconds: 20,
        includeBuiltIn: true,
        includeCustom: true,
        mixSources: false,
        lastItemId: 'builtin:a',
        lastSourceType: FloatingAdhkarSourceType.custom,
        updatedAt: DateTime(2026),
      );

      final result = selector.pickNext(
        settings: settings,
        builtInItems: [
          _builtInItem('builtin:a'),
        ],
        customItems: [
          _customItem('custom:c'),
        ],
      );

      expect(result, isNotNull);
      expect(result!.id, 'custom:c');
    });
  });
}

class _FakeRandom implements Random {
  _FakeRandom(this._value);

  final int _value;

  @override
  bool nextBool() => _value.isEven;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => _value % max;
}

FloatingAdhkarItem _builtInItem(String id) {
  return FloatingAdhkarItem(
    id: id,
    title: 'Built In',
    text: 'Built In Text',
    sourceType: FloatingAdhkarSourceType.builtIn,
    sourceLabel: 'Built In Source',
  );
}

FloatingAdhkarItem _customItem(String id) {
  return FloatingAdhkarItem(
    id: id,
    title: 'Custom',
    text: 'Custom Text',
    sourceType: FloatingAdhkarSourceType.custom,
    sourceLabel: 'Custom Source',
    customAdhkarId: 1,
  );
}
