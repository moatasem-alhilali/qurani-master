import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_phone_normalizer.dart';

void main() {
  group('normalize', () {
    test('strips the separators an address book stores', () {
      // These are the shapes that broke `Uri.parse("tel:$number")`.
      expect(
        SmartOutreachPhoneNormalizer.normalize('+966 50 123 4567'),
        '+966501234567',
      );
      expect(
        SmartOutreachPhoneNormalizer.normalize('(050) 123-4567'),
        '0501234567',
      );
      expect(
        SmartOutreachPhoneNormalizer.normalize('050 123 4567'),
        '0501234567',
      );
    });

    test('converts Arabic-Indic and Eastern Arabic digits', () {
      expect(
        SmartOutreachPhoneNormalizer.normalize('٠٥٠١٢٣٤٥٦٧'),
        '0501234567',
      );
      expect(
        SmartOutreachPhoneNormalizer.normalize('۰۵۰۱۲۳۴۵۶۷'),
        '0501234567',
      );
    });

    test('rewrites a written-out international prefix as +', () {
      expect(
        SmartOutreachPhoneNormalizer.normalize('00966501234567'),
        '+966501234567',
      );
    });

    test('keeps a local number local — no country code is invented', () {
      // The app ships in several countries; guessing one would dial a
      // different line.
      expect(
        SmartOutreachPhoneNormalizer.normalize('0501234567'),
        '0501234567',
      );
    });

    test('keeps the DTMF characters tel: allows', () {
      expect(
        SmartOutreachPhoneNormalizer.normalize('+1 555 0100,,123#'),
        '+15550100,,123#',
      );
    });

    test('drops a plus that is not leading', () {
      expect(SmartOutreachPhoneNormalizer.normalize('050+123'), '050123');
    });

    test('returns empty when nothing dialable is left', () {
      expect(SmartOutreachPhoneNormalizer.normalize(''), '');
      expect(SmartOutreachPhoneNormalizer.normalize('   '), '');
      expect(SmartOutreachPhoneNormalizer.normalize('abc'), '');
      expect(SmartOutreachPhoneNormalizer.normalize('+'), '');
    });
  });

  group('comparisonKey', () {
    test('treats +, 00 and separators as the same line', () {
      const expected = '966501234567';
      expect(
        SmartOutreachPhoneNormalizer.comparisonKey('+966501234567'),
        expected,
      );
      expect(
        SmartOutreachPhoneNormalizer.comparisonKey('00966501234567'),
        expected,
      );
      expect(
        SmartOutreachPhoneNormalizer.comparisonKey('+966 50 123 4567'),
        expected,
      );
    });

    test('does not equate a local number with an international one', () {
      expect(
        SmartOutreachPhoneNormalizer.comparisonKey('0501234567'),
        isNot(SmartOutreachPhoneNormalizer.comparisonKey('+966501234567')),
      );
    });
  });

  group('isPlausible', () {
    test('counts digits, not characters', () {
      // The old check was `phone.length < 7`, so these three disagreed with it.
      expect(SmartOutreachPhoneNormalizer.isPlausible('+966 5 0 1'), isFalse);
      expect(SmartOutreachPhoneNormalizer.isPlausible('٠٥٠١٢٣٤'), isTrue);
      expect(SmartOutreachPhoneNormalizer.isPlausible('(050) 1-2'), isFalse);
    });

    test('rejects text and empty input', () {
      expect(SmartOutreachPhoneNormalizer.isPlausible(''), isFalse);
      expect(SmartOutreachPhoneNormalizer.isPlausible('no number'), isFalse);
    });
  });
}
