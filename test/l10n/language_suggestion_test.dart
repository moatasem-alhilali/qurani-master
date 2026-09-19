import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/l10n/l10n.dart';

void main() {
  AppLanguage suggest(List<Locale> locales, [String? zone]) =>
      AppLanguage.suggestFor(locales, timeZoneName: zone);

  test('a supported device language wins over country and time zone', () {
    expect(
      suggest(const [Locale('tr', 'PK')], 'Asia/Karachi'),
      AppLanguage.turkish,
    );
  });

  test('an unsupported language falls back to the device country', () {
    expect(suggest(const [Locale('en', 'PK')]), AppLanguage.urdu);
    expect(suggest(const [Locale('en', 'BD')]), AppLanguage.bengali);
    expect(suggest(const [Locale('ms', 'MY')]), AppLanguage.indonesian);
    expect(suggest(const [Locale('en', 'IR')]), AppLanguage.persian);
  });

  test('no country: the time zone decides', () {
    expect(suggest(const [Locale('en')], 'Asia/Dhaka'), AppLanguage.bengali);
    expect(
        suggest(const [Locale('en')], 'Europe/Istanbul'), AppLanguage.turkish);
  });

  test('nothing matches: Arabic', () {
    expect(suggest(const [Locale('en', 'US')], 'America/New_York'),
        AppLanguage.arabic);
    expect(suggest(const []), AppLanguage.arabic);
  });
}
