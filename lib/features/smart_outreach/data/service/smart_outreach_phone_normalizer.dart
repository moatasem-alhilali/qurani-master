/// Turns a phone number into something `tel:` can dial.
///
/// Numbers reach the app from the contacts picker as the user's address book
/// stores them — `+966 50 123 4567`, `(050) 123-4567`, `٠٥٠١٢٣٤٥٦٧`. The
/// native dialer builds a `tel:` URI from the stored string, and spaces and
/// separators break it, so the number is cleaned once on the way in.
///
/// It deliberately does NOT add a country code: the app ships in several
/// countries and a local number without one is dialable where the user is.
abstract final class SmartOutreachPhoneNormalizer {
  /// Characters a `tel:` URI may carry besides digits. `*` and `#` reach IVR
  /// menus; `,` and `;` are dial pauses.
  static const String _allowedSymbols = '*#,;';

  static const String _arabicIndicDigits = '٠١٢٣٤٥٦٧٨٩';
  static const String _easternArabicDigits = '۰۱۲۳۴۵۶۷۸۹';

  /// The dialable form of [raw], or an empty string when nothing is left.
  static String normalize(String raw) {
    final ascii = _toAsciiDigits(raw).trim();
    if (ascii.isEmpty) {
      return '';
    }

    // A leading 00 is the international prefix written out; + is understood
    // everywhere, 00 is not.
    final body = StringBuffer();
    var plus = false;

    for (var i = 0; i < ascii.length; i++) {
      final char = ascii[i];
      if (char == '+') {
        // Only meaningful as the first character.
        if (body.isEmpty && !plus) {
          plus = true;
        }
        continue;
      }
      if (_isDigit(char) || _allowedSymbols.contains(char)) {
        body.write(char);
      }
    }

    var digits = body.toString();
    if (!plus && digits.startsWith('00')) {
      plus = true;
      digits = digits.substring(2);
    }

    if (digits.isEmpty) {
      return '';
    }

    return plus ? '+$digits' : digits;
  }

  /// Digits only, used to compare two numbers for equality. `+966501234567`
  /// and `00966501234567` are the same line.
  static String comparisonKey(String raw) {
    final normalized = normalize(raw);
    return normalized.startsWith('+') ? normalized.substring(1) : normalized;
  }

  /// Whether [raw] has enough digits to be a phone number at all.
  static bool isPlausible(String raw) {
    final digits = comparisonKey(raw).replaceAll(RegExp('[^0-9]'), '');
    return digits.length >= 7;
  }

  static String _toAsciiDigits(String input) {
    final buffer = StringBuffer();
    for (final char in input.split('')) {
      final arabicIndex = _arabicIndicDigits.indexOf(char);
      if (arabicIndex >= 0) {
        buffer.write(arabicIndex);
        continue;
      }
      final easternIndex = _easternArabicDigits.indexOf(char);
      if (easternIndex >= 0) {
        buffer.write(easternIndex);
        continue;
      }
      buffer.write(char);
    }
    return buffer.toString();
  }

  static bool _isDigit(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39;
  }
}
