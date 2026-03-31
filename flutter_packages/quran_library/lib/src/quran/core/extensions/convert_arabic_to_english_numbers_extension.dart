part of '/quran.dart';

/// Extension to convert Arabic numerals to English numerals and vice versa.
///
/// This extension provides two methods to convert numerals between Arabic and
/// English representations. It can be used to convert strings containing Arabic
/// numerals to English numerals and strings containing English numerals to Arabic
/// numerals.
///
/// Example usage:
/// ```dart
/// String arabicToEnglish = "١٢٣".convertArabicNumbersToEnglish();
/// print(arabicToEnglish); // Output: "123"
///
/// String englishToArabic = "123".convertEnglishNumbersToArabic();
/// print(englishToArabic); // Output: "١٢٣"
/// ```
extension ConvertArabicToEnglishNumbersExtension on String {
  /// Converts Arabic numerals in the input string to their English equivalents.
  ///
  /// This function takes a string containing Arabic numerals and returns a new
  /// string where all Arabic numerals have been replaced with their English
  /// counterparts.
  ///
  /// Example:
  /// ```dart
  /// String result = convertArabicNumbersToEnglish("١٢٣");
  /// print(result); // Output: "123"
  /// ```
  ///
  /// - Parameter input: The string containing Arabic numerals to be converted.
  /// - Returns: A new string with Arabic numerals converted to English numerals.
  String convertArabicNumbersToEnglish(String input) {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';

    return input.split('').map((char) {
      int index = arabicNumbers.indexOf(char);
      if (index != -1) {
        return englishNumbers[index];
      }
      return char;
    }).join('');
  }

  /// Converts English numbers in the given input string to their Arabic equivalents.
  ///
  /// This function takes a string containing English numbers and returns a new
  /// string where all English numbers are replaced with their corresponding Arabic
  /// numeral characters.
  ///
  /// Example:
  /// ```dart
  /// String arabicNumbers = convertEnglishNumbersToArabic("123");
  /// print(arabicNumbers); // Outputs: "١٢٣"
  /// ```
  ///
  /// - Parameter input: The input string containing English numbers.
  /// - Returns: A new string with English numbers converted to Arabic numerals.
  String convertEnglishNumbersToArabic(String input) {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';

    return input.split('').map((char) {
      int index = englishNumbers.indexOf(char);
      if (index != -1) {
        return arabicNumbers[index];
      }
      return char;
    }).join('');
  }
}
