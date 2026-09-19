import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/l10n/l10n.dart';

Map<String, dynamic> _arb(String code) =>
    jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

void main() {
  final template = _arb('ar');
  final templateKeys = _messageKeys(template);

  test('every supported language has a generated L10n', () {
    for (final language in AppLanguage.values) {
      final l10n = lookupL10n(language.locale);
      expect(l10n.localeName, language.code);
      expect(l10n.appName, isNotEmpty);
    }
  });

  test('supportedLocales match AppLanguage', () {
    expect(
      L10n.supportedLocales.map((locale) => locale.languageCode).toSet(),
      AppLanguage.values.map((language) => language.code).toSet(),
    );
  });

  for (final language in AppLanguage.values.where((l) => l.code != 'ar')) {
    group('${language.englishName} (${language.code})', () {
      final arb = _arb(language.code);
      final keys = _messageKeys(arb);

      test('translates every key and nothing stale', () {
        expect(templateKeys.difference(keys), isEmpty, reason: 'missing');
        expect(keys.difference(templateKeys), isEmpty, reason: 'stale');
      });

      test('keeps every declared placeholder', () {
        for (final key in keys.intersection(templateKeys)) {
          final meta = template['@$key'] as Map<String, dynamic>?;
          final declared =
              (meta?['placeholders'] as Map<String, dynamic>?)?.keys ??
                  const <String>[];
          final message = arb[key] as String;
          for (final name in declared) {
            expect(
              message.contains('{$name}') || message.contains('{$name,'),
              isTrue,
              reason: '$key lost {$name}',
            );
          }
        }
      });
    });
  }
}
