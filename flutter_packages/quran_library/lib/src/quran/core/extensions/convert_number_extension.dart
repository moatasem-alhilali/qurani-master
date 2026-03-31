part of '/quran.dart';

/// An extension on the `String` class to convert numbers in the string
/// according to the specified language code.
///
/// This extension provides a method to convert numeric characters in a string
/// to their corresponding characters in different languages such as Arabic,
/// English, Bengali, and Urdu.
///
/// Example usage:
/// ```dart
/// String number = "123";
/// String convertedNumber = number.convertNumbersAccordingToLang(languageCode: 'ar');
/// print(convertedNumber); // Output: ١٢٣
/// ```
///
/// The `convertNumbersAccordingToLang` method takes an optional `languageCode`
/// parameter to specify the target language for conversion. If the `languageCode`
/// is not provided or is not supported, the original string is returned.
///
/// Supported language codes:
/// - 'ar' for Arabic
/// - 'en' for English
/// - 'bn' for Bengali
/// - 'ur' for Urdu
///
/// If the `languageCode` is not supported, the method returns the original string.
///
/// - Parameters:
///   - languageCode: The code of the language to which the numbers should be converted.
/// - Returns: A new string with the numbers converted according to the specified language code.
extension ConvertNumberExtension on String {
  /// Converts the numeric characters in the string to their corresponding
  /// characters in the specified language.
  ///
  /// The [languageCode] parameter specifies the language to which the numbers
  /// should be converted. Supported language codes are:
  /// - 'ar' for Arabic
  /// - 'en' for English
  /// - 'bn' for Bengali
  /// - 'ur' for Urdu
  ///
  /// If [languageCode] is null or not supported, the original string is returned.
  ///
  /// Example:
  /// ```dart
  /// String number = "123";
  /// String converted = number.convertNumbersAccordingToLang(languageCode: 'ar');
  /// print(converted); // Output: ١٢٣
  /// ```
  ///
  /// Returns a new string with the numeric characters converted to the specified
  /// language.
  String convertNumbersAccordingToLang({String? languageCode}) {
    Map<String, Map<String, String>> numberSets = {
      'ar': {
        // Arabic
        '0': '٠',
        '1': '١',
        '2': '٢',
        '3': '٣',
        '4': '٤',
        '5': '٥',
        '6': '٦',
        '7': '٧',
        '8': '٨',
        '9': '٩',
      },
      'en': {
        // English
        '0': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
        '5': '5',
        '6': '6',
        '7': '7',
        '8': '8',
        '9': '9',
      },
      'bn': {
        // Bengali
        '0': '০',
        '1': '১',
        '2': '২',
        '3': '৩',
        '4': '৪',
        '5': '৫',
        '6': '৬',
        '7': '৭',
        '8': '৮',
        '9': '৯',
      },
      'ur': {
        // Urdu
        '0': '۰',
        '1': '۱',
        '2': '۲',
        '3': '۳',
        '4': '۴',
        '5': '۵',
        '6': '۶',
        '7': '۷',
        '8': '۸',
        '9': '۹',
      },
    };

    Map<String, String>? numSet = numberSets[languageCode];

    if (numSet == null) {
      return this;
    }

    String convertedStr = this;

    for (var entry in numSet.entries) {
      convertedStr = convertedStr.replaceAll(entry.key, entry.value);
    }

    return convertedStr;
  }
}
